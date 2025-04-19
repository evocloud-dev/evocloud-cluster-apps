import "text/template"

"aws-provider-config": {
	type: "component"
	alias: ""
	labels: {}
  annotations: {}
  description: "AWS ProviderConfig provided by EvoCloud"
  attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	_awsCreds: template.Execute(
			"""
			[default]
			aws_access_key_id = {{.accessKey}}
			aws_secret_access_key = {{.secretKey}}
			""",
			{
				accessKey: parameter.awsAccessKeyId
				secretKey: parameter.awsSecretAccessKey
			}
	)

	//awsProviderConfig: https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/v0.52.3/resources/aws.crossplane.io/ProviderConfig/v1beta1
  output: {
  	apiVersion: "aws.crossplane.io/v1beta1"
  	kind:       "ProviderConfig"
  	metadata: {
      name: parameter.providerConfigName
    }
    spec: {
    	endpoint: {
    		url: {
    			type: "Dynamic"
    			dynamic: {
    				host: parameter.awsEndpointUrl
    				protocol: "https"
    			}
    		}
    	}
    	credentials: {
    		source: "Secret"
    		secretRef: {
    			name: parameter.providerName + "-account-creds"
    			namespace: "evocloud-ns"
    			key:       "creds"
    		}
    	}
    }
  }

  //Creates the secret referenced in the output template
  outputs: {
  	"credential": {
  		apiVersion: "v1"
  		kind: "Secret"
  		metadata: {
  			name: parameter.providerName + "-account-creds"
  			namespace: "evocloud-ns"
  		}
  		stringData: {
    			creds: _awsCreds
    	}
  	}

  }

  //Parameters
  parameter: {
			//+usage=AWS IaaS Provider used (do not alter this value).
			providerName: *"provider-aws" | string
			//+usage=AWS IaaS Provider config name (do not alter this value).
			providerConfigName: *"provider-aws-config" | string
			//+usage=AWS Host URL endpoint for AWS services
			awsEndpointUrl: *"amazonaws.com" | string
			//+usage=AWS IaaS access key id (can be retrieve from AWS console).
			awsAccessKeyId: string
			//+usage=AWS IaaS secret access key id (can be retrieve from AWS console).
			awsSecretAccessKey: string
	}

}
