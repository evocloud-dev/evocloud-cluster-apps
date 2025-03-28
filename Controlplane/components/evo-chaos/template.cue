// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-choas'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: chaos-ns namespace object
          {
            type: "k8s-objects"
            name: "chaos-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: chaos-repo helm repository object
          {
             type: "k8s-objects"
             name: "chaos-repo"
             dependsOn: ["chaos-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "chaos-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://charts.chaos-mesh.org/"
                  }
               }
             ]
          },
          //third component: chaos-deploy logic
          {
             type: "k8s-objects"
             name: "chaos"
             dependsOn: ["chaos-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "chaos-app-deploy"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "keda"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "chaos-stable"
                    		}
                    		version: "2.7.*"
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
                  }

               }
             ]
          },
        ]

        policies: []

        workflow: steps: []
	}
}