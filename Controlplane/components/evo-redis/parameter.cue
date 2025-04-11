// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"ot-operators" | string
  replicas: *1 | int
}