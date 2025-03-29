import "encoding/json"

"azure-provider-config": {
	type: "component"
	alias: ""
	labels: {}
  annotations: {}
  description: "Azure ProviderConfig powered by Crossplane"
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
            clientId:     parameter.AZURE_APP_ID
            clientSecret: parameter.AZURE_PASSWORD
            tenantId:     parameter.AZURE_TENANT_ID
            subscriptionId: parameter.AZURE_SUBSCRIPTION_ID
            activeDirectoryEndpointUrl: parameter.AZURE_AD_ENDPOINT
					  resourceManagerEndpointUrl: parameter.AZURE_RESOURCE_MANAGER_ENDPOINT
            activeDirectoryGraphResourceId: parameter.AZURE_AD_GRAPH_RESOURCE
            sqlManagementEndpointUrl: parameter.AZURE_SQL_MANAGEMENT_ENDPOINT
            galleryEndpointUrl: parameter.AZURE_GALLERY_ENDPOINT
            managementEndpointUrl: parameter.AZURE_MANAGEMENT_ENDPOINT
          })
    	}
  	}

  }

  //Reason for defining parameters inline: parameters from root folder was not seen
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
