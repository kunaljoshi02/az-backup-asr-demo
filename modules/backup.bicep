// =========== backup.bicep ===========

targetScope = 'resourceGroup'

param backupRsvName string
param backupVltName string
param workspaceID string
param location string 


var skuName = 'RS0'
var skuTier = 'Standard'

resource backupRSV 'Microsoft.RecoveryServices/vaults@2022-02-01' = {
  name: backupRsvName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {}
}

resource backupRsvNameconfig 'Microsoft.RecoveryServices/vaults/backupstorageconfig@2022-02-01' = {
  parent: backupRSV
  name: 'vaultstorageconfig'
  properties: {
    storageModelType: 'GeoRedundant'
    crossRegionRestoreFlag: true
  }
}

resource backupRSV_diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: backupRSV
  name: 'diagnostics'
  properties: {
    workspaceId: workspaceID
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        
      }
    ]
  }
}

resource backupVlt 'Microsoft.DataProtection/backupVaults@2022-11-01-preview' = {
  name: backupVltName
  location: location
  properties: {
    storageSettings:[
      {
      datastoreType: 'VaultStore'
      type: 'GeoRedundant'
      }
    ]
  }
}

resource backupVlt_diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: backupVlt
  name: 'diagnostics'
  properties: {
    workspaceId: workspaceID
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        
      }
    ]
  }
}
