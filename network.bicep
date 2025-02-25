param location string
param vnetName string
param vnetAddressPrefixes array
param vmSubnetName string
param vmSubnetPrefix array
param bastionSubnetName string
param bastionSubnetPrefix array
param vmNSGName string = '${vmSubnetName}-nsg'
param bastionNSGName string = '${bastionSubnetName}-nsg'
param bastionHostName string

// network security groups
module vmNSG_M 'vm-nsg.bicep' = {
  name: 'vmNSGDeployment'
  params: {
    name: vmNSGName
    location: location
  }
}

module bastionNSG_M 'bastion-nsg.bicep' = {
  name: 'bastionNSGDeployment'
  params: {
    name: bastionNSGName
    location: location
  }
}

// vNet
resource vnet_R 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  dependsOn: [
    vmNSG_M
    bastionNSG_M
  ]
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefixes
    }
    subnets: [
      {
        name: vmSubnetName
        properties: {
          addressPrefix: vmSubnetPrefix[0]
          networkSecurityGroup: {
            id: resourceId('Microsoft.Network/networkSecurityGroups', vmNSGName)
          }
        }
      }
      {
        name: bastionSubnetName
        properties: {
          addressPrefix: bastionSubnetPrefix[0]
          networkSecurityGroup: {
            id: resourceId('Microsoft.Network/networkSecurityGroups', bastionNSGName)
          }
        }
      }
    ]
  }
}

// Bastion stuff
resource bastionPublicIP_R 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: '${bastionHostName}-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource bastionHost_R 'Microsoft.Network/bastionHosts@2023-04-01' = {
  name: bastionHostName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    scaleUnits: 2
    dnsName: bastionHostName
    disableCopyPaste: false
    enableFileCopy: true
    enableShareableLink: false
    enableTunneling: true
    ipConfigurations: [
      {
        name: '${bastionHostName}-ipConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: bastionPublicIP_R.id
          }
          subnet: {
            id: vnet_R.properties.subnets[1].id
          }
        }
      }
    ]
  }
}
