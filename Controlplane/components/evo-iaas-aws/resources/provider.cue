output: {
		type: "k8s-objects"
		properties: {
				objects: [
						{
										// https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/v0.52.3
										apiVersion: "pkg.crossplane.io/v1"
										kind: "Provider"
										metadata: name: parameter.providerName
										spec: {
											package: "xpkg.upbound.io/crossplane-contrib/provider-aws:" + parameter.providerAwsVersion
											packagePullPolicy: "IfNotPresent"
											revisionActivationPolicy: "Automatic"
											revisionHistoryLimit: 1
										}
						},
				]
		}
}
