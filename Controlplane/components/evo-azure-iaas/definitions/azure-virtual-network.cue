"azure-vnet": {
	type: "component"
	alias: ""
	description: "Azure Virtual Network provided by EvoCloud"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	// azureVirtualNetwork https://marketplace.upbound.io/providers/crossplane-contrib/provider-azure/v0.20.1/resources/network.azure.crossplane.io/VirtualNetwork/v1alpha3
  output: {
  	apiVersion: "network.azure.crossplane.io/v1alpha3"
  	kind: "VirtualNetwork"
  	metadata: {
      name: parameter.virtualNetworkName
      namespace: parameter.resourceGroupNamespace
    }
    spec: {
    	location: parameter.location
    	providerConfigRef: {
    		name: parameter.providerConfigName
    	}
    	resourceGroupNameRef: {
    		name: parameter.resourceGroupName
    	}
    	properties: {
    		addressSpace: {
    			addressPrefixes: parameter.addressPrefixes
    		}
    	}
    }
  }

  //parameter
  parameter: {
  	//+usage=providerName defining the type of the IaaS Provider to use. Defaults to `provider-azure`
			providerName: *"provider-azure" | string
			//+usage=providerConfigName defining the config name of the IaaS Provider to use. Defaults to `provider-azure-config`
			providerConfigName: *"provider-azure-config" | string
			//+usage=providerAzureVersion: https://marketplace.upbound.io/providers/crossplane-contrib/provider-azure/v0.20.1/resources/azure.crossplane.io/Provider/v1alpha3
			providerAzureVersion: *"v0.20.1" | string

			//+usage=Run the following Azure CLI command to create a service principal and get the required values:
				// az ad sp create-for-rbac --json-auth true --role Owner --scopes="/subscriptions/<your-subscription-id>" -n "evocloud-azure-sp" > "creds.json"
				// Use the `clientId`, `clientSecret`, `subscriptionId`, and `tenantId`, from the generated `creds.json` file.
			azureClientId: string
			azureClientSecret: string
			azureSubscriptionId: string
			azureTenantId: string
			azureActiveDirectoryEndpointUrl: *"https://login.microsoftonline.com/" | string
			azureResourceManagerEndpointUrl: *"https://management.azure.com/" | string
			azureActiveDirectoryGraphResourceId: *"https://graph.windows.net/" | string
			azureSqlManagementEndpointUrl: *"https://management.core.windows.net:8443/" | string
			azureGalleryEndpointUrl: *"https://gallery.azure.com/" | string
			azureManagementEndpointUrl: *"https://management.core.windows.net/" | string

			//+usage=location defining the default location of the IaaS resources will be created. Defaults to `eastus2`
			location: *"East US 2" | string
			//+usage=resourceGroupName defining the name of the Azure IaaS resource group. Defaults to `evocloud-paas`
			resourceGroupName: *"evocloud-paas" | string
			//+usage=resourceGroupNamespace defines the namespace where the resource group object will be stored. Defaults to `vela-system`
			resourceGroupNamespace: *"vela-system" | string
			//+usage=virtualNetworkName defines the name of the the Azure IaaS Vnet. Defaults to `evocloud-paas-vnet`
			virtualNetworkName: *"evocloud-paas-vnet" | string
			//+usage=addressPrefixes defines the range of IP addresses (CIDR block) the Azure Virtual Network can use. Defaults to ["10.10.0.0/16", "192.168.0.0/16"].
			addressPrefixes: *["10.10.0.0/16", "192.168.0.0/16"] | [...string]

  }
}
