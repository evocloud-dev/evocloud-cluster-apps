"aws-eks-cluster": {
	type: "component"
	alias: ""
	description: "AWS Elastic Kubernetes Service cluster provided by EvoCloud"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	// awsCluster: https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/v0.52.3/resources/eks.aws.crossplane.io/Cluster/v1beta1
  output: {
  	apiVersion: "eks.aws.crossplane.io/v1beta1"
  	kind: "Cluster"
  	metadata: {
      name: parameter.eksClusterName
      namespace: parameter.defaultNamespace
    }
    spec: {
    	forProvider: {
    		region: parameter.defaultRegion
    		resourcesVpcConfig: {
    			endpointPrivateAccess: true
    			endpointPublicAccess: true
    			securityGroupIdRefs: parameter.securityGroupIdRefs
    			subnetIdRefs: parameter.SubnetRefs
    		}
    		roleArnRef: {
    			name: parameter.eksClusterRole
    		}
    		version: parameter.eksKubeVersion
    		tags: {
    			Name: parameter.eksClusterName
    			Provider: "EvoCloud"
    			Environment: "Production"
    		}
    	}
    	providerConfigRef: {
    		name: parameter.providerConfigName
    	}
    	writeConnectionSecretToRef: {
    		name: parameter.awsSecretName
    		namespace: parameter.defaultNamespace
    	}
    }
  }

  //parameter
	parameter: {
		//+usage=EKS IAM Cluster role name.
		eksClusterRole: string
		//+usage=Default Namespace under which resources are grouped.
		defaultNamespace: string
		//+usage=List of objects for referncing security groups.
		securityGroupIdRefs: [...{}]
		//+usage=List of objects for referencing subnets.
		SubnetRefs: [...{}]
		//+usage=EKS cluster default name.
		eksClusterName: *"evo-awscluster" | string
		//+usage=EKS Kuberenetes version.
		eksKubeVersion: "1.32"
		//+usage=Default region to deploy the EKS cluster to.
		defaultRegion: *"us-east-2" | string
		//+usage=Kubernetes secret where kubeconfig and other cluster info are stored.
		awsSecretName: *"evo-eksconfig" | string
		//+usage=AWS IaaS Provider config name (do not alter this value).
		providerConfigName: *"provider-aws-config" | string
	}
}
