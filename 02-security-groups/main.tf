module "vpn" {
  source = "../../terraform-aws-security-group-module"
  project_name = var.project_name
  sg_description = "SG group for VPN"
  envirnoment = var.envirnoment
  vpc_id = data.aws_vpc.default.id
  sg_name = "vpn"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}



module "mongodb" {
  source = "../../terraform-aws-security-group-module"
  project_name = var.project_name
  sg_description = "SG group for MongoDB"
  envirnoment = var.envirnoment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "mongodb"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "redis" {
  source = "../../terraform-aws-security-group-module"
  project_name = var.project_name
  sg_description = "SG group for redis"
  envirnoment = var.envirnoment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "redis"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "mysql" {
  source = "../../terraform-aws-security-group-module"
  project_name = var.project_name
  sg_description = "SG group for mysql"
  envirnoment = var.envirnoment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "mysql"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "rabbitmq" {
  source = "../../terraform-aws-security-group-module"
  project_name = var.project_name
  sg_description = "SG group for rabbitmq"
  envirnoment = var.envirnoment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "rabbitmq"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "catalogue" {
  source = "../../terraform-aws-security-group-module"
  project_name = var.project_name
  sg_description = "SG group for catalogue"
  envirnoment = var.envirnoment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "catalogue"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "user" {
  source = "../../terraform-aws-security-group-module"
  project_name = var.project_name
  sg_description = "SG group for user"
  envirnoment = var.envirnoment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "user"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "cart" {
  source = "../../terraform-aws-security-group-module"
  project_name = var.project_name
  sg_description = "SG group for cart"
  envirnoment = var.envirnoment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "cart"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "shipping" {
  source = "../../terraform-aws-security-group-module"
  project_name = var.project_name
  sg_description = "SG group for shipping"
  envirnoment = var.envirnoment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "shipping"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}


module "payment" {
  source = "../../terraform-aws-security-group-module"
  project_name = var.project_name
  sg_description = "SG group for payment"
  envirnoment = var.envirnoment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "payment"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}


module "web" {
  source = "../../terraform-aws-security-group-module"
  project_name = var.project_name
  sg_description = "SG group for web"
  envirnoment = var.envirnoment
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "web"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

#openvpn
resource "aws_security_group_rule" "vpn_home"{
  security_group_id = module.catalogue.sg_id  # adding catalogue rule into mongodb sg
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"] #ideally your home public ip ads, but it frequently changes

}

#accepting traffic from vpn
resource "aws_security_group_rule" "mongodb_vpn"{
  source_security_group_id = module.vpn.sg_id  # adding catalogue rule into mongodb sg
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = module.mongodb.sg_id
}



#mongodb accepting connections from catalogue instance(we are not giving ip because it has more bandwidth so with sg id mongodb accepting catalogue)
resource "aws_security_group_rule" "mongodb_catalogue"{
  source_security_group_id = module.catalogue.sg_id  # adding catalogue rule into mongodb sg
  type = "ingress"
  from_port = 27017
  to_port = 27017
  protocol = "tcp"
  security_group_id = module.mongodb.sg_id
}



# mongodb accepting connections from user instance(we are not giving ip because it has more bandwidth so with sg id mongodb accepting user)
resource "aws_security_group_rule" "mongodb_user"{
  source_security_group_id = module.user.sg_id  # adding user rule into mongodb sg
  type = "ingress"
  from_port = 27017
  to_port = 27017
  protocol = "tcp"
  security_group_id = module.mongodb.sg_id
}

# redis accepting connections from user 
resource "aws_security_group_rule" "redis_user"{
  source_security_group_id = module.user.sg_id  # adding user rule into mongodb sg
  type = "ingress"
  from_port = 6379
  to_port = 6379
  protocol = "tcp"
  security_group_id = module.redis.sg_id
}


# redis accepting connections from cart 
resource "aws_security_group_rule" "redis_cart"{
  source_security_group_id = module.cart.sg_id  # adding user rule into mongodb sg
  type = "ingress"
  from_port = 6379
  to_port = 6379
  protocol = "tcp"
  security_group_id = module.redis.sg_id
}

resource "aws_security_group_rule" "mysql_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.mysql.sg_id
}

resource "aws_security_group_rule" "mysql_shipping" {
  source_security_group_id = module.shipping.sg_id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.mysql.sg_id
}


resource "aws_security_group_rule" "rabbitmq_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.rabbitmq.sg_id
}

resource "aws_security_group_rule" "rabbitmq_payment" {
  source_security_group_id = module.payment.sg_id
  type                     = "ingress"
  from_port                = 5672
  to_port                  = 5672
  protocol                 = "tcp"
  security_group_id        = module.rabbitmq.sg_id
}

resource "aws_security_group_rule" "catalogue_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_web" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_cart" {
  source_security_group_id = module.cart.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
}

resource "aws_security_group_rule" "user_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
}

resource "aws_security_group_rule" "user_web" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
}

resource "aws_security_group_rule" "user_payment" {
  source_security_group_id = module.payment.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
}

resource "aws_security_group_rule" "cart_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_web" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_shipping" {
  source_security_group_id = module.shipping.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_payment" {
  source_security_group_id = module.payment.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "shipping_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_web" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.shipping.sg_id
}

resource "aws_security_group_rule" "payment_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_web" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.payment.sg_id
}

resource "aws_security_group_rule" "web_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.web.sg_id
}

resource "aws_security_group_rule" "web_internet" {
  cidr_blocks = ["0.0.0.0/0"]
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.web.sg_id
}