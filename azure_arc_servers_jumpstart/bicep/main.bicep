@description('Azure AD tenant id for your service principal')
param spnTenantId string

@description('Username for Windows account')
param windowsAdminUsername string

@description('Password for Windows account. Password must have 3 of the following: 1 lower case character, 1 upper case character, 1 number, and 1 special character. The value must be between 12 and 123 characters long')
@minLength(12)
@maxLength(123)
@secure()
param windowsAdminPassword string

//@description('Enable automatic logon into ArcBox Virtual Machine')
//param vmAutologon bool = true

@description('Override default RDP port using this parameter. Default is 3389. No changes will be made to the client VM.')
param rdpPort string = '3389'

@description('Name for your log analytics workspace')
param logAnalyticsWorkspaceName string = 'ArcBoxWorkspace'

//@description('The flavor of ArcBox you want to deploy.')
//@allowed([
//  'ITPro'
//])
//param flavor string = 'ITPro'

@description('Target GitHub account')
param githubAccount string = 'azure'

@description('Target GitHub branch')
param githubBranch string = 'psconfeu'

@description('Choice to deploy Bastion to connect to the client VM')
param deployBastion bool = false

//@description('User github account where they have forked https://github.com/microsoft/azure-arc-jumpstart-apps')
//param githubUser string = 'microsoft'

@description('Azure location to deploy all resources')
param location string = resourceGroup().location

@description('Your email address to configure alerts.')
param emailAddress string

var vmAutologon = true

var githubUser = 'microsoft'

var flavor = 'ITPro'

var templateBaseUrl = 'https://raw.githubusercontent.com/${githubAccount}/arc_jumpstart_levelup/${githubBranch}/azure_arc_servers_jumpstart/'

module clientVmDeployment 'clientVm/clientVm.bicep' = {
  name: 'clientVmDeployment'
  params: {
    windowsAdminUsername: windowsAdminUsername
    windowsAdminPassword: windowsAdminPassword
    azdataPassword: windowsAdminPassword
    spnTenantId: spnTenantId
    workspaceName: logAnalyticsWorkspaceName
    stagingStorageAccountName: stagingStorageAccountDeployment.outputs.storageAccountName
    templateBaseUrl: templateBaseUrl
    flavor: flavor
    subnetId: mgmtArtifactsAndPolicyDeployment.outputs.subnetId
    deployBastion: deployBastion
    githubUser: githubUser
    location: location
    vmAutologon: vmAutologon
    rdpPort: rdpPort
    changeTrackingDCR: dataCollectionRules.outputs.changeTrackingDCR
    vmInsightsDCR: dataCollectionRules.outputs.vmInsightsDCR
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
    flavor: flavor
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
    mgmtArtifactsAndPolicyDeployment
  ]
  params: {
    azureLocation: location
    changeTrackingDCR: dataCollectionRules.outputs.changeTrackingDCR
    vmInsightsDCR: dataCollectionRules.outputs.vmInsightsDCR
    //logAnalyticsWorkspaceId: workspace.id
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

