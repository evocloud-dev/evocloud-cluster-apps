// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-victoria-metrics'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: vm-ns namespace object
          {
            type: "k8s-objects"
            name: "vm-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: vm-repo helm repository object
          {
             type: "k8s-objects"
             name: "vm-repo"
             dependsOn: ["vm-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "vm"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://victoriametrics.github.io/helm-charts/"
                  }
               }
             ]
          },
          //third component: vm-deploy logic
          {
             type: "k8s-objects"
             name: "vm-release"
             dependsOn: ["vm-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "victoria-metrics"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "victoria-metrics-operator"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "vm"
                    		}
                    		version: "0.44.*"
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
                    	replicaCount: parameter.replicaCount
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