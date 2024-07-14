param logAnalyticsId string = resourceId('Microsoft.OperationalInsights/workspaces', 'log-myLogAnalyticsWorkspace')

param storageTargets array = [
  { name: 'stjb6gfh2nnkvfe0', logAnalyticsWorkspaceId: logAnalyticsId }
  { name: 'stjb6gfh2nnkvfe1', logAnalyticsWorkspaceId: logAnalyticsId }
]

resource storage 'Microsoft.Storage/storageAccounts@2023-04-01' existing = [
  for (resource, index) in storageTargets: {
    name: resource.name
  }
]

resource storageDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (resource, index) in storageTargets: {
    name: 'diag-${resource.name}'
    scope: storage[index]
    dependsOn: [
      storage
    ]
    properties: {
      workspaceId: resource.logAnalyticsWorkspaceId
      logs: []
      metrics: [
        {
          category: 'Transaction'
          enabled: true
        }
      ]
    }
  }
]


resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-04-01' existing = [
  for (resource, index) in storageTargets: {
    name: 'default'
    parent: storage[index]
  }
]

resource blobServiceDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (resource, index) in storageTargets: {
    name: 'diag-${resource.name}-blob'
    scope: blobService[index]
    dependsOn: [
      blobService[index]
    ]
    properties: {
      workspaceId: resource.logAnalyticsWorkspaceId
      logs: [
        {
          categoryGroup: 'allLogs'
          enabled: true
        }
      ]
      metrics: [
        {
          category: 'Transaction'
          enabled: true
        }
      ]
    }
  }
]
resource blobServiceSecurityDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (resource, index) in storageTargets: {
    name: 'diag-${resource.name}-blob-security'
    scope: blobService[index]
    dependsOn: [
      blobService[index]
    ]
    properties: {
      workspaceId: resource.logAnalyticsWorkspaceId
      logs: [
        {
          categoryGroup: 'audit'
          enabled: true
        }
      ]
    }
  }
]


resource fileService 'Microsoft.Storage/storageAccounts/fileServices@2023-04-01' existing = [
  for (resource, index) in storageTargets: {
    name: 'default'
    parent: storage[index]
  }
]

resource fileServiceDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (resource, index) in storageTargets: {
    name: 'diag-${resource.name}-file'
    scope: fileService[index]
    dependsOn: [
      fileService[index]
    ]
    properties: {
      workspaceId: resource.logAnalyticsWorkspaceId
      logs: [
        {
          categoryGroup: 'allLogs'
          enabled: true
        }
      ]
      metrics: [
        {
          category: 'Transaction'
          enabled: true
        }
      ]
    }
  }
]

resource fileServiceSecurityDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (resource, index) in storageTargets: {
    name: 'diag-${resource.name}-file-security'
    scope: fileService[index]
    dependsOn: [
      fileService[index]
    ]
    properties: {
      workspaceId: resource.logAnalyticsWorkspaceId
      logs: [
        {
          categoryGroup: 'audit'
          enabled: true
        }
      ]
      metrics: []
    }
  }
]
