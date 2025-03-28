"iaas-cp-azure-rg": {
	type:        "component"
	description: "Component for deploying an Azure Resource Group powered by EvoCloud/Crossplane."
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	output: {
		apiVersion: "azure.crossplane.io/v1alpha3"
		kind:       "ResourceGroup"
		metadata:
			name: parameter.Name

		spec: {
			location: parameter.Location

			providerConfigRef: {
				name: parameter.providerConfigName
			}
		}
	}

	parameter: {
		// +usage=Specify the Resource Group name
		Name: string

		// +usage=Specify the location where the Resource Group will be created. Examples: "eastus2", "australiaeast". Refer to: https://learn.microsoft.com/en-us/azure/reliability/regions-list/ | https://gist.github.com/ausfestivus/04e55c7d80229069bf3bc75870630ec8#file-azureregiondata-md for the Azure region names reference.
		Location: string

		// +usage=The name of the Azure ProviderConfig to use. This should match the provider you configured for Azure, defaults to `iaas-cp-azure-provider`
		providerConfigName: *"iaas-cp-azure-provider" | string
	}
}