// template.cue

package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-kubescape'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: kubescape-ns namespace object
          {
            type: "k8s-objects"
            name: "kubescape-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: kubescape-repo helm repository object
          {
             type: "k8s-objects"
             name: "kubescape-repo"
             dependsOn: ["kubescape-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "kubescape-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://kubescape.github.io/helm-charts/"
                  }
               }
             ]
          },
          //third component: kubescape-deploy logic
          {
             type: "k8s-objects"
             name: "kubescape"
             dependsOn: ["kubescape-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "kubescape-deploy"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "kubescape-operator"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "kubescape-stable"
                    		}
                    		version: "1.26.*"
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

        //policy definition
        policies: []

        //workflow step definition
        workflow: steps: []
	}
}