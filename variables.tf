#######################################
# Data Resources for Application Stack
#######################################

data "aws_region" "current" {}

data "aws_iam_policy_document" "tcp_jenkins_custom_policy_document" {
  statement {
    sid = "${var.prefix}TcpJenkinsPermissions"
    actions = [
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateLaunchConfiguration",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:DeleteLaunchConfiguration",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalableTargets",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeScalingPolicies",
      "autoscaling:UpdateAutoScalingGroup",
      "cloudformation:CreateChangeSet",
      "cloudformation:CreateStack",
      "cloudformation:DeleteChangeSet",
      "cloudformation:DeleteStack",
      "cloudformation:DescribeChangeSet",
      "cloudformation:DescribeStackEvents",
      "cloudformation:DescribeStackResources",
      "cloudformation:DescribeStacks",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:GetTemplate",
      "cloudformation:GetTemplateSummary",
      "cloudformation:ListStackResources",
      "cloudformation:UpdateStack",
      "cloudformation:ValidateTemplate",
      "cloudtrail:LookupEvents",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "dynamodb:BatchGetItem",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:DescribeContinuousBackups",
      "dynamodb:DescribeTable",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:ListBackups",
      "dynamodb:ListGlobalTables",
      "dynamodb:ListTables",
      "dynamodb:ListTagsOfResource",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
      "dynamodb:UpdateTable",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CopyImage",
      "ec2:CreateImage",
      "ec2:CreateKeyPair",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteKeyPair",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSnapshot",
      "ec2:DeleteTags",
      "ec2:DeregisterImage",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:DescribeSubnets",
      "ec2:DescribeVolumes",
      "ec2:DescribeVpcs",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifySnapshotAttribute",
      "ec2:RebootInstances",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RunInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "iam:AddRoleToInstanceProfile",
      "iam:CreateInstanceProfile",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:DeleteServerCertificate",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:GetServerCertificate",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListRolePolicies",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:RemoveRoleFromInstanceProfile",
      "kms:CreateAlias",
      "kms:CreateGrant",
      "kms:CreateKey",
      "kms:Decrypt",
      "kms:DeleteAlias",
      "kms:DescribeKey",
      "kms:DisableKey",
      "kms:EnableKey",
      "kms:EnableKeyRotation",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:ListAliases",
      "kms:ListGrants",
      "kms:ListKeyPolicies",
      "kms:ListKeys",
      "kms:ListResourceTags",
      "kms:PutKeyPolicy",
      "kms:ReEncryptFrom",
      "kms:ReEncryptTo",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:UpdateAlias",
      "rds:CreateDBInstance",
      "rds:DescribeDBInstances",
      "s3:CompleteMultipartUpload",
      "s3:CreateMultipartUpload",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:HeadObject",
      "s3:ListObjectVersions",
      "s3:ListObjects",
      "s3:PutObject",
      "s3:UploadPart",
      "sts:AssumeRole",
      "sts:DecodeAuthorizationMessage"
    ]
    resources = ["*"]

  }
}

data "aws_ami" "jenkins" {
  most_recent = true

  filter {
    name   = "name"
    values = ["jenkins-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["090999229429"] # Canonical
}

#######################################
# Application Variables
#######################################
variable "ProjectName" {
  description = "The project name [tcp]"
  type        = "string"
  default     = "tcp"
}

variable "Environment" {
  description = "**DHS Required Tag**\nEnvironment type. [non-prod]"
  type        = "string"
  default     = "non-prod"
}

variable "InstanceType" {
  description = "Instance size to use [t2.xlarge]"
  type        = "string"
  default     = "t2.xlarge"
}

variable "KeypairName" {
  description = "KeyPair used for external access (i.e. ssh)"
  type        = "string"
  default     = "duquette"
}

variable "Team" {
  description = "Team Name"
  type        = "string"
  default     = "NoBodyKnows"
}

variable "WholeWorldCIDR" {
  description = "CIDR block to use [0.0.0.0/0]"
  type        = "string"
  default     = "0.0.0.0/0"
}

variable "owner_email" {
  description = "user e-mail address"
  type        = "string"
  default     = "john.duquette@excella.com"
}

variable "prefix" {
  description = "Prefix used for identification of all created resources.  Leave blank if necessary"
  type        = "string"
  default     = "Duquette"
}

variable "region" {
  description = "AWS Region"
  type        = "string"
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application Name (i.e. Jenkins, MyCoolRailsApp, etc.)"
  type        = "string"
  default     = "jenkins"
}

variable "kms_key" {
  description = "KMS used for de/encryption"
  type        = "string"
  default     = "d89692d6-0171-4f71-8746-b116cfc5d844"
}

variable "provision_bucket_name" {
  description = "S3 Bucket with provision files/scripts"
  type        = "string"
  default     = "tcp-secret-store"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = "string"
  default     = "090999229429"
}

variable "vpc_id" {
  description = "ID of the VPC to use"
  type        = "string"
  default     = "vpc-023440f11753798e5"
}

variable "system" {
  description = "Client Specific System Name"
  type        = "string"
  default     = "ATA"
}

variable "fisma_id" {
  description = "Client FISMA ID"
  type        = "string"
  default     = "TBD"
}

variable "subnets" {
  description = "List of Subnets to use"
  type        = "list"
  default     = ["subnet-018118375aa52d481"]
}
