// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"kubescape" | string

  //+usage=clustername must be defined by the user. `kubectl config current-context`
  clustername: string
}