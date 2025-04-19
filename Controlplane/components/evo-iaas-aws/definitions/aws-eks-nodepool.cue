"aws-eks-nodepool": {
	type: "component"
	alias: ""
	description: "AWS Elastic Kubernetes Service NodePool provided by EvoCloud"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	// awsNodeGroup: https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/v0.52.3/resources/eks.aws.crossplane.io/NodeGroup/v1alpha1
  output: {
  	apiVersion: "eks.aws.crossplane.io/v1alpha1"
  	kind: "NodeGroup"
  	metadata: {
      name: parameter.nodePoolName
      namespace: parameter.defaultNamespace
    }
    spec: {
    	forProvider: {
    		clusterNameRef: {
    			name: parameter.eksClusterName
    		}
    		nodeRoleRef: {
    			name: parameter.eksNodeRole
    		}
    		region: parameter.defaultRegion
    		diskSize: parameter.eksNodeDiskSize
    		instanceTypes: parameter.eksNodeTypes
    		amiType: parameter.eksAmiImage
    		scalingConfig: {
    			desiredSize: parameter.desiredSize
    			maxSize: parameter.maxSize
    			minSize: parameter.minSize
    		}
    		subnetRefs: parameter.subnetRefs
    		//subnets: parameter.subnetLists
    		updateConfig: {
    			force: true
    			maxUnavailablePercentage: 20
    		}
    		tags: {
    			Name: parameter.eksClusterName
    			Provider: "EvoCloud"
    			Environment: "Production"
    		}
    	}
    	providerConfigRef: {
    		name: parameter.providerConfigName
    	}
    }
  }

  //parameter
	parameter: {
		//+usage=AWS Node Pool name
		nodePoolName: string
		//+usage=AWS IAM Node Role name
		eksNodeRole: string
		//+usage=Default Namespace under which resources are grouped.
		defaultNamespace: string
		//+usage=List of objects for referencing subnets.
		subnetRefs: [...{}]
		//+usage=EKS cluster default name.
		eksClusterName: *"evo-awscluster" | string
		//+usage=EKS cluster VM disk size.
		eksNodeDiskSize: *100 | int
		//+usage=EKS cluster VM desired scaling node count.
		desiredSize: *3 | int
		//+usage=EKS cluster VM maximum scaling node count.
		maxSize: *5 | int
		//+usage=EKS cluster VM minimal scaling node count .
		minSize: *1 | int
		//+usage=EKS cluster VM nodes type.
		eksNodeTypes: *["t3.medium"] | [...string]
		//+usage=EKS Machine Image to use.
		eksAmiImage: *"AL2_x86_64" | string
		//+usage=Default region to deploy the EKS cluster to.
		defaultRegion: *"us-east-2" | string
		//+usage=AWS IaaS Provider config name (do not alter this value).
		providerConfigName: *"provider-aws-config" | string
	}
}
