param name string
param location string

resource UGRvNetvmsnnsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: name
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-remoteConnactions'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '22'
            '3389'
          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}
