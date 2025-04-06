output: {
		type: "k8s-objects"
		properties: {
				objects: [
						{
										// https://marketplace.upbound.io/providers/crossplane-contrib/provider-gcp/v0.22.0/resources/gcp.crossplane.io/Provider/v1alpha3
										apiVersion: "pkg.crossplane.io/v1"
										kind: "Provider"
										metadata: name: parameter.providerName
										spec: {
											package: "xpkg.upbound.io/crossplane-contrib/provider-gcp:" + parameter.providerGcpVersion
											packagePullPolicy: "IfNotPresent"
											revisionActivationPolicy: "Automatic"
											revisionHistoryLimit: 1
										}
						},
				]
		}
}
