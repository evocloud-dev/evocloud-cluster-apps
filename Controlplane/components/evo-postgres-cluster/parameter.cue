// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace:    *"cnpg-db" | string
  type:         *"postgresql" | "postgis" | "timescaledb" | string
 	postgresql?:  *"16" | string
  timescaledb?: string
  postgis?:     string
 	instances:    *3 | int
	enablePDB:    *false | bool
	size:         *"8Gi" | string,
  storageClass: *"ceph-block" | string

}