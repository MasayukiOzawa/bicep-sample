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

// ストレージアカウントの診断設定
resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' existing = [
  for (storageAccount, index) in storageAccounts: {
    name: storageAccount.name
  }
]
resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (storageAccount, index) in storageAccounts: {
    name: replace(diagBaseName, '{0}', storageAccount.name)
    scope: storage[index]
    properties: {
      metrics: metrics
      workspaceId: workspaceId
    }
  }
]

// ストレージアカウントの BLOB についての診断設定
resource blob 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' existing = [
  for (storageAccount, index) in storageAccounts: {
    name: 'default'
    parent: storage[index]
  }
]
resource diagnosticBlobSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (storageAccount, index) in storageAccounts: if (contains(storageAccount.name, 'stjb6gfh2nnkvfe0')) {
    name: '${replace(diagBaseName, '{0}', storageAccount.name)}-blob'
    scope: blob[index]
    properties: {
      logs: blobLogSetting
      metrics: metrics
      workspaceId: workspaceId
    }
  }
]
