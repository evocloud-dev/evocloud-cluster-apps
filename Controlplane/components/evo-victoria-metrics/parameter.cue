// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"victoria-system" | string
  replicaCount: *1 | int
}