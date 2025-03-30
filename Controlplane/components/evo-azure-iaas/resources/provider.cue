output: {
		type: "k8s-objects"
		properties: {
				objects: [
						{
										// https://marketplace.upbound.io/providers/crossplane-contrib/provider-azure/v0.20.1/resources/azure.crossplane.io/Provider/v1alpha3
										apiVersion: "pkg.crossplane.io/v1"
										kind: "Provider"
										metadata: name: parameter.providerName
										spec: {
											package: "xpkg.upbound.io/crossplane-contrib/provider-azure:" + parameter.providerAzureVersion
											packagePullPolicy: "IfNotPresent"
											revisionActivationPolicy: "Automatic"
											revisionHistoryLimit: 1
										}
						},
				]
		}
}
