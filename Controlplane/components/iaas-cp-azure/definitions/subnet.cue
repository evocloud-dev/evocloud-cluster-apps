"azure-subnet": {
    type:        "component"
    description: "Component for deploying an Azure Subnet powered by EvoCloud/Crossplane."
    attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
    output: {
        apiVersion: "network.azure.crossplane.io/v1alpha3"
        kind:       "Subnet"
        metadata: {
            name: parameter.Name
        }
        spec: {
            properties: {
                addressPrefix: parameter.AddressPrefix
            }

            providerConfigRef: {
                name: parameter.providerConfigName
            }

            resourceGroupNameRef:  {
                name: parameter.ResourceGroupName
            }

            virtualNetworkNameRef: {
                name: parameter.VirtualNetworkName
            }
        }
    }

    parameter: {
        // +usage=Specify the name of the Subnet.
        Name: string

        // +usage=Specify the IP Address CIDR for the Subnet. Example: "10.0.10.0/24".
        AddressPrefix: string

		// +usage=Specify the name of the Azure ProviderConfig to use. This should match the ProviderConfig you configured for Azure, defaults to `iaas-cp-azure-provider`
        providerConfigName: *"iaas-cp-azure-provider" | string

        // +usage=Specify the Resource Group name. Ensure it exists already in your Azure Account.
        ResourceGroupName: string

        // +usage=Specify the name of the Virtual Network
        VirtualNetworkName: string
    }
}