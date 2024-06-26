param storageAccounts array
param workspaceId string

param blobLogSetting array = [
  { categoryGroup: 'allLogs', enabled: true }
  { categoryGroup: 'audit', enabled: true }
]
param metrics array = [
  { category: 'Transaction', enabled: true }
]
param diagBaseName string = 'diag-{0}'

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' existing = [
  for (storageAccount, index) in storageAccounts: {
    name: last(split(storageAccounts[index].ResourceId, '/'))
  }
]
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (storageAccount, index) in storageAccounts: {
    name: replace(diagBaseName, '{0}', last(split(storageAccounts[index].ResourceId, '/')))
    scope: storage[index]
    properties: {
      logs: []
      metrics: metrics
      workspaceId: workspaceId
    }
  }
]

resource blob 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' existing = [
  for (storageAccount, index) in storageAccounts: {
    name: 'default'
    parent: storage[index]
  }
]
resource diagnosticBlobSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (storageAccount, index) in storageAccounts: if (contains(storageAccount.ResourceId, 'stjb6gfh2nnkvfe0') || contains(
    storageAccount.ResourceId,
    'stjb6gfh2nnkvfe1'
  )) {
    name: '${replace(diagBaseName, '{0}', last(split(storageAccounts[index].ResourceId, '/')))}-blob'
    scope: blob[index]
    properties: {
      logs: blobLogSetting
      metrics: metrics
      workspaceId: workspaceId
    }
  }
]
