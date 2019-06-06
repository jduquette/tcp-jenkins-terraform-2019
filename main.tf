provider "aws" {
  region = "us-east-1"
}

######################################
# Create the necessary IAM ROLE and POLICIES
######################################
module "iam_role" {
  prefix      = "${var.prefix}"
  ProjectName = "${var.ProjectName}"
  aws_email   = "${var.aws_email}"
  source      = "./modules/iam/role"
}

######################################
# Create custom policy
######################################
module "iam_policy" {
  prefix      = "${var.prefix}"
  ProjectName = "${var.ProjectName}"
  aws_email   = "${var.aws_email}"
  source      = "./modules/iam/policy"
}

######################################
# Attach custom policy
######################################
resource "aws_iam_role_policy_attachment" "attach-JenkinsPolicy" {
  role       = "${module.iam_role.iam_role_name}"
  policy_arn = "arn:aws:iam::090999229429:policy/${module.iam_policy.iam_policy_name}"
}

######################################
# Attach ReadOnly policy (?)
######################################
resource "aws_iam_role_policy_attachment" "attach-ReadOnly" {
  role       = "${module.iam_role.iam_role_name}"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

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

######################################
# Create Instance Profile
######################################
resource "aws_iam_instance_profile" "profile" {
  name = "${var.prefix}-instance-profile"
  role = "${module.iam_role.iam_role_name}"
}

######################################
# Create AutoScaling Group
######################################

# For now we'll create without the use of a module.  However when
# https://bit.ly/2XsV617 is resolved, we should switch back to using this module.
#
# module "app_asg" {
#   source              = "terraform-aws-modules/autoscaling/aws"
#   name                = "${var.prefix}"
#   lc_name             = "app_asg_lc"
#   image_id      = var.AmiID
#   instance_type        = "t2.xlarge"
#   security_groups = ["sg-0176b2933ff3662e0"]
#   ebs_block_device = [
#       {
#         device_name           = "/dev/xvdz"
#         volume_type           = "gp2"
#         volume_size           = "50"
#         delete_on_termination = true
#       },
#     ]
#
#     root_block_device = [
#       {
#         volume_size           = "50"
#         volume_type           = "gp2"
#         delete_on_termination = true
#       },
#     ]
#
#   asg_name            = "var.prefix--TCP-JENKINS-ASG"
#   vpc_zone_identifier = ["subnet-018118375aa52d481"]
#   health_check_type   = "EC2"
#   min_size            = 0
#   max_size            = 1
#   desired_capacity    = 0
#   wait_for_capacity_timeout = 0
#   tags = [
#       {
#         key                 = "Environment"
#         value               = "dev"
#         propagate_at_launch = true
#       },
#       {
#         key                 = "Project"
#         value               = "BenchLifeIsTheBestLife"
#         propagate_at_launch = true
#       },
#     ]
# }

resource "aws_launch_configuration" "asg_conf" {
  name_prefix          = var.prefix
  image_id             = "${data.aws_ami.jenkins.id}"
  instance_type        = "t2.xlarge"
  iam_instance_profile = "${aws_iam_instance_profile.profile.name}"
  key_name             = "josh.phillips"
  security_groups      = ["${module.app_sg.this_security_group_id}"]
  # ebs_block_device = [
  #   {
  #     device_name           = "/dev/sde"
  #     volume_type           = "gp2"
  #     volume_size           = "400"
  #     delete_on_termination = true
  #   },
  # ]
  # root_block_device = [
  #   {
  #     volume_size           = "50"
  #     volume_type           = "gp2"
  #     delete_on_termination = true
  #   },
  # ]
  ####  Add Provisioners Here for User_Data items ####
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                 = "${var.prefix}-ASG"
  launch_configuration = "${aws_launch_configuration.asg_conf.name}"
  min_size             = 1
  max_size             = 1
  vpc_zone_identifier  = ["subnet-018118375aa52d481"]
  #load_balancers = [ think I forgot to create a load balancer!!]
  health_check_type = "EC2"
  tag {
    key                 = "Name"
    value               = "bar"
    propagate_at_launch = true
  }
  tag {
    key                 = "ServerFunction"
    value               = "bar"
    propagate_at_launch = true
  }
  tag {
    key                 = "Owner"
    value               = "${var.aws_email}"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
