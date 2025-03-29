"azure-rg": {
	type: "component"
	alias: ""
	description: "Azure Resource Group powered by Crossplane"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"



}

template: {
	//azureresourceGroup: https://marketplace.upbound.io/providers/crossplane-contrib/provider-azure/v0.20.1/resources/azure.crossplane.io/ResourceGroup/v1alpha3
	output: {
		apiVersion: "azure.crossplane.io/v1alpha3"
		kind:       "ResourceGroup"
		metadata: {
      name: parameter.resourceGroupName
    }
    spec: {
    	location: parameter.location
    	providerConfigRef: {
    		name: parameter.providerConfigName
    	}
    }
	}

	//parameter
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
}
