// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-harbor'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: harbor-ns namespace object
          {
            type: "k8s-objects"
            name: "harbor-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: harbor-repo helm repository object
          {
             type: "k8s-objects"
             name: "harbor-repo"
             dependsOn: ["harbor-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "harbor-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://helm.goharbor.io"
                  }
               }
             ]
          },
          //third component: harbor-deploy logic
          {
             type: "k8s-objects"
             name: "harbor-release"
             dependsOn: ["harbor-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "harbor"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "harbor"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "harbor-stable"
                    		}
                    		version: "1.16.*"
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
                    	storageClass: parameter.storageclass
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