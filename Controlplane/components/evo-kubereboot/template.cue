// template.cue

package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-kubereboot'
		namespace: 'vela-system'
		labels: {
			"pod-security.kubernetes.io/enforce": "privileged"
		}
	}
	spec: {
        components: [
          //first component: evo-kubereboot-ns namespace object
          {
            type: "k8s-objects"
            name: "evo-kubereboot-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: evo-kubereboot-repo helm repository object
          {
             type: "k8s-objects"
             name: "evo-kubereboot-repo"
             dependsOn: ["evo-kubereboot-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "kured-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://kubereboot.github.io/charts/"
                  }
               }
             ]
          },
          //third component: evo-kubereboot deploy logic
          {
             type: "k8s-objects"
             name: "evo-kubereboot"
             dependsOn: ["evo-kubereboot-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "evo-kubereboot"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "kured"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "kured-stable"
                    		}
                    		version: "5.6.*"
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
                    	configuration: {
                    		period: "0h10m0s"
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