// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-certman'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: certman-ns namespace object
          {
            type: "k8s-objects"
            name: "certman-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: certman-repo helm repository object
          {
             type: "k8s-objects"
             name: "certman-repo"
             dependsOn: ["certman-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "jetstack"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://charts.jetstack.io"
                  }
               }
             ]
          },
          //third component: certman-deploy logic
          {
             type: "k8s-objects"
             name: "certman-release"
             dependsOn: ["certman-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "certman"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "cert-manager"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "jetstack"
                    		}
                    		version: "1.17.*"
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
                    	replicaCount: parameter.replicaCount
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