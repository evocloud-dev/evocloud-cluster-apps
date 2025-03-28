// template.cue

package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-olapdb'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: olapdb-ns namespace object
          {
            type: "k8s-objects"
            name: "olapdb-ns"
            properties: objects: [
              {
                 apiVersion: "v1"
                 kind: "Namespace"
                 metadata: name: parameter.namespace
              }
            ]
          },
          //second component: olapdb-repo helm repository object
          {
             type: "k8s-objects"
             name: "olapdb-repo"
             dependsOn: ["olapdb-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "clickhouse-operator-stable"
                    namespace: parameter.namespace
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://docs.altinity.com/clickhouse-operator/"
                  }
               }
             ]
          },
          //third component: olapdb-deploy logic
          {
             type: "k8s-objects"
             name: "olapdb"
             dependsOn: ["olapdb-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "clikhouse-operator-deploy"
                    namespace: parameter.namespace
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "altinity-clickhouse-operator"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "clickhouse-operator-stable"
                    		}
                    		version: "0.24.*"
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
                    	dashboards: {
                    		enabled: false
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