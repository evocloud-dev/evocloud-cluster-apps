"aws-iam-role-policy-attach": {
	type: "component"
	alias: ""
	description: "AWS IAM Role policy attachment resource provided by EvoCloud"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	// awsRolePolicyAttachment: https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/v0.52.3/resources/iam.aws.crossplane.io/RolePolicyAttachment/v1beta1
  output: {
  	apiVersion: "iam.aws.crossplane.io/v1beta1"
  	kind: "RolePolicyAttachment"
  	metadata: {
      name: parameter.iamRolePolicyAttachmentName
      namespace: parameter.defaultNamespace
    }
    spec: {
    	forProvider: {
    		policyArn: parameter.awsPolicyArn
    		roleNameRef: {
    		  name: parameter.iamRoleName
    	  }
    	}
    	providerConfigRef: {
    		name: parameter.providerConfigName
    	}
    }
  }

  //parameter
	parameter: {
		//+usage=AWS IAM Role Policy Attachment name
		iamRolePolicyAttachmentName: string
		//+usage=AWS IAM Role name
		iamRoleName: string
		//+usage=Default Namespace under which resources are grouped.
		defaultNamespace: string
		//+usage=AWS Policy ARN.
		awsPolicyArn: string
		//+usage=AWS IaaS Provider config name (do not alter this value).
		providerConfigName: *"provider-aws-config" | string
	}
}
