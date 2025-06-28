"aws-elastic-ip": {
	type: "component"
	alias: ""
	description: "AWS Elastic IP Address resource provided by EvoCloud"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	// awsNATGateway: https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/v0.52.3/resources/ec2.aws.crossplane.io/Address/v1beta1
  output: {
  	apiVersion: "ec2.aws.crossplane.io/v1beta1"
  	kind: "Address"
  	metadata: {
      name: parameter.ipAllocationName
      namespace: parameter.defaultNamespace
    }
    spec: {
    	forProvider: {
    		region: parameter.defaultRegion
    		domain: "vpc"
    		tags: [
    			{
    				key: "Name"
    				value: parameter.ipAllocationName
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
		//+usage=IP Allocation name.
		ipAllocationName: string
		//+usage=Default Namespace under which resources are grouped.
		defaultNamespace: *"evocloud-ns" | string
		//+usage=Default region to deploy the Internet Gateway.
		defaultRegion: *"us-east-2" | string
		//+usage=AWS IaaS Provider config name (do not alter this value).
		providerConfigName: *"provider-aws-config" | string
	}
}
