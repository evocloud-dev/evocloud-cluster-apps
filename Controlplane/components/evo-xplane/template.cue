// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-xplane'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: xplane-ns namespace object
          {
            type: "k8s-objects"
            name: "xplane-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: xplane-repo helm repository object
          {
             type: "k8s-objects"
             name: "xplane-repo"
             dependsOn: ["xplane-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "crossplane-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://charts.crossplane.io/stable"
                  }
               }
             ]
          },
          //third component: xplane-deploy logic
          {
             type: "k8s-objects"
             name: "xplane"
             dependsOn: ["xplane-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "crossplane-provider"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "crossplane"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "crossplane-stable"
                    		}
                    		version: "v1.19.*"
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
                    	deploymentStrategy: "RollingUpdate"
                    	image: {
                    		repository: "xpkg.upbound.io/crossplane/crossplane"
                    		pullPolicy: "IfNotPresent"
                    	}
                    	//Enable Prometheus path, port and scrape annotations and expose port 8080 for both the Crossplane and RBAC Manager pods.
                    	metrics: {
                    		enabled: true
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