// =========== asr.bicep ===========

targetScope = 'resourceGroup'

param asrName string
param location string
param workspaceID string 


var skuName = 'RS0'
var skuTier = 'Standard'

resource asrRSV 'Microsoft.RecoveryServices/vaults@2022-02-01' = {
  name: asrName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {}
}

resource asrRSV_diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: asrRSV
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
