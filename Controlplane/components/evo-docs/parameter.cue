// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"docs" | string
  imageVersion: *"0.3.0-alpha" | string
}