module "roboshop" {
  #source = "../terraform-aws-vpc"
  source = "git::https://github.com/Palsonroy/terraform_aws_vpc.git?ref=main"
  project_name = var.project_name
  envirnoment = var.envirnoment
  common_tags = var.common_tags
  vpc_tags = var.vpc_tags

  # public subnet

 public_subnets_cidr = var.public_subnets_cidr

 # public subnet
  private_subnets_cidr = var.private_subnets_cidr

   # database subnet
  database_subnets_cidr = var.database_subnets_cidr

    # peering
  is_peering_required = var.is_peering_required
}