import "encoding/json"

"azure-provider-config": {
	type: "component"
	alias: ""
	labels: {}
  annotations: {}
  description: "Azure ProviderConfig provided by EvoCloud"
  attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	//azureProviderConfig: https://marketplace.upbound.io/providers/crossplane-contrib/provider-azure/v0.20.1/resources/azure.crossplane.io/ProviderConfig/v1beta1
  output: {
  	apiVersion: "azure.crossplane.io/v1beta1"
  	kind:       "ProviderConfig"
  	metadata: {
      name: parameter.providerConfigName
    }
    spec: {
    	credentials: {
    		source: "Secret"
    		type: "Opaque"
    		secretRef: {
    			name: parameter.providerName + "-account-creds"
    			namespace: "vela-system"
    			key:       "creds"
    		}
    	}
    }
  }

  //Creates the secret referenced in the output template
  outputs: {
  	"credential": {
  		apiVersion: "v1"
  		kind: "Secret"
  		metadata: {
  			name: parameter.providerName + "-account-creds"
  			namespace: "vela-system"
  		}
  		stringData: {
    			creds: json.Marshal({
            clientId:     parameter.azureClientId
            clientSecret: parameter.azureClientSecret
            subscriptionId: parameter.azureSubscriptionId
            tenantId:     parameter.azureTenantId
            activeDirectoryEndpointUrl: parameter.azureActiveDirectoryEndpointUrl
					  resourceManagerEndpointUrl: parameter.azureResourceManagerEndpointUrl
            activeDirectoryGraphResourceId: parameter.azureActiveDirectoryGraphResourceId
            sqlManagementEndpointUrl: parameter.azureSqlManagementEndpointUrl
            galleryEndpointUrl: parameter.azureGalleryEndpointUrl
            managementEndpointUrl: parameter.azureManagementEndpointUrl
          })
    	}
  	}

  }

  //Reason for defining parameters inline: parameters from root folder was not seen
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
