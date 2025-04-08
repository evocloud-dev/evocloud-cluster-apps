// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-headlamp'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: headlamp-ns namespace object
          {
            type: "k8s-objects"
            name: "headlamp-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: headlamp-repo helm repository object
          {
             type: "k8s-objects"
             name: "headlamp-repo"
             dependsOn: ["headlamp-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "headlamp-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://kubernetes-sigs.github.io/headlamp/"
                  }
               }
             ]
          },
          //third component: headlamp-deploy logic
          {
             type: "k8s-objects"
             name: "headlamp-release"
             dependsOn: ["headlamp-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "headlamp"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "headlamp"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "headlamp-stable"
                    		}
                    		version: "0.*.0"
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
                    	replicaCount: parameter.replicacount
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