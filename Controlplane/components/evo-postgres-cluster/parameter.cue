// parameter.cue
parameter: {
  //+usage=namespace to deploy to.
  namespace: *"cnpg-database" | string
  type: *"postgresql" | string

  version:{
  	postgresql: *"16" | string
  }
  recovery: {
	  import:{
		  source: {
			  port: *5432 | int
		  }
	  }
  }
  cluster: {
  	instances: *3 | int
  	enablePDB: *false | bool
  	storage: {
  		size: *"8Gi" | string,
  		storageClass: *"ceph-block" | string
  	}
  }
}