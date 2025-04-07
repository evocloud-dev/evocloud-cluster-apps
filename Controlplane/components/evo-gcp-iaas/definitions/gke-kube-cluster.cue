"gke-kube-cluster": {
	type: "component"
	alias: ""
	description: "Google Kubernetes Engine provided by EvoCloud"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	// gkeCluster: https://marketplace.upbound.io/providers/crossplane-contrib/provider-gcp/v0.22.0/resources/container.gcp.crossplane.io/Cluster/v1beta2
  output: {
  	apiVersion: "container.gcp.crossplane.io/v1beta2"
  	kind: "Cluster"
  	metadata: {
      name: parameter.gkeClusterName
      namespace: parameter.defaultNamespace
    }
    spec: {
    	forProvider: {
    		initialClusterVersion: "latest"
    		releaseChannel: {
    			channel: "REGULAR"
    		}
    		description: parameter.gkeClusterDescription
    		location: parameter.defaultRegion
    		loggingService: "logging.googleapis.com/kubernetes"
    		monitoringService: "monitoring.googleapis.com/kubernetes"
    		ipAllocationPolicy: {
    			useIpAliases: true
    			//Getting Error 400: Services CIDR range is smaller than minimum (14 < 16)
    			//clusterIpv4CidrBlock: parameter.clusterIpv4CidrBlock
    			//servicesIpv4CidrBlock: parameter.servicesIpv4CidrBlock
    		}
    		networkRef: {
    			name: parameter.virtualNetworkName
    		}
    		subnetworkRef: {
    			name: parameter.subnetName
    		}
    		workloadIdentityConfig: {
    			workloadPool: parameter.projectId + ".svc.id.goog"
    		}
    	}
    	providerConfigRef: {
    		name: parameter.providerConfigName
    	}
    	writeConnectionSecretToRef: {
    		name: parameter.gkeSecretName
    		namespace: parameter.defaultNamespace
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
			//clusterIpv4CidrBlock: *"10.96.0.0/14" | string
			//servicesIpv4CidrBlock: *"10.80.0.0/14" | string

			gkeNodepoolName: *"evo-gke-nodepool"  | string
			gkeMachineType: *"n1-standard-1" | string
			gkeDiskSizeGb: *100 | int
			gkeDiskType: *"pd-ssd" | string
			gkeImageType: *"cos_container" | string
			gkeMaxNodeCount: *5 | int
			gkeDefaultZones: *["us-central1-a", "us-central1-b", "us-central1-c"] | [...string]
			gkeSetPreemptible: *false | bool
	}
}
