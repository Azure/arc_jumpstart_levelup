@description('Azure AD tenant id for your service principal')
param spnTenantId string = tenant().tenantId

@description('Client Machine SKU')
@allowed([
  'Standard_E8s_v5'
  'Standard_E8s_v4'
  'Standard_E8s_v3'
])
param clientVmSku string


@description('Username for Windows account')
param windowsAdminUsername string

@description('Password for Windows account. Password must have 3 of the following: 1 lower case character, 1 upper case character, 1 number, and 1 special character. The value must be between 12 and 123 characters long')
@minLength(12)
@maxLength(123)
@secure()
param windowsAdminPassword string

@description('Name for your log analytics workspace')
param logAnalyticsWorkspaceName string

@description('Target GitHub account')
param githubAccount string = 'Azure'

@description('Target GitHub branch')
param githubBranch string = 'main'

var deployBastion = false

@description('Override default RDP port 3389 using this parameter. Default is 3389. No changes will be made to the client VM.')
param rdpPort string = '3389'

@description('Override default SSH port 22 using this parameter. Default is 22. No changes will be made to the client VM.')
param sshPort string = '22'

@description('Your email address to configure alerts.')
param emailAddress string

param location string = resourceGroup().location

var templateBaseUrl = 'https://raw.githubusercontent.com/${githubAccount}/arc_jumpstart_levelup/${githubBranch}/azure_arc_servers_jumpstart/'

module clientVmDeployment 'clientVm/clientVm.bicep' = {
  name: 'clientVmDeployment'
  params: {
    windowsAdminUsername: windowsAdminUsername
    windowsAdminPassword: windowsAdminPassword
    spnTenantId: spnTenantId
    workspaceName: logAnalyticsWorkspaceName
    stagingStorageAccountName: stagingStorageAccountDeployment.outputs.storageAccountName
    templateBaseUrl: templateBaseUrl
    subnetId: mgmtArtifactsAndPolicyDeployment.outputs.subnetId
    deployBastion: deployBastion
    location: location
    rdpPort: rdpPort
    sshPort: sshPort
//    vmAutologon: vmAutologon
    changeTrackingDCR: dataCollectionRules.outputs.changeTrackingDCR
    vmInsightsDCR: dataCollectionRules.outputs.vmInsightsDCR
    clientVmSku: clientVmSku
  }
}

module stagingStorageAccountDeployment 'mgmt/mgmtStagingStorage.bicep' = {
  name: 'stagingStorageAccountDeployment'
  params: {
    location: location
  }
}

module mgmtArtifactsAndPolicyDeployment 'mgmt/mgmtArtifacts.bicep' = {
  name: 'mgmtArtifactsAndPolicyDeployment'
  params: {
    workspaceName: logAnalyticsWorkspaceName
    deployBastion: deployBastion
    location: location
  }
}

module monitoringResources 'mgmt/monitoringResources.bicep' = {
  name: 'monitoringResources'
  params: {
    workspaceId: mgmtArtifactsAndPolicyDeployment.outputs.workspaceId
    workspaceName: logAnalyticsWorkspaceName
    location: location
    emailAddress: emailAddress
  }
}

module policyDeployment 'mgmt/policyAzureArc.bicep' = {
  name: 'policyDeployment'
  dependsOn: [
//    mgmtArtifactsAndPolicyDeployment
  ]
  params: {
    azureLocation: location
    changeTrackingDCR: dataCollectionRules.outputs.changeTrackingDCR
  }
}

module dataCollectionRules 'mgmt/mgmtDataCollectionRules.bicep' = {
  name: 'dataCollectionRules'
  params: {
    workspaceLocation: location
    workspaceName: logAnalyticsWorkspaceName
    workspaceResourceId: mgmtArtifactsAndPolicyDeployment.outputs.workspaceId
  }
}
