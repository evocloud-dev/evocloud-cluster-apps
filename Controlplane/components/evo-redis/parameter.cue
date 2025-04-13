// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"ot-operators" | string
  replicas: *1 | int
  resources: limits: cpu: *100 | int
  resources: requests: cpu: *100 | int
}