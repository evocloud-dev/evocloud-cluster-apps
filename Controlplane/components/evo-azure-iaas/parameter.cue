// parameter.cue is used to store addon parameters.
// You can use these parameters in template.cue or in resources/ by 'parameter.myparam'

parameter: {
  //+usage=providerName defining the type of IaaS Provide to use. Defaults to provider-azure
  providerName: *"provider-azure" | string
  providerConfigName: *"provider-azure-config" | string
  AZURE_APP_ID: string
  AZURE_PASSWORD: string
  AZURE_TENANT_ID: string
  AZURE_SUBSCRIPTION_ID: string
  AZURE_AD_ENDPOINT: *"https://login.microsoftonline.com/" | string
  AZURE_RESOURCE_MANAGER_ENDPOINT: *"https://management.azure.com/" | string
  AZURE_AD_GRAPH_RESOURCE: *"https://graph.windows.net/" | string
  AZURE_SQL_MANAGEMENT_ENDPOINT: *"https://management.core.windows.net:8443/" | string
  AZURE_GALLERY_ENDPOINT: *"https://gallery.azure.com/" | string
  AZURE_MANAGEMENT_ENDPOINT: *"https://management.core.windows.net/" | string

  location: *"eastus2" | string
  resourceGroupName: *"evocloud-paas" | string

}