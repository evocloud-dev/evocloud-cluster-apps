// resources/evo-aws-provider.cue
package main

evo-aws-provider: {
    type: "k8s-objects"
    name: "evo-aws-provider"
    properties: objects: [{
        apiVersion: "core.oam.dev/v1beta1"
        kind:       "Application"
        metadata: name: parameter.providerName
        spec:
					components:
						- name: evo-aws-provider
							type: aws-provider-config
							properties:
								awsAccessKeyId: parameter.awsAccessKeyId
								awsSecretAccessKey: parameter.awsSecretAccessKey
    }]
}
