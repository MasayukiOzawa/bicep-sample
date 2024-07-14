param location string
param storageAccountName string

resource storage 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    publicNetworkAccess: 'Disabled'
  }
}

output storageAccountName string = storage.name
output storageAccountId string = storage.id
