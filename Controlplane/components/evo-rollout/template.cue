// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-rollout'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: rollout-ns namespace object
          {
            type: "k8s-objects"
            name: "rollout-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: rollout-repo helm repository object
          {
             type: "k8s-objects"
             name: "rollout-repo"
             dependsOn: ["rollout-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "openkruise-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://openkruise.github.io/charts/"
                  }
               }
             ]
          },
          //third component: rollout-deploy logic
          {
             type: "k8s-objects"
             name: "rollout"
             dependsOn: ["rollout-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "openkruise-app-deploy"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "kruise"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "openkruise-stable"
                    		}
                    		version: "1.8.*"
                    	}
                    }
                    interval: "15m0s"
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
                    	manager: {
                    		replicas: 2
                    	}
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