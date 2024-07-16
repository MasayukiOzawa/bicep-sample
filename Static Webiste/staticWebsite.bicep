var location = resourceGroup().location
var storageAccountName = 'st${uniqueString(resourceGroup().id)}'

resource storage 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

resource customScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'customScript'
  location: location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '12.0'
    environmentVariables: [
      {
        name: 'storageAccountKey'
        secureValue: storage.listKeys().keys[0].value
      }
    ]
    arguments: '-storageAccountName ${storage.name}'
    scriptContent: '''
    param($storageAccountName)
    $context = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $ENV:storageAccountKey
    Enable-AzStorageStaticWebsite -Context $context
    '''
    retentionInterval: 'PT1H'
  }
}
