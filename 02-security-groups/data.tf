data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.envirnoment}/vpc_id"
}

data "aws_vpc" "default" {
  default = true
}