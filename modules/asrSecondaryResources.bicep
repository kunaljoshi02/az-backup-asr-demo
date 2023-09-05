// =========== asrSecondaryResources.bicep ===========

targetScope = 'resourceGroup'

param location string 

var vmSubnetName = 'snet-vms'
var secondaryVnetName = 'vnet-secondary'
var secondaryTestVnetName = 'vnet-secondary-test' 
var secVmNsgName = 'nsg-vms'

resource secVmNsg 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: secVmNsgName
  location: location
  properties: {
    securityRules: [       
    ]
  }
}

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

resource secondaryTestVnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: secondaryTestVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.200.0.0/16'
      ]
    }
    subnets: [
      {
        name: vmSubnetName
        properties: {
          addressPrefix: '10.200.0.0/24'
          networkSecurityGroup: {
            id: secVmNsg.id
          }
        }
      }
    ]
  }  
}
