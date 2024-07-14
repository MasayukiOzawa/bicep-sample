var location = resourceGroup().location
var storageAccountName = 'st${uniqueString(resourceGroup().id)}'

module vnet 'vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location
  }
}

module storage 'storage.bicep' = {
  name: 'storage'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}

module privateEndpoint  'privateEndpoint.bicep' = {
  name: 'privateEndpoint'
  params: {
    location: location
    storageAccountId: storage.outputs.storageAccountId
    vnetId: vnet.outputs.vnetId
    subnetId: vnet.outputs.subnetId
  }
}

module dataFactory 'dataFactory.bicep' = {
  name: 'dataFactory'
  params: {
    location: location
    storageAccountId: storage.outputs.storageAccountId
  }
}

module approvePrivateEndpointPreTask 'approvePrivateEndpointPreTask.bicep' = {
  name : 'approvePrivateEndpointPreTask'
  dependsOn: [
    dataFactory
  ]
  params : {
    storageAccountName: storage.outputs.storageAccountName
  }
}

module approvePrivateEndpoint 'approvePrivateEndpoint.bicep' = {
  name : 'approvePrivateEndpoint'
  params : {
    storageAccountName: storage.outputs.storageAccountName
    storagePrivateEndpointConnections: approvePrivateEndpointPreTask.outputs.storagePrivateEndpointConnections
  }
}
