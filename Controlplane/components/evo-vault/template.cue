// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-vault'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: vault-ns namespace object
          {
            type: "k8s-objects"
            name: "vault-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: vault-repo helm repository object
          {
             type: "k8s-objects"
             name: "vault-repo"
             dependsOn: ["vault-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "vault-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://helm.releases.hashicorp.com"
                  }
               }
             ]
          },
          //third component: vault-deploy logic
          {
             type: "k8s-objects"
             name: "vault-release"
             dependsOn: ["vault-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "evo-vault"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "vault"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "vault-stable"
                    		}
                    		version: "0.30.*"
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
                    	storageClass: parameter.dataStorage.storageClass
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