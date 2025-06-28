// resources/evo-aws-nat-gateway.cue
package main

evo-aws-nat-gateway: {
    type: "k8s-objects"
    name: "evo-aws-nat-gateway"
    properties: objects: [{
        apiVersion: "core.oam.dev/v1beta1"
        kind:       "Application"
        metadata: name: parameter.natGatewayName
        spec:
					components:
						- name: parameter.natGatewayName
							type: aws-nat-gateway
							properties:
							  providerConfigName: parameter.providerName
								defaultRegion: parameter.defaultRegion
								defaultNamespace: parameter.defaultNamespace
								natGatewayName: parameter.natGatewayName
								subnetName: parameter.subnetName
								ipAllocationName: parameter.ipAllocationName
    }]
}
