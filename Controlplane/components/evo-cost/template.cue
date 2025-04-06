// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-cost'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: cost-ns namespace object
          {
            type: "k8s-objects"
            name: "cost-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: cost-repo helm repository object
          {
             type: "k8s-objects"
             name: "cost-repo"
             dependsOn: ["cost-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "cost-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://opencost.github.io/opencost-helm-chart"
                  }
               }
             ]
          },
          //third component: cost-deploy logic
          {
             type: "k8s-objects"
             name: "cost-release"
             dependsOn: ["cost-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "opencost"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "opencost"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "cost-stable"
                    		}
                    		version: "1.0.*"
                    	}
                    }
                    interval: "24h"
                    install: {
                    	remediation: {
                    		retries: 3
                    	}
                    }
                    upgrade: {
                    	remediation: {
                    		retries: 2
                    	}
                    }
                    values: {
                    	ui: parameter.ui.enabled
                    }
                  }
               }
             ]
          },
        ]

        policies: []

        workflow: steps: []
	}
}