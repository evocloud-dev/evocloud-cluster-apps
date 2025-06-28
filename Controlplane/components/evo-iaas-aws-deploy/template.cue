// template.cue
package main

output: {
    apiVersion: "core.oam.dev/v1beta1"
    kind: "Application"
    spec: {
    	// Reference all the componenent in the resources folder
      components: [evo-aws-provider, evo-aws-vpc]
      // Reference applications policies
      policies: []
      // Reference application deployment workflow
      workflow: steps: [
        {
				  type: "apply-component"
				  name: "Deploy evo-aws PaaS"
				  properties: component: ["evo-aws-provider", "evo-aws-vpc", "evo-aws-subnet", "evo-aws-internet-gateway", "evo-aws-elastic-ip", "evo-aws-nat-gateway", "evo-aws-route-table"]
			  },
			]
    }
}