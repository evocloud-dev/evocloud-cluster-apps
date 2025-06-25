// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace:    *"cnpg-db" | string
  //+usage=type of postgres db cluster to create
  type:         *"postgresql" | "postgis" | "timescaledb" | string
  //+usage=postgresql | postgis | timescaledb version for the cluster
 	postgresql?:  *"16" | string
  timescaledb?: string
  postgis?:     string
  //+usage=number of replicas in the cluster
 	instances:    *3 | int
 	//+usage=Pod disruption budget to enable
	enablePDB:    *false | bool
	//+usage=Volume size to acquire from storageClass
	size:         *"8Gi" | string
	//+usage=Storage class for persisting data
  storageClass: *"ceph-block" | string

}