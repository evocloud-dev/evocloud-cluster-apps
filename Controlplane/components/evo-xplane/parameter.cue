// parameter.cue is used to store addon parameters.
// You can use these parameters in template.cue or in resources/ by 'parameter.myparam'

parameter: {
  //+usage=namespace to deploy to. Defaults to crossplane-system
  namespace: *"crossplane-system" | string
}