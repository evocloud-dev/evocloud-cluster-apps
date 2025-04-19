import "encoding/json"

"gcp-provider-config": {
	type: "component"
	alias: ""
	labels: {}
  annotations: {}
  description: "Google Cloud ProviderConfig provided by EvoCloud"
  attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	//gcpProviderConfig: https://marketplace.upbound.io/providers/crossplane-contrib/provider-gcp/v0.22.0/resources/gcp.crossplane.io/ProviderConfig/v1beta1
  output: {
  	apiVersion: "gcp.crossplane.io/v1beta1"
  	kind:       "ProviderConfig"
  	metadata: {
      name: parameter.providerConfigName
    }
    spec: {
    	projectID: parameter.projectId
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
            type:     parameter.accountType
            project_id: parameter.projectId
            private_key_id: parameter.privateKeyId
            private_key:     parameter.privateKey
            client_email: parameter.clientEmail
					  client_id: parameter.clientId
            auth_uri: parameter.authUri
            token_uri: parameter.tokenUri
            auth_provider_x509_cert_url: parameter.authProviderX509CertUrl
            client_x509_cert_url: parameter.clientX509CertUrl
            universe_domain: parameter.universeDomain
          })
    	}
  	}

  }

  //parameters
  parameter: {
			//+usage=providerName defining the type of the IaaS Provider to use. Defaults to `provider-gcp`
			providerName: *"provider-gcp" | string
			//+usage=providerConfigName defining the config name of the IaaS Provider to use. Defaults to `provider-gcp-config`
			providerConfigName: *"provider-gcp-config" | string
			//+usage=providerGcpVersion: https://marketplace.upbound.io/providers/crossplane-contrib/provider-gcp/v0.22.0/resources/gcp.crossplane.io/Provider/v1alpha3
			providerGcpVersion: *"v0.22.0" | string
			projectId: string
			accountType: *"service_account" | string
			privateKeyId: string
			privateKey: string
			clientEmail: string
			clientId: string
			authUri: *"https://accounts.google.com/o/oauth2/auth" | string
			tokenUri: *"https://oauth2.googleapis.com/token" | string
			authProviderX509CertUrl: *"https://www.googleapis.com/oauth2/v1/certs" | string
			clientX509CertUrl: string
			universeDomain: *"googleapis.com" | string

			bucketName: string
			defaultNamespace: string
			location: *"US" | string

			virtualNetworkName: *"evocloud-paas-vnet" | string
			firewallRuleName: *"evocloud-firewall-rules" | string
			ruleDescription: *"Default rules from automation" | string
			sourceRanges: *["0.0.0.0/0"] | [...string]
			trafficDirection: *"INGRESS" | string
			allowRules: [...{...}]

			subnetName: string
			subnetAddressCidr: string
			defaultRegion: *"us-central1" | string
			subnetDescription: *"Subnet created by EvoCloud Controller" | string

			gatewayName: *"evo-nat-gateway" | string
			gatewayDescription: *"Gateway Routed created by EvoCloud Controller" | string

			gkeClusterName: *"evo-gkecluster-01" | string
			gkeSecretName: *"evo-gkeconfig" | string
			gkeClusterDescription: *"Google Kubernetes Engine created by EvoCloud Controller" | string
			clusterIpv4CidrBlock: *"10.96.0.0/14" | string
			servicesIpv4CidrBlock: *"10.200.0.0/16" | string

			gkeNodepoolName: *"evo-gke-nodepool"  | string
			gkeMachineType: *"n1-standard-1" | string
			gkeDiskSizeGb: *100 | int
			gkeDiskType: *"pd-ssd" | string
			gkeImageType: *"cos_containerd" | string
			gkeMinNodeCount: *3 | int
			gkeMaxNodeCount: *5 | int
			gkeDefaultZones: *["us-central1-a", "us-central1-b", "us-central1-c"] | [...string]
			gkeSetPreemptible: *false | bool
	}
}
