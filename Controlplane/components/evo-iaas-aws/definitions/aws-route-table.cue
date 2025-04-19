"aws-route-table": {
	type: "component"
	alias: ""
	description: "AWS VPC Route Table resource provided by EvoCloud"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	// awsRouteTable: https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/v0.52.3/resources/ec2.aws.crossplane.io/RouteTable/v1beta1
  output: {
  	apiVersion: "ec2.aws.crossplane.io/v1beta1"
  	kind: "RouteTable"
  	metadata: {
      name: parameter.routeTableName
      namespace: parameter.defaultNamespace
    }
    spec: {
    	forProvider: {
    		region: parameter.defaultRegion
    		associations: [{
    			subnetIdRef: {
    			  name: parameter.subnetName
    		  }
    		}]
    		routes: [{
    			if parameter.internetGatewayName != _|_ {
    			  gatewayIdRef: {
    			    name: parameter.internetGatewayName
    		    }
          }
    		  if parameter.natGatewayName != _|_ {
    			  natGatewayIdRef: {
    			    name: parameter.natGatewayName
    		    }
          }
    		  destinationCidrBlock: parameter.destinationCidrBlock
    		}]
    		vpcIdRef: {
    			name: parameter.virtualNetworkName
    		}

    		tags: [
    			{
    				key: "Name"
    				value: parameter.routeTableName
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
		//+usage=Route table name.
		routeTableName: string
		//+usage=Default Namespace under which resources are grouped.
		defaultNamespace: string
		//+usage=Optional Internet gateway name.
		internetGatewayName?: string
		//+usage=Optional NATted gateway name.
		natGatewayName?: string
		//+usage=Subnetwork name.
		subnetName: string
		//+usage=Destination route cidr.
		destinationCidrBlock: *"0.0.0.0/0" | string
		//+usage=AWS VPC network name.
		virtualNetworkName: *"evocloud-paas-vnet" | string
		//+usage=Default region for the route table.
		defaultRegion: *"us-east-2" | string
		//+usage=AWS IaaS Provider config name (do not alter this value).
		providerConfigName: *"provider-aws-config" | string
	}
}
