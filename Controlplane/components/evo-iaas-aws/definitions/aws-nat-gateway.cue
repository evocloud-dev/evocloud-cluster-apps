"aws-nat-gateway": {
	type: "component"
	alias: ""
	description: "AWS VPC NAT Gateway provided by EvoCloud"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	// awsNATGateway: https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/v0.52.3/resources/ec2.aws.crossplane.io/NATGateway/v1beta1
  output: {
  	apiVersion: "ec2.aws.crossplane.io/v1beta1"
  	kind: "NATGateway"
  	metadata: {
      name: parameter.natGatewayName
      namespace: parameter.defaultNamespace
    }
    spec: {
    	forProvider: {
    		region: parameter.defaultRegion
    		allocationIdRef: {
    			name: parameter.ipAllocationName
    		}
    		subnetIdRef: {
    			name: parameter.subnetName
    		}
    		tags: [
    			{
    				key: "Name"
    				value: parameter.natGatewayName
    			},
    			{
    				key: "Provider"
    				value: "EvoCloud"
    			}
    		]
    	}
    	providerConfigRef: {
    		name: parameter.providerConfigName
    	}
    }
  }

  //parameter
	parameter: {
		//+usage=NAT Gateway name.
		natGatewayName: string
		//+usage=Default Namespace under which resources are grouped.
		defaultNamespace: string
		//+usage=Subnetwork name.
		subnetName: string
		//+usage=IP Allocation for the NAT Gateway.
		ipAllocationName: string
		//+usage=Default region to deploy the NAT Gateway.
		defaultRegion: *"us-east-2" | string
		//+usage=AWS IaaS Provider config name (do not alter this value).
		providerConfigName: *"provider-aws-config" | string
	}
}
