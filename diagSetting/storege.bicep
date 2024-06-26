param storageAccountSku string = 'Standard_LRS'
param location string = resourceGroup().location

var storageNameBase = 'st${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = [
  for index in range(0, 3): {
    name: '${storageNameBase}${index}'
    location: location
    sku: {
      name: storageAccountSku
    }
    kind: 'StorageV2'
  }
]

output storageAccounts array = [for i in range(0, 3): storageAccount[i]]
