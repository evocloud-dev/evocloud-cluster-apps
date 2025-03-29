// template.cue
package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind: "Application"
	metadata: {
		name: 'evo-tofu'
		namespace: 'vela-system'
	}
	spec: {
        components: [
          //first component: tofu-repo helm repository object
          {
             type: "k8s-objects"
             name: "tofu-repo"
             dependsOn: ["tofu-ns"]
             properties: objects: [
               {
                  apiVersion: "source.toolkit.fluxcd.io/v1beta1"
                  kind: "HelmRepository"
                  metadata: {
                    name: "tofu-controller-stable"
                    namespace: "flux-system"
                  }
                  spec: {
                  	interval: "1h"
                  	url: "https://flux-iac.github.io/tofu-controller"
                  }
               }
             ]
          },
          //second component: tofu-deploy logic
          {
             type: "k8s-objects"
             name: "tofu"
             dependsOn: ["tofu-repo"]
             properties: objects: [
               {
                  apiVersion: "helm.toolkit.fluxcd.io/v2beta1"
                  kind: "HelmRelease"
                  metadata: {
                    name: "tofu-provider"
                    namespace: "flux-system"
                  }
                  spec: {
                    chart: {
                    	spec: {
                    		chart: "tofu-controller"
                    		sourceRef: {
                    			kind: "HelmRepository"
                    			name: "tofu-controller-stable"
                    		}
                    		version: "0.16.0-rc.5"
                    	}
                    }
                    interval: "15m0s"
                    install: {
                    	remediation: {
                    		retries: 3
                    	}
                    	crds: "Create"
                    }
                    upgrade: {
                    	remediation: {
                    		retries: 2
                    	}
                    	crds: "CreateReplace"
                    }
                    values: {
                    	replicaCount: 3
                    	concurrency: 24
                    	caCertValidityDuration: "24h"
                    	certRotationCheckFrequency: "30m"
                    	resources: {
                    		limits: {
                    			cpu: "1000m"
                    			memory: "2Gi"
                    		}
                    		requests: {
                    			cpu: "400m"
                    			memory: "64Mi"
                    		}
                    	}
                    	image: {
                    		tag: "v0.16.0-rc.5"
                    	}
                    	runner: {
                    		image: {
                    			tag: "v0.16.0-rc.5"
                    		}
                    		grpc: {
                    			maxMessageSize: 30
                    		}
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