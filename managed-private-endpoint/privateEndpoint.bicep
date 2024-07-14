param location string
param vnetId string
param subnetId string
param storageAccountId string

param privateEndpointName string = 'pep-myPrivateEndpoint'

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'linkConnection-${privateEndpointName}'
        properties: {
          privateLinkServiceId: storageAccountId
          groupIds: [
            'blob'
          ]
          privateLinkServiceConnectionState: {
            status: 'Pending'
          }
        }
      }
    ]
    customNetworkInterfaceName: 'nic-${privateEndpointName}'
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.blob.${environment().suffixes.storage}'
  location: 'global'
}

resource virtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'link-${privateEndpointName}'
  parent: privateDnsZone
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: vnetId
    }
  }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
  name: 'zoneGroup-${privateEndpointName}'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'zoneConfig-${privateEndpointName}'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}
