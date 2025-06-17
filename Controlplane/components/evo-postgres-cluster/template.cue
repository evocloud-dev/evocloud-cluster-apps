// template.cue
//Ref:
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-postgres-cluster'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: cnpg-cluster-ns namespace object
          {
            type: "k8s-objects"
            name: "cnpg-cluster-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: cnpg-cluster-repo helm repository object
          {
             type: "k8s-objects"
             name: "cnpg-pg-repo"
             dependsOn: ["cnpg-cluster-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "cloudnative-pg-repo"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://cloudnative-pg.github.io/charts/"
                  }
               }
             ]
          },
          //third component: cnpg-operator-deploy logic
          {
             type: "k8s-objects"
             name: "cnpg-cluster"
             dependsOn: ["cnpg-pg-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "cloudnative-pg-cluster-deploy"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "cluster"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "cloudnative-pg-repo"
                    		}
                    		version: "0.3.*"
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
                    	//type: parameter.type
                    	//version: parameter.version.postgresql
                    	//port: parameter.recovery.import.source.port
                    	//instances: parameter.cluster.instances
                    	//size: parameter.cluster.storage.size
                    	//storageClass: parameter.cluster.storage.storageClass
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