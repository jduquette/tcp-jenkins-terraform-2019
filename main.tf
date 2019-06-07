provider "aws" {
  region = "us-east-1"
}

######################################
# Create the necessary IAM ROLE and POLICIES
######################################
module "iam_role" {
  prefix      = "${var.prefix}"
  ProjectName = "${var.ProjectName}"
  aws_email   = "${var.owner_email}"
  source      = "./modules/iam/role"
}

######################################
# Create custom policy
######################################
module "iam_policy" {
  prefix      = "${var.prefix}"
  ProjectName = "${var.ProjectName}"
  aws_email   = "${var.owner_email}"
  source      = "./modules/iam/policy"
}

######################################
# Attach custom policy
######################################
resource "aws_iam_role_policy_attachment" "attach-JenkinsPolicy" {
  role       = "${module.iam_role.iam_role_name}"
  policy_arn = "arn:aws:iam::${var.account_id}:policy/${module.iam_policy.iam_policy_name}"
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
  name                = "${var.prefix}-${var.ProjectName}-lbSG"
  description         = "Security Group for ${var.app_name} Load Balancer"
  vpc_id              = "${var.vpc_id}"
  ingress_cidr_blocks = ["${var.WholeWorldCIDR}"]
  tags = {
    Server_Function = "${var.app_name}",
    System          = "${var.system}",
    Fisma_ID        = "${var.fisma_id}",
    Environment     = "${var.Environment}",
    Owner           = "${var.owner_email}",
    Team            = "${var.Team}"
  }
}
######################################
# Create Security Group for EC2 Instance
######################################
module "app_sg" {
  source       = "terraform-aws-modules/security-group/aws"
  name         = "${var.prefix}-${var.ProjectName}-appSG"
  description  = "Security Group for ${var.app_name} Application Server"
  vpc_id       = "${var.vpc_id}"
  egress_rules = ["all-all"]
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-8080-tcp"
      source_security_group_id = "${module.lb_sg.this_security_group_id}"
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
  tags = {
    Server_Function = "${var.app_name}",
    System          = "${var.system}",
    Fisma_ID        = "${var.fisma_id}",
    Environment     = "${var.Environment}",
    Owner           = "${var.owner_email}",
    Team            = "${var.Team}"
  }
}

######################################
# Create Instance Profile
######################################
resource "aws_iam_instance_profile" "profile" {
  name = "${var.prefix}-${var.ProjectName}-instance-profile"
  role = "${module.iam_role.iam_role_name}"
}

######################################
# Create S3 Bucket for ELB Access Logs
######################################
resource "aws_s3_bucket" "elb_bucket" {
  bucket = lower("${var.prefix}-${var.ProjectName}-elb-access-logs")
  tags = {
    Name        = lower("${var.prefix}-${var.ProjectName}-elb_access_logs"),
    Function    = "${var.app_name}-lb-access_logs",
    System      = "${var.system}",
    Fisma_ID    = "${var.fisma_id}",
    Environment = "${var.Environment}",
    Owner       = "${var.owner_email}",
    Team        = "${var.Team}"
  }
}
######################################
# Update bucket policy to allow access for ELB log writes
######################################
resource "aws_s3_bucket_policy" "elb_bp" {
  bucket = "${aws_s3_bucket.elb_bucket.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "AWSConsole-AccessLogs-Policy-1559848379963",
  "Statement": [
    {
      "Sid": "AWSConsoleStmt-1559848379963",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::127311923021:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.elb_bucket.id}/AWSLogs/*"
    },
    {
      "Sid": "AWSLogDeliveryWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.elb_bucket.id}/AWSLogs/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "AWSLogDeliveryAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.elb_bucket.id}"
    }
  ]
}
EOF
}

######################################
# Create Elastic Load Balancer
######################################
resource "aws_elb" "app_elb" {
  name = "${var.prefix}-${var.ProjectName}-${var.app_name}-appELB"
  subnets = "${var.subnets}"
  security_groups = ["${module.lb_sg.this_security_group_id}"]
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 8080
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 10
    timeout = 60
    target = "HTTP:8080/login"
    interval = 300
  }
  access_logs {
    bucket = "${aws_s3_bucket.elb_bucket.id}"
    interval = 60
  }
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  tags = {
    Name = lower("${var.prefix}-${var.ProjectName}-${var.app_name}-appELB")
    Function = "${var.app_name}-ELB"
    System = "${var.system}",
    Fisma_ID = "${var.fisma_id}",
    Environment = "${var.Environment}",
    Owner = "${var.owner_email}",
    Team = "${var.Team}"
  }
  depends_on = [
    aws_s3_bucket.elb_bucket,
  aws_s3_bucket_policy.elb_bp]
}

######################################
# Create AutoScaling Group Launch Configuration
######################################
resource "aws_launch_configuration" "asg_conf" {
  name_prefix = lower("${var.prefix}")
  image_id = "${data.aws_ami.jenkins.id}"
  instance_type = "t2.xlarge"
  iam_instance_profile = "${aws_iam_instance_profile.profile.name}"
  key_name = "${var.KeypairName}"
  security_groups = ["${module.app_sg.this_security_group_id}"]
  ebs_block_device {
    device_name = "/dev/sde"
    volume_type = "gp2"
    volume_size = "400"
    delete_on_termination = true
  }
  root_block_device {
    volume_size = "50"
    volume_type = "gp2"
    delete_on_termination = true
  }
  user_data = <<EOF
#!/bin/bash --login


export HOME=/var/chef/solo;
export AWS_REGION=${var.region};
export kmskeyid=${var.kms_key};


# get attributes json


crossing get s3://${var.provision_bucket_name}/jenkins/deployment_id/attributes.json /var/chef/solo/;
echo 'attributes json is downloaded';


# get data_bags objects


mkdir -p /var/chef/solo/data_bags/jenkins;
crossing get s3://${var.provision_bucket_name}/jenkins/deployment_id/data_bags/credentials.json /var/chef/solo/data_bags/jenkins;
crossing get s3://${var.provision_bucket_name}/jenkins/deployment_id/data_bags/local_users.json /var/chef/solo/data_bags/jenkins;
echo 'data_bags are downloaded';


# running chef for default_firstboot recipe


chef-solo \
  -j /var/chef/solo/attributes.json \
  -c /var/chef/solo/solo.rb \
  -l info -L /var/log/chef.log;


# delete credentials


rm -rf data_bags;
service jenkins restart;

EOF

  ####  Add Provisioners Here for User_Data items ####
  lifecycle {
    create_before_destroy = true
  }
}

######################################
# Create AutoScaling Group
######################################
resource "aws_autoscaling_group" "app_asg" {
  name                 = "${var.prefix}-${var.ProjectName}-${var.app_name}-ASG"
  launch_configuration = "${aws_launch_configuration.asg_conf.name}"
  min_size             = 1
  max_size             = 1
  vpc_zone_identifier  = "${var.subnets}"
  load_balancers       = ["${aws_elb.app_elb.name}"]
  health_check_type    = "EC2"
  tag {
    key                 = "Name"
    value               = "${var.prefix}-${var.ProjectName}-${var.app_name}-ASG"
    propagate_at_launch = true
  }
  tag {
    key                 = "Function"
    value               = "${var.app_name}-ApplicationServer"
    propagate_at_launch = true
  }
  tag {
    key                 = "Owner"
    value               = "${var.owner_email}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = "${var.Environment}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Team"
    value               = "${var.Team}"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
