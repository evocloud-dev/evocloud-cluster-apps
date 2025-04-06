"gcs-bucket": {
	type: "component"
	alias: ""
	description: "Google Cloud Storage Bucket provided by EvoCloud"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	// gcsBucket: https://marketplace.upbound.io/providers/crossplane-contrib/provider-gcp/v0.22.0/resources/storage.gcp.crossplane.io/Bucket/v1alpha3
  output: {
  	apiVersion: "storage.gcp.crossplane.io/v1alpha3"
  	kind: "Bucket"
  	metadata: {
      name: parameter.bucketName
      namespace: parameter.defaultNamespace
    }
    spec: {
    	location: parameter.location
    	storageClass: "STANDARD"
    	providerConfigRef: {
    		name: parameter.providerConfigName
    	}

    }
  }

  //parameter
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
			defaultRegion: string
			subnetDescription: *"Subnet created by EvoCloud Controller" | string

			gatewayName: "evo-nat-gateway" | string
			gatewayDescription: "Gateway Routed created by EvoCloud Controller" | string

			gkeClusterName: *"evo-gkecluster-01" | string
			gkeSecretName: *"evo-gkeconfig" | string
			gkeClusterDescription: *"Google Kubernetes Engine created by EvoCloud Controller" | string
			clusterIpv4CidrBlock: *"10.245.0.0/16" | string
      servicesIpv4CidrBlock: *"10.80.0.0/12" | string
	}

}
