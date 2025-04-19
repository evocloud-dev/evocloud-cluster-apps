"aws-subnet": {
	type: "component"
	alias: ""
	description: "AWS VPC Subnet provided by EvoCloud"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	// awsSubnet: https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/v0.52.3/resources/ec2.aws.crossplane.io/Subnet/v1beta1
  output: {
  	apiVersion: "ec2.aws.crossplane.io/v1beta1"
  	kind: "Subnet"
  	metadata: {
      name: parameter.subnetName
      namespace: parameter.defaultNamespace
    }
    spec: {
    	forProvider: {
    		availabilityZone: parameter.availabilityZone
    		mapPublicIPOnLaunch: true
    		cidrBlock: parameter.subnetAddressCidr
    		region: parameter.defaultRegion
    		vpcIdRef: {
    			name: parameter.virtualNetworkName
    		}
    		tags: [
    			{
    				key: "Name"
    				value: parameter.subnetName
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
		//+usage=Subnetwork name.
		subnetName: string
		//+usage=Default Namespace under which resources are grouped.
		defaultNamespace: string
		//+usage=Subnetwork IP address cidr range.
		subnetAddressCidr: *"10.10.10.0/24" | string
		//+usage=Subnetwork availability zone.
		availabilityZone: *"us-east-2c" | string
		//+usage=Default region to create the subnet in.
		defaultRegion: *"us-east-2" | string
		//+usage=AWS VPC network name.
		virtualNetworkName: *"evocloud-paas-vnet" | string
		//+usage=AWS IaaS Provider config name (do not alter this value).
		providerConfigName: *"provider-aws-config" | string
	}
}
