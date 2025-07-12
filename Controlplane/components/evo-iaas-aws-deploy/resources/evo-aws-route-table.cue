// resources/evo-aws-route-table.cue
//Add later logic to choose from natGatewayName or internetGatewayName
package main

evo-aws-route-table: {
    type: "k8s-objects"
    name: "evo-aws-route-table"
    properties: objects: [{
        apiVersion: "core.oam.dev/v1beta1"
        kind:       "Application"
        metadata: name: parameter.routeTableName
        spec:
					components:
						- name: parameter.routeTableName
							type: aws-route-table
							properties:
							  providerConfigName: parameter.providerName
								defaultRegion: parameter.defaultRegion
								defaultNamespace: parameter.defaultNamespace
								routeTableName: parameter.routeTableName
								virtualNetworkName: parameter.virtualNetworkName
								internetGatewayName: parameter.internetGatewayName
								subnetName: parameter.subnetName
								destinationCidrBlock: parameter.destinationCidrBlock
    }]
}
