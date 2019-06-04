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
module "app_asg" {
  source               = "terraform-aws-modules/autoscaling/aws"
  name                 = "Duquette-TCP-JENKINS-ASG"
  lc_name              = "Duquette_launch_config"
  image_id             = var.AmiID
  instance_type        = "t2.xlarge"
  security_groups      = ["${module.app_sg}"]
  iam_instance_profile = "${iam_instance_profile.profile.name}"
  key_name             = "josh.phillips"
  ebs_block_device = [
    {
      device_name           = "/dev/sde"
      volume_type           = "gp2"
      volume_size           = "400"
      delete_on_termination = true
    }
  ]
  root_block_device = [
    {
      volume_size           = "50"
      volume_type           = "gp2"
      delete_on_termination = true
    }
  ]
  user_data = <<-EOF
  			#!/bin/bash --login


           export HOME=/var/chef/solo;
            export AWS_REGION=${region};
            export kmskeyid=${kms_key_id};
            
            
            # get attributes json
            
            
            crossing get s3://${bucket_name}/jenkins/deployment_id/attributes.json /var/chef/solo/;
            echo 'attributes json is downloaded';
            
            
            # get data_bags objects
            
            
            mkdir -p /var/chef/solo/data_bags/jenkins;
            crossing get s3://${bucket_name}/jenkins/deployment_id/data_bags/credentials.json /var/chef/solo/data_bags/jenkins;
            crossing get s3://${bucket_name}/jenkins/deployment_id/data_bags/local_users.json /var/chef/solo/data_bags/jenkins;
            echo 'data_bags are downloaded';
            
            
            # running chef for default_firstboot recipe


            chef-solo \
              -j /var/chef/solo/attributes.json \
              -c /var/chef/solo/solo.rb \
              -l info -L /var/log/chef.log;


            # delete credentials


            rm -rf data_bags;
            service jenkins restart;
            cfn-signal --exit-code $? --stack ${stack_name} --resource ${asg_name} --region ${region};
            EOF
  asg_name = "var.prefix--TCP-JENKINS"
  vpc_zone_identifier = ["subnet-018118375aa52d481"]
  health_check_type = "ELB"
  health_check_grace_period = "300"
  min_size = 1
  max_size = 1
  desired_capacity = 1
  wait_for_capacity_timeout = 0
}