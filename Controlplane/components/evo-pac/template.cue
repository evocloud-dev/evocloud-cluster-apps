// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-pac'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: pac-ns namespace object
          {
            type: "k8s-objects"
            name: "pac-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: pac-repo helm repository object
          {
             type: "k8s-objects"
             name: "pac-repo"
             dependsOn: ["pac-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "kyverno-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://kyverno.github.io/kyverno/"
                  }
               }
             ]
          },
          //third component: pac-deploy logic
          {
             type: "k8s-objects"
             name: "pac"
             dependsOn: ["pac-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "kyverno-app-deploy"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "kyverno"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "kyverno-stable"
                    		}
                    		version: "3.3.*"
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
                    	admissionController: {
                    		replicas: 3
                    	}
                    	backgroundController: {
                    		replicas: 3
                    	}
                    	cleanupController: {
                    		replicas: 3
                    	}
                    	reportsController: {
                    		replicas: 3
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