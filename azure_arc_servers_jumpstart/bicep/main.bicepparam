using 'main.bicep'

param spnTenantId = '<your spn tenant id>'

param windowsAdminUsername = 'arcdemo'

param windowsAdminPassword = '<your windows admin password>'

param logAnalyticsWorkspaceName = '<your unique Log Analytics workspace name>'

param deployBastion = false

param rdpPort = '3389'

param emailAddress = '<Your email address for alerts>'
