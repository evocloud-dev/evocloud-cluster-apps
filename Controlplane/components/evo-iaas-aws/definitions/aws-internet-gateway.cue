"aws-internet-gateway": {
	type: "component"
	alias: ""
	description: "AWS VPC Internet Gateway provided by EvoCloud"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	// awsInternetGateway: https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/v0.52.3/resources/ec2.aws.crossplane.io/InternetGateway/v1beta1
  output: {
  	apiVersion: "ec2.aws.crossplane.io/v1beta1"
  	kind: "InternetGateway"
  	metadata: {
      name: parameter.internetGatewayName
      namespace: parameter.defaultNamespace
    }
    spec: {
    	forProvider: {
    		region: parameter.defaultRegion
    		vpcIdRef: {
    			name: parameter.virtualNetworkName
    		}
    		tags: [
    			{
    				key: "Name"
    				value: parameter.internetGatewayName
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
		//+usage=Internet Gateway name.
		internetGatewayName: string
		//+usage=Default Namespace under which resources are grouped.
		defaultNamespace: *"evocloud-ns" | string
		//+usage=Default region to deploy the Internet Gateway.
		defaultRegion: *"us-east-2" | string
		//+usage=AWS VPC network name.
		virtualNetworkName: *"evocloud-paas-vnet" | string
		//+usage=AWS IaaS Provider config name (do not alter this value).
		providerConfigName: *"provider-aws-config" | string
	}
}
