param location string = resourceGroup().location
param workspaceName string = 'log-myLogAnalyticsWorkspace'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

output workspaceId string = logAnalyticsWorkspace.id
