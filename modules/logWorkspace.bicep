// =========== logWorkspace.bicep ===========

targetScope = 'resourceGroup'

param location string 

var logAnalyticsWorspaceName= 'log-demo'

resource logAnalyticsWorspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorspaceName
  location: location
  properties: {}
}

output LogAnalyticsWorkspaceID string = logAnalyticsWorspace.id
