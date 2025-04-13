// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-otredis'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: otredis-ns namespace object
          {
            type: "k8s-objects"
            name: "otredis-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: otredis-repo helm repository object
          {
             type: "k8s-objects"
             name: "otredis-repo"
             dependsOn: ["otredis-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "ot-helm"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://ot-container-kit.github.io/helm-charts/"
                  }
               }
             ]
          },
          //third component: otredis-deploy logic
          {
             type: "k8s-objects"
             name: "otredis-release"
             dependsOn: ["otredis-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "otredis-operator"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "redis-operator"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "ot-helm"
                    		}
                    		version: "0.20.*"
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
                    	replicaCount: parameter.replicas
                    	cpuLimit: parameter.resources.limits.cpu
                    	cpuRequests: parameter.resources.requests.cpu
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