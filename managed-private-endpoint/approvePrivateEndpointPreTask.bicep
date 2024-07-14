param storageAccountName string

resource storage 'Microsoft.Storage/storageAccounts@2023-04-01' existing = {
  name: storageAccountName
}

output storagePrivateEndpointConnections array = filter(storage.properties.privateEndpointConnections, (item, index) => item.properties.privateLinkServiceConnectionState.status == 'Pending')
