// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-flink'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: flink-ns namespace object
          {
            type: "k8s-objects"
            name: "flink-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: flink-repo helm repository object
          {
             type: "k8s-objects"
             name: "flink-repo"
             dependsOn: ["flink-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "flink-operator-repo"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://downloads.apache.org/flink/flink-kubernetes-operator-1.11.0"
                  }
               }
             ]
          },
          //third component: flink-deploy logic
          {
             type: "k8s-objects"
             name: "flink-release"
             dependsOn: ["flink-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "evo-flink"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "flink-kubernetes-operator"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "flink-operator-repo"
                    		}
                    		version: "1.11.*"
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
                    	webhook: parameter.webhook
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