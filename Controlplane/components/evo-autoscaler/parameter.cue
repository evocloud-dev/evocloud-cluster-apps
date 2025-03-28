// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"keda" | string
  //+usage=Kubernetes cluster name.
  clustername: *"kubernetes-default" | string
}