// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-idm'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: idm-ns namespace object
          {
            type: "k8s-objects"
            name: "idm-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: idm-repo helm repository object
          {
             type: "k8s-objects"
             name: "idm-repo"
             dependsOn: ["idm-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "keycloak-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://charts.bitnami.com/bitnami/"
                  }
               }
             ]
          },
          //third component: idm-deploy logic
          {
             type: "k8s-objects"
             name: "idm"
             dependsOn: ["idm-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "keycloak-app-deploy"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "keycloak"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "keycloak-stable"
                    		}
                    		version: "24.4.*"
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