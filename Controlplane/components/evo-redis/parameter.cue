// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"redis-system" | string
  storageclass: *"ceph-block" | string
}