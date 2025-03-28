// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-autoscaler'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: autoscaler-ns namespace object
          {
            type: "k8s-objects"
            name: "autoscaler-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: autoscaler-repo helm repository object
          {
             type: "k8s-objects"
             name: "autoscaler-repo"
             dependsOn: ["autoscaler-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "keda-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://kedacore.github.io/charts/"
                  }
               }
             ]
          },
          //third component: autoscaler-deploy logic
          {
             type: "k8s-objects"
             name: "autoscaler"
             dependsOn: ["autoscaler-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "keda-app-deploy"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "keda"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "keda-stable"
                    		}
                    		version: "2.16.*"
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
                    	clusterName: parameter.clustername
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