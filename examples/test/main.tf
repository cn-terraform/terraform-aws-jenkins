module "base-network" {
  source  = "cn-terraform/networking/aws"
  version = "3.0.0"

  cidr_block = "192.168.0.0/16"

  public_subnets = {
    first_public_subnet = {
      availability_zone = "us-east-1a"
      cidr_block        = "192.168.0.0/19"
    }
    second_public_subnet = {
      availability_zone = "us-east-1b"
      cidr_block        = "192.168.32.0/19"
    }
    third_public_subnet = {
      availability_zone = "us-east-1c"
      cidr_block        = "192.168.64.0/19"
    }
    fourth_public_subnet = {
      availability_zone = "us-east-1d"
      cidr_block        = "192.168.96.0/19"
    }
  }

  private_subnets = {
    first_private_subnet = {
      availability_zone = "us-east-1a"
      cidr_block        = "192.168.128.0/19"
    }
    second_private_subnet = {
      availability_zone = "us-east-1b"
      cidr_block        = "192.168.160.0/19"
    }
    third_private_subnet = {
      availability_zone = "us-east-1c"
      cidr_block        = "192.168.192.0/19"
    }
    fourth_private_subnet = {
      availability_zone = "us-east-1d"
      cidr_block        = "192.168.224.0/19"
    }
  }
}

module "jenkins" {
  source              = "../../"
  name_prefix         = "jenkins"
  region              = "us-east-1"
  vpc_id              = module.base-network.vpc_id
  public_subnets_ids  = [for subnet in module.base-network.public_subnets : subnet.id]
  private_subnets_ids = [for subnet in module.base-network.private_subnets : subnet.id]
}
