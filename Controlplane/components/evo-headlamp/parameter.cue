// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"harbor-system" | string
  replicacount: 1 | uint
}