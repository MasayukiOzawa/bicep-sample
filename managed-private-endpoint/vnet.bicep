param location string
param vnetAddressPrefixes array = ['10.144.0.0/20']
param vnetSubnetAddressPrefix string = cidrSubnet(vnetAddressPrefixes[0], 24,0)
param vnetName string = 'vnet-myVnet'
param snetName string = 'snet-mySubnet'

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name:  vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefixes
    }
    subnets: [
      {
        name: snetName
        properties: {
          addressPrefix: vnetSubnetAddressPrefix
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output subnets array = vnet.properties.subnets
output subnetId string = filter(vnet.properties.subnets, (subnet, index) => subnet.name == '${snetName}')[0].id
