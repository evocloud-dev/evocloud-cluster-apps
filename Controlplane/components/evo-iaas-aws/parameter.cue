// parameter.cue is used to store addon parameters.
// You can use these parameters in template.cue or in resources/ by 'parameter.myparam'

parameter: {
  //+usage=providerName defining the type of the IaaS Provider to use. Defaults to `provider-aws`
  providerName: *"provider-aws" | string
  //+usage=providerConfigName defining the config name of the IaaS Provider to use. Defaults to `provider-aws-config`
  providerConfigName: *"provider-aws-config" | string
  //+usage=providerAwsVersion: https://marketplace.upbound.io/providers/crossplane-contrib/provider-aws/v0.52.3
  providerAwsVersion: *"v0.52.3" | string
  //+usage=Go to aws console and create an access key for user called evocloud-sa and
  //copy the Access key and Secret access key.
  aws_access_key_id: string
  aws_secret_access_key: string
}