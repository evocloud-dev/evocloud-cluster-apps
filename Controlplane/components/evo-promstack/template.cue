// template.cue

package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-promstack'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: evo-promstack-ns namespace object
          {
            type: "k8s-objects"
            name: "evo-promstack-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: evo-promstack-repo helm repository object
          {
             type: "k8s-objects"
             name: "evo-promstack-repo"
             dependsOn: ["evo-promstack-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "promstack-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://prometheus-community.github.io/helm-charts/"
                  }
               }
             ]
          },
          //third component: evo-promstack deploy logic
          {
             type: "k8s-objects"
             name: "evo-promstack"
             dependsOn: ["evo-promstack-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "evo-promstack"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "kube-prometheus-stack"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "promstack-stable"
                    		}
                    		version: "70.3.*"
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
                    	nodeExporter: {
                    		operatingSystems: {
                    			aix: {
                    				enabled: false
                    			}
                    			darwin: {
                    				enabled: false
                    			}
                    		}
                    	}
                    }
                  }

               }
             ]
          },
        ]

        //policy definition
        policies: []

        //workflow step definition
        workflow: steps: []
	}
}