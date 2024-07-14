param location string
param adfResourceName string = 'adf-${uniqueString(resourceGroup().id)}'
param storageAccountId string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: adfResourceName
  location: location
  properties: {
    publicNetworkAccess: 'Enabled'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource managedVirtualNetwork 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' = {
  parent: dataFactory
  name: 'default'
  properties: {
    virtualNetworkType: 'Managed'
  }
}

resource autoResolveIntegrationRuntime 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  parent: dataFactory
  name: 'AutoResolveIntegrationRuntime'
  properties: {
    type: 'Managed'
    managedVirtualNetwork: {
      type: 'ManagedVirtualNetworkReference'
      referenceName: managedVirtualNetwork.name
    }
    typeProperties: {
      computeProperties: {
        location: 'AutoResolve'
      }
    }
  }
}

resource managedPrivateEndpoint 'Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints@2018-06-01' = {
  parent: managedVirtualNetwork
  name: 'AzureBlobStorageEndpoint'
  properties: {
    privateLinkResourceId: storageAccountId
    groupId: 'blob'
  }
}
