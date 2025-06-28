// resources/evo-aws-elastic-ip.cue
package main

evo-aws-elastic-ip: {
    type: "k8s-objects"
    name: "evo-aws-elastic-ip"
    properties: objects: [{
        apiVersion: "core.oam.dev/v1beta1"
        kind:       "Application"
        metadata: name: parameter.ipAllocationName
        spec:
					components:
						- name: parameter.ipAllocationName
							type: aws-elastic-ip
							properties:
							  providerConfigName: parameter.providerName
								defaultRegion: parameter.defaultRegion
								defaultNamespace: parameter.defaultNamespace
								ipAllocationName: parameter.ipAllocationName
    }]
}
