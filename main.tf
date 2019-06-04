provider "aws" {
  region = "us-east-1"
}

######################################
# Create the necessary IAM ROLE and POLICIES
######################################
#module "iam_role" {
#	prefix = "${var.prefix}"
#	ProjectName = "${var.ProjectName}"
#	aws_email = "${var.aws_email}"
#	source = "./modules/iam/role"		
#}

######################################
# Create custom policy
######################################
#module "iam_policy" {
#	prefix = "${var.prefix}"
#	ProjectName = "${var.ProjectName}"
#	aws_email = "${var.aws_email}"
#	source = "./modules/iam/policy"
#}

######################################
# Attach custom policy
######################################
#resource "aws_iam_role_policy_attachment" "attach-JenkinsPolicy" {
#  role       = "${module.iam_role.iam_role_name}"
#  policy_arn = "arn:aws:iam::090999229429:policy/${module.iam_policy.iam_policy_name}"
#}

######################################
# Attach ReadOnly policy (?)
######################################
#resource "aws_iam_role_policy_attachment" "attach-ReadOnly" {
#  role       = "${module.iam_role.iam_role_name}"
#  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
#}

######################################
# Create Security Group for LoadBalancer
######################################
module "lb_sg" {
  source              = "terraform-aws-modules/security-group/aws//modules/http-8080"
  name                = "${var.prefix}-tcp-loadbalancer"
  description         = "Security Group for Jenkins Load Balancer"
  vpc_id              = "vpc-023440f11753798e5"
  ingress_cidr_blocks = ["10.0.0.0/8"]
  tags = {
    Server_Function = "DEV_APP",
    System          = "ATA",
    Fisma_ID        = "Unknown",
    Environment     = var.Environment,
    Owner           = var.aws_email,
    Team            = var.Team
  }
}

######################################
# Create Security Group for EC2 Instance
######################################
module "app_sg" {
  #source      = "terraform-aws-modules/security-group/aws//modules/http-8080"
  source       = "terraform-aws-modules/security-group/aws"
  name         = "${var.prefix}-tcp-app"
  description  = "Security Group for Jenkins Application Server"
  vpc_id       = "vpc-023440f11753798e5"
  egress_rules = ["all-all"]
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-8080-tcp"
      source_security_group_id = "${module.lb_sg.this_security_group_id}"
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  tags = {
    Server_Function = "DEV_APP",
    System          = "ATA",
    Fisma_ID        = "Unknown",
    Environment     = var.Environment,
    Owner           = var.aws_email,
    Team            = var.Team
  }
}