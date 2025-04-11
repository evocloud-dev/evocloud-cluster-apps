// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-redis'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: redis-ns namespace object
          {
            type: "k8s-objects"
            name: "redis-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: redis-repo helm repository object
          {
             type: "k8s-objects"
             name: "redis-repo"
             dependsOn: ["redis-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "redis"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://helm.redis.io/"
                  }
               }
             ]
          },
          //third component: redis-deploy logic
          {
             type: "k8s-objects"
             name: "redis-release"
             dependsOn: ["redis-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "redis-operator"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "redis-enterprise-operator"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "redis"
                    		}
                    		version: "7.8.*"
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