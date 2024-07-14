param logAnalyticsId string = resourceId('Microsoft.OperationalInsights/workspaces', 'log-myLogAnalyticsWorkspace')

resource storage 'Microsoft.Storage/storageAccounts@2023-04-01' existing = {
  name: 'stjb6gfh2nnkvfe0'
}

resource storageDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-${storage.name}'
  scope: storage
  dependsOn: [
    storage
  ]
  properties: {
    workspaceId: logAnalyticsId
    logs: []
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy: { days: 0, enabled: false }
      }
      {
        category: 'Capacity'
        enabled: false
        retentionPolicy: { days: 0, enabled: false }
      }
    ]
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-04-01' existing = {
  name: 'default'
  parent: storage
}

resource blobServiceDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-${storage.name}-blob'
  scope: blobService
  dependsOn: [
    blobService
  ]
  properties: {
    workspaceId: logAnalyticsId
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: { days: 0, enabled: false }
      }
      {
        categoryGroup: 'audit'
        enabled: false
        retentionPolicy: { days: 0, enabled: false }
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy: { days: 0, enabled: false }
      }
      {
        category: 'Capacity'
        enabled: false
        retentionPolicy: { days: 0, enabled: false }
      }
    ]
  }
}
resource blobServiceSecurityDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-${storage.name}-blob-security'
  scope: blobService
  dependsOn: [
    blobService
  ]
  properties: {
    workspaceId: logAnalyticsId
    logs: [
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: { days: 0, enabled: false }
      }
      {
        categoryGroup: 'allLogs'
        enabled: false
        retentionPolicy: { days: 0, enabled: false }
      }
    ]
    metrics: [
      {
        category: 'Capacity'
        enabled: false
        retentionPolicy: { days: 0, enabled: false }
      }
      {
        category: 'Transaction'
        enabled: false
        retentionPolicy: { days: 0, enabled: false }
      }
    ]
  }
}

resource fileService 'Microsoft.Storage/storageAccounts/fileServices@2023-04-01' existing = {
  name: 'default'
  parent: storage
}

resource fileServiceDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-${storage.name}-file'
  scope: fileService
  dependsOn: [
    fileService
  ]
  properties: {
    workspaceId: logAnalyticsId
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: { days: 0, enabled: false }
      }
      {
        categoryGroup: 'audit'
        enabled: false
        retentionPolicy: { days: 0, enabled: false }
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy: { days: 0, enabled: false }
      }
      {
        category: 'Capacity'
        enabled: false
        retentionPolicy: { days: 0, enabled: false }
      }
    ]
  }
}

resource fileServiceSecurityDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-${storage.name}-file-security'
  scope: fileService
  dependsOn: [
    fileService
  ]
  properties: {
    workspaceId: logAnalyticsId
    logs: [
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: { days: 0, enabled: false }
      }
      {
        categoryGroup: 'allLogs'
        enabled: false
        retentionPolicy: { days: 0, enabled: false }
      }
    ]
    metrics: [
      {
        category: 'Capacity'
        enabled: false
        retentionPolicy: { days: 0, enabled: false }
      }
      {
        category: 'Transaction'
        enabled: false
        retentionPolicy: { days: 0, enabled: false }
      }
    ]
  }
}
