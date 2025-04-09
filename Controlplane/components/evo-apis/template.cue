// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-apis'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: apis-ns namespace object
          {
            type: "k8s-objects"
            name: "apis-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: apis-repo helm repository object
          {
             type: "k8s-objects"
             name: "apis-repo"
             dependsOn: ["apis-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "apis-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://dapr.github.io/helm-charts/"
                  }
               }
             ]
          },
          //third component: apis-deploy logic
          {
             type: "k8s-objects"
             name: "apis-release"
             dependsOn: ["apis-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "apis"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "dapr"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "apis-stable"
                    		}
                    		version: "1.15.*"
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
                    	imagePullPolicy: parameter.imagePullPolicy
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