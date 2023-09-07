targetScope = 'subscription'

/******************************/
/*         PARAMETERS         */
/******************************/

@description('The common suffix used when naming resources')
param nameSuffix string = 'demo2'

@description('Primary Region for ASR e.g EastUS, WestUS etc.')
param asrPrimaryLocation string = 'eastus'

@description('Secondary Region for ASR e.g EastUS, WestUS etc.')
param asrSecondaryLocation string = 'northcentralus'

@description('Name of the resource group that contains Azure Site Recovery.')
param asrRgName string = 'rg-ASR-${nameSuffix}'

@description('Name of the resource group that contains Azure Resources in the primary location.')
param asrPrimaryResourcesRgName string = 'rg-BCDR-Primary-${nameSuffix}'

@description('Name of the resource group that contains Azure Resources in the Secondary location.')
param asrSecondaryResourcesRgName string = 'rg-BCDR-Secondary-${nameSuffix}'

@description('Name of the resource group that contains Azure Backup Resources.')
param backupRgName string = 'rg-Backup-${nameSuffix}'

@description('Name of the Recovery Servcies Vault resource for Backup.')
param backupRsvName string = 'rsv-backup-${nameSuffix}'

@description('Name of the Backup Vault resource for Backup.')
param backupVltName string = 'bvault-backup-${nameSuffix}'

@description('Name of the Recovery Servcies Vault resource for ASR.')
param asrRsvName string = 'rsv-asr-${nameSuffix}'

@description('Username for the Virtual Machines.')
param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Tags')
param tags object= {}

/******************************/
/*     RESOURCES & MODULES    */
/******************************/
resource asrRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: asrRgName
  location: asrSecondaryLocation
  tags: tags
}

resource asrPrimaryRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: asrPrimaryResourcesRgName
  location: asrPrimaryLocation
  tags: tags
}

resource asrSecondaryRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: asrSecondaryResourcesRgName
  location: asrSecondaryLocation
  tags: tags
}

resource backupRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: backupRgName
  location: asrPrimaryLocation
  tags: tags
  
}

//Deploying Log Analytics Worksapce in Primary Location
module logAnalytics './modules/logWorkspace.bicep' = {
  name: 'logAnalyticsDeployment'
  dependsOn: [
    asrPrimaryRg
  ]
  scope: resourceGroup(asrPrimaryResourcesRgName)
  params: {    
    location: asrPrimaryLocation
  }
}

// Deploying Backup Vaults in Primary Location
module backup './modules/backup.bicep' = {
  name: 'backupDeployment'
  dependsOn: [
    backupRg
    logAnalytics
  ]
  scope: resourceGroup(backupRgName) 
  params: {    
    backupRsvName: backupRsvName
    backupVltName: backupVltName
    workspaceID: logAnalytics.outputs.LogAnalyticsWorkspaceID
    location: asrPrimaryLocation
  }
}

// Deploying ASR in Secondary Location
module asr './modules/asr.bicep' = {
  name: 'asrDeployment'
  dependsOn: [
    asrRg
    logAnalytics
  ]
  scope: resourceGroup(asrRgName) 
  params: {    
    asrRsvName: asrRsvName
    location: asrSecondaryLocation
    workspaceID: logAnalytics.outputs.LogAnalyticsWorkspaceID
  }
}

// Deploying Resources for Primary Location
module PrimaryResources './modules/asrPrimaryResources.bicep' = {
  name: 'primaryAsrDeployment'
  dependsOn: [
    asrPrimaryRg
    logAnalytics
  ]
  scope: resourceGroup(asrPrimaryResourcesRgName) 
  params: {    
    location: asrPrimaryLocation
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

// Deploying ASR Resources for Secondary Location

module asrSecondaryResources './modules/asrSecondaryResources.bicep' = {
  name: 'asrDeployment'
  dependsOn: [
    asrSecondaryRg
    logAnalytics
  ]
  scope: resourceGroup(asrSecondaryResourcesRgName) 
  params: {    
    location: asrSecondaryLocation    
    }
}
