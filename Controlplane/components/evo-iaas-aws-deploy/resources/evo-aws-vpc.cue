// resources/evo-aws-vpc.cue
package main

evo-aws-vpc: {
    type: "k8s-objects"
    name: "evo-aws-vpc"
    properties: objects: [{
        apiVersion: "core.oam.dev/v1beta1"
        kind:       "Application"
        metadata: name: parameter.virtualNetworkName
        spec:
					components:
						    - name: parameter.virtualNetworkName
									type: aws-vnet
									properties:
										virtualNetworkName: parameter.virtualNetworkName
										defaultRegion: parameter.defaultRegion
										providerConfigName: parameter.providerName
										vpcCidrBlock: parameter.vpcCidrBlock
    }]
}
