// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"flink-system" | string
  replicaCount: *1 | int
  webhook: create: *false | bool
}