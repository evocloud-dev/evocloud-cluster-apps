// resources/evo-aws-subnet.cue
package main

evo-aws-subnet: {
    type: "k8s-objects"
    name: "evo-aws-subnet"
    properties: objects: [{
        apiVersion: "core.oam.dev/v1beta1"
        kind:       "Application"
        metadata: name: parameter.subnetName
        spec:
					components:
						- name: parameter.subnetName
							type: aws-subnet
							properties:
								providerConfigName: parameter.providerName
								defaultRegion: parameter.defaultRegion
								availabilityZone: parameter.availabilityZone
								defaultNamespace: parameter.defaultNamespace
								virtualNetworkName: parameter.virtualNetworkName
								subnetName: parameter.subnetName
								subnetAddressCidr: parameter.subnetAddressCidr
    }]
}
