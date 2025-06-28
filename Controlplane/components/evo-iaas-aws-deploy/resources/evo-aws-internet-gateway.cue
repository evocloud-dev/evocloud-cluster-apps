// resources/evo-aws-internet-gateway.cue
package main

evo-aws-internet-gateway: {
    type: "k8s-objects"
    name: "evo-aws-internet-gateway"
    properties: objects: [{
        apiVersion: "core.oam.dev/v1beta1"
        kind:       "Application"
        metadata: name: parameter.internetGatewayName
        spec:
					components:
						- name: parameter.internetGatewayName
							type: aws-internet-gateway
							properties:
							  providerConfigName: parameter.providerName
								defaultRegion: parameter.defaultRegion
								defaultNamespace: parameter.defaultNamespace
								virtualNetworkName: parameter.virtualNetworkName
								internetGatewayName: parameter.internetGatewayName
    }]
}
