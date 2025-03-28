// template.cue

package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-gitops'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: gitops-ns namespace object
          {
            type: "k8s-objects"
            name: "gitops-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: gitops-repo helm repository object
          {
             type: "k8s-objects"
             name: "gitops-repo"
             dependsOn: ["gitops-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "argocd-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://argoproj.github.io/argo-helm/"
                  }
               }
             ]
          },
          //third component: gitops-deploy logic
          {
             type: "k8s-objects"
             name: "gitops"
             dependsOn: ["gitops-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "argocd-deploy"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "argo-cd"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "argocd-stable"
                    		}
                    		version: "7.8.*"
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
                    	controller: {
                    		replicas: 1
                    	}
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