//Global parameters
parameter: {
	//+usage=Provides the AWS Access Key ID.
  awsAccessKeyId: string
  //+usage=Provides the AWS Access Secret Key.
  awsSecretAccessKey: string
  //+usage=Name of the Virtual Private Cloud Network to create.
  virtualNetworkName: string
  //+usage=Default infrastructure region.
  defaultRegion: *"us-east-2" | string
  //+usage=Infrastructure availability zone in region.
  availabilityZone: *"us-east-2a" | string
  //+usage=Defines the IaaS Provider config to use.
  providerConfigName: string
  //+usage=CIDR block for the Virtual Private Compute Network. i.e: 10.10.0.0/16
  vpcCidrBlock: string
  //+usage=Name of the provider used to interact with the IaaS.
  providerName: *"evo-provider-aws" | string
  //+usage=Default kubernetes namespace where the resource will be deployed
  defaultNamespace: *"evocloud-ns" | string
  //+usage= Subnet name
  subnetName: string
  //+usage=CIDR block for the subnet. i.e: 10.100.0.0/16
  subnetAddressCidr: string
  //+usage=Internet Gateway name.
	internetGatewayName: string
	//+usage=IP Allocation name.
	ipAllocationName: string
	//+usage=NAT Gateway name.
	natGatewayName: string
}