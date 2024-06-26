module storage './storege.bicep' = {
  name: 'storageDeploy'
}

module logAnalytics './logAnalytics.bicep' = {
  name: 'logAnalyticsDeploy'
}

module diag './diagSetting.bicep' = {
  name: 'diagSettingDeploy'
  params: {
    storageAccounts: storage.outputs.storageAccounts
    workspaceId: logAnalytics.outputs.workspaceId
  }
  dependsOn: [
    storage
  ]
}
