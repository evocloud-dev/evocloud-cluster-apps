// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"harbor-system" | string
  storageclass: *"ceph-block" | string
}