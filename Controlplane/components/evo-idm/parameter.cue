// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"keycloak" | string
  imagePullPolicy: *"IfNotPresent" | string
}