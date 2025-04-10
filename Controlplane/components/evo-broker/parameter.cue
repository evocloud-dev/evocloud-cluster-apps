// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"broker-system" | string
  storageclass: *"ceph-block" | string
}