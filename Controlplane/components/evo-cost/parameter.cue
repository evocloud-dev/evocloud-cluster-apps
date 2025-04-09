// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"opencost" | string
  ui: {
  	enabled: *"true" | bool
  }
}