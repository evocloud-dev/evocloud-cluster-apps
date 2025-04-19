"aws-vnet": {
	type: "component"
	alias: ""
	description: "AWS Virtual Network (VPC) provided by EvoCloud"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	// awsVirtualNetwork: https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/v0.52.3/resources/ec2.aws.crossplane.io/VPC/v1beta1
  output: {
  	apiVersion: "ec2.aws.crossplane.io/v1beta1"
  	kind: "VPC"
  	metadata: {
      name: parameter.virtualNetworkName
      namespace: parameter.defaultNamespace
    }
    spec: {
    	forProvider: {
    		cidrBlock: parameter.vpcCidrBlock
    		enableDnsHostNames: true
    		enableDnsSupport: true
    		//enableNetworkAddressUsageMetrics: true
    		instanceTenancy: "default"
    		region: parameter.defaultRegion
    		tags: [
    			{
    				key: "Name"
    				value: parameter.virtualNetworkName
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
  	//+usage=AWS VPC network name.
  	virtualNetworkName: *"evocloud-paas-vnet" | string
  	//+usage=Default Namespace under which resources are grouped.
  	defaultNamespace: string
  	//+usage=AWS IaaS VPC default CIDR range.
  	vpcCidrBlock: *"10.10.0.0/16" | string
  	//+usage=AWS IaaS Provider config name (do not alter this value).
  	providerConfigName: *"provider-aws-config" | string
  	//+usage=Default region to deploy the EKS cluster to.
  	defaultRegion: *"us-east-2" | string
  }

}
