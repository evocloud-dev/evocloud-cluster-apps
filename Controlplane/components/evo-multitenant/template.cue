// template.cue

package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-multitenant'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: evo-multitenant-ns namespace object
          {
            type: "k8s-objects"
            name: "evo-multitenant-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: evo-multitenant-repo helm repository object
          {
             type: "k8s-objects"
             name: "evo-multitenant-repo"
             dependsOn: ["evo-multitenant-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "capsule-operator-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://projectcapsule.github.io/charts/"
                  }
               }
             ]
          },
          //third component: evo-multitenant deploy logic
          {
             type: "k8s-objects"
             name: "evo-multitenant"
             dependsOn: ["evo-multitenant-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "evo-multitenant"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "capsule"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "capsule-operator-stable"
                    		}
                    		version: "0.7.*"
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
                    	//Important to enable Capsule Proxy: https://github.com/projectcapsule/capsule-proxy
                    	proxy: {
                    		enabled: true
                    	}
                    }
                  }
               }
             ]
          },
          //fourth component: evo-multitenant the GitOps way
          ///integration with Flux
          {
             type: "k8s-objects"
             name: "evo-multitenant-fluxcd"
             dependsOn: ["evo-multitenant-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "evo-multitenant-fluxcd"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "capsule-addon-fluxcd"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "capsule-operator-stable"
                    		}
                    		version: "0.2.*"
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

        //policy definition
        policies: []

        //workflow step definition
        workflow: steps: []
	}
}