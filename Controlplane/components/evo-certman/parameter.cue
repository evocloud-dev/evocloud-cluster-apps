// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"certman-system" | string
  replicaCount: *1 | int
}