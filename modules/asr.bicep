// =========== asr.bicep ===========

targetScope = 'resourceGroup'

param asrRsvName string
param location string
param workspaceID string 


var skuName = 'RS0'
var skuTier = 'Standard'
var asrAutomationAccountName = 'aa-${asrRsvName}'

resource asrRSV 'Microsoft.RecoveryServices/vaults@2022-02-01' = {
  name: asrRsvName
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

resource asrAutomationAccount 'Microsoft.Automation/automationAccounts@2020-01-13-preview' = {
  name: asrAutomationAccountName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}
