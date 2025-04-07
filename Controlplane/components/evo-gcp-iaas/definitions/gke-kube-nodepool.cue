"gke-kube-nodepool": {
	type: "component"
	alias: ""
	description: "Google Kubernetes Engine NodePool provided by EvoCloud"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	// gkeNodePool: https://marketplace.upbound.io/providers/crossplane-contrib/provider-gcp/v0.22.0/resources/container.gcp.crossplane.io/NodePool/v1beta1
  output: {
  	apiVersion: "container.gcp.crossplane.io/v1beta1"
  	kind: "NodePool"
  	metadata: {
      name: parameter.gkeNodepoolName
      namespace: parameter.defaultNamespace
    }
    spec: {
    	forProvider: {
    		clusterRef: {
    			name: parameter.gkeClusterName
    		}
    		locations: parameter.gkeDefaultZones
    		initialNodeCount: 3
    		autoscaling: {
    			enabled: true
    			autoprovisioned: false
    			minNodeCount: parameter.gkeMinNodeCount
    			maxNodeCount: parameter.gkeMaxNodeCount
    		}
    		config: {
    			machineType: parameter.gkeMachineType
    			diskSizeGb: parameter.gkeDiskSizeGb
    			diskType: parameter.gkeDiskType
    			imageType: parameter.gkeImageType
    			labels: {
    				created_by: "evocloud-controller"
    			}
    			oauthScopes: ["https://www.googleapis.com/auth/cloud-platform", "https://www.googleapis.com/auth/monitoring"]
    			preemptible: parameter.gkeSetPreemptible
    		}
    	}
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
			clusterIpv4CidrBlock: *"10.96.0.0/14" | string
			servicesIpv4CidrBlock: *"10.80.0.0/14" | string

			gkeNodepoolName: *"evo-gke-nodepool"  | string
			gkeMachineType: *"n1-standard-1" | string
			gkeDiskSizeGb: *100 | int
			gkeDiskType: *"pd-ssd" | string
			gkeImageType: *"cos_containerd" | string
			gkeMinNodeCount: *1 | int
			gkeMaxNodeCount: *5 | int
			gkeDefaultZones: *["us-central1-a", "us-central1-b", "us-central1-c"] | [...string]
			gkeSetPreemptible: *false | bool
	}
}
