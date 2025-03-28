"azure-vnet": {
    type:        "component"
    description: "Component for deploying Azure Virtual Network powered by EvoCloud/Crossplane."
    attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
    output: {
        apiVersion: "network.azure.crossplane.io/v1alpha3"
        kind:       "VirtualNetwork"
        metadata: {
            name: parameter.Name
        }
        spec: {
            location: parameter.Location

            properties: {
                addressSpace: {
                    addressPrefixes: parameter.AddressPrefixes
                }
            }

            providerConfigRef: {
                name: parameter.providerConfigName
            }

            resourceGroupName:  parameter.ResourceGroupName
        }
    }

    parameter: {
        // +usage=Specify the name of the Virtual Network.
        Name: string

        // +usage=Specify the Resource Group name. Ensure it exists already in your Azure Account.
        ResourceGroupName: string

        // +usage=Specify the location/region where you want your Virtual Network to be created. Examples: "eastus2", "australiaeast". Refer to: https://learn.microsoft.com/en-us/azure/reliability/regions-list/ | https://gist.github.com/ausfestivus/04e55c7d80229069bf3bc75870630ec8#file-azureregiondata-md for the Azure region names reference.
        Location: string

        // +usage=Specify the IP Address CIDRs for the Virtual Network. You can provide more than one address space if needed. Example: ["10.0.0.0/16", "10.1.0.0/16"].
        AddressPrefixes: [...string]

		// +usage=The name of the Azure ProviderConfig to use. This should match the ProviderConfig you configured for Azure, defaults to `iaas-cp-azure-provider`
        providerConfigName: *"iaas-cp-azure-provider" | string
    }
}