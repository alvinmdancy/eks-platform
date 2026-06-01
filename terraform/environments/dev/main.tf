module "vpc" {
  source = "../../modules/vpc"

  name               = "eks-platform"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = {
    Environment = "dev"
    Project     = "eks-platform"
    ManagedBy   = "terraform"
  }
}