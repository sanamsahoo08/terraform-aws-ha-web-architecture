module "vpc" {
  source = "../../modules/vpc"

  environment          = "dev"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
}

module "security" {
  source = "../../modules/security"

  environment = "dev"
  vpc_id      = module.vpc.vpc_id
  app_port    = 80
}

module "compute" {
  source = "../../modules/compute"

  environment           = "dev"
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_subnet_ids    = module.vpc.private_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  app_security_group_id = module.security.app_security_group_id
  instance_profile_name = module.security.instance_profile_name
  instance_type         = "t3.micro"
}
