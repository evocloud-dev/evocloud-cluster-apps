// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"vault-system" | string
  dataStorage: storageClass: *"ceph-block" | string
}