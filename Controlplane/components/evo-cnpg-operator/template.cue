// template.cue
//Ref:
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-cnpg-operator'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: cnpg-operator-ns namespace object
          {
            type: "k8s-objects"
            name: "cnpg-operator-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: cnpg-operator-repo helm repository object
          {
             type: "k8s-objects"
             name: "cnpg-operator-repo"
             dependsOn: ["cnpg-operator-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "cloudnative-pg-repo"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://cloudnative-pg.github.io/charts/"
                  }
               }
             ]
          },
          //third component: cnpg-operator-deploy logic
          {
             type: "k8s-objects"
             name: "cnpg-operator"
             dependsOn: ["cnpg-operator-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "cloudnative-pg-operator-deploy"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "cloudnative-pg"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "cloudnative-pg-repo"
                    		}
                    		version: "0.23.*"
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
                    	replicaCount: 1
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