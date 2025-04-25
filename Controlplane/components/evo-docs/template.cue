// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-docs'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: docs-ns namespace object
          {
            type: "k8s-objects"
            name: "docs-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: docs-repo helm repository object
          {
             type: "k8s-objects"
             name: "docs-repo"
             dependsOn: ["docs-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "docs-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: ""
                  }
               }
             ]
          },
          //third component: docs-deploy logic
          {
             type: "k8s-objects"
             name: "docs-release"
             dependsOn: ["docs-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "docs"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "docs"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "docs-stable"
                    		}
                    		version: "0.3.*"
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
                    	imageVersion: parameter.imageVersion
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