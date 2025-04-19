import "encoding/json"

"aws-iam-role": {
	type: "component"
	alias: ""
	description: "AWS IAM Role resource provided by EvoCloud"
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	// awsIAMRole: https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/v0.52.3/resources/iam.aws.crossplane.io/Role/v1beta1
  output: {
  	apiVersion: "iam.aws.crossplane.io/v1beta1"
  	kind: "Role"
  	metadata: {
      name: parameter.iamRoleName
      namespace: parameter.defaultNamespace
    }
    spec: {
    	forProvider: {
    		assumeRolePolicyDocument: json.Marshal({
						"Version": "2012-10-17"
						"Statement": [
								{
										"Effect": parameter.awsAllowEffect
										"Principal": {
												"Service": parameter.awsServicePrincipals
										}
										"Action": parameter.awsAssumeRoles
								}
						]
				})

    		tags: [
    			{
    				key: "Name"
    				value: parameter.iamRoleName
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
		//+usage=AWS IAM Role name
		iamRoleName: string
		//+usage=Default Namespace under which resources are grouped.
		defaultNamespace: string
		//+usage=Allow or Deny rule.
		awsAllowEffect: *"Allow" | string
		//+usage=Service principal to apply the rule on.
		awsServicePrincipals: [...string]
		//+usage=Assumed IAM role.
		awsAssumeRoles: [...string]
		//+usage=AWS IaaS Provider config name (do not alter this value).
		providerConfigName: *"provider-aws-config" | string
	}
}
