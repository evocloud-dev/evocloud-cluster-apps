// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-broker'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: broker-ns namespace object
          {
            type: "k8s-objects"
            name: "broker-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: broker-repo helm repository object
          {
             type: "k8s-objects"
             name: "broker-repo"
             dependsOn: ["broker-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "bitnami"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://charts.bitnami.com/bitnami/"
                  }
               }
             ]
          },
          //third component: broker-deploy logic
          {
             type: "k8s-objects"
             name: "broker-release"
             dependsOn: ["broker-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "evo-broker"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "rabbitmq-cluster-operator"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "bitnami"
                    		}
                    		version: "4.4.*"
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
                    	storageClass: parameter.storageclass
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