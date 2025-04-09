// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"headlamp-system" | string
  replicacount: *1 | int
}