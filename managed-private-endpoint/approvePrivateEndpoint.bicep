param storageAccountName string 
param storagePrivateEndpointConnections array

resource storage 'Microsoft.Storage/storageAccounts@2023-04-01' existing = {
  name: storageAccountName
}

resource privateEndpointConnection 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2023-04-01' = [for (resource,index) in storagePrivateEndpointConnections : {
  name: resource.name
  parent: storage
  properties: {
    privateLinkServiceConnectionState: {
      status: 'Approved'
    }
  }
}]
