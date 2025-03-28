// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-kafka-operator'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: kafka-operator-ns namespace object
          {
            type: "k8s-objects"
            name: "kafka-operator-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: kafka-operator-repo helm repository object
          {
             type: "k8s-objects"
             name: "kafka-operator-repo"
             dependsOn: ["kafka-operator-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "strimzi-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://strimzi.io/charts/"
                  }
               }
             ]
          },
          //third component: kafka-operator-deploy logic
          {
             type: "k8s-objects"
             name: "kafka-operator"
             dependsOn: ["kafka-operator-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "strimzi-operator-deploy"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "strimzi-kafka-operator"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "strimzi-stable"
                    		}
                    		version: "0.45.*"
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
                    	replicas: 1
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