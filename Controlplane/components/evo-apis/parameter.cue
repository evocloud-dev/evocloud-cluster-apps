// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"dapr-system" | string
  imagePullPolicy: *"IfNotPresent" | string
}