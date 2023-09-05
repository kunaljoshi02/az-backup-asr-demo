// =========== asrSecondaryResources.bicep ===========

targetScope = 'resourceGroup'

param location string 
param workspaceID string

var vmSubnetName = 'snet-vms'
var secondaryVnetName = 'vnet-secondary' 
var secVmNsgName = 'nsg-vms'

resource secondaryVnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: secondaryVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: vmSubnetName
        properties: {
          addressPrefix: '10.1.1.0/24'
          networkSecurityGroup: {
            id: secVmNsg.id
          }
        }
      }
    ]
  }  
}

resource secVmNsg 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: secVmNsgName
  location: location
  properties: {
    securityRules: [       
    ]
  }
}
