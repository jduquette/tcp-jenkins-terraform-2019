#
# Variables file for TCP Jenkins instance
#
#

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

variable "ProjectName" {
	description = "The project name [tcp]"
	type = "string"
	default = "tcp"
}

variable "AmiID" {
	description = "AMI ID to use [ami-0a6b05251d155bf77 - latest jenkins build]"
	type = "string"
	default = "ami-0a6b05251d155bf77"
}

variable "Environment" {	
	description = "**DHS Required Tag**\nEnvironment type. [non-prod]"
	type = "string"
	default = "non-prod"
}

variable "InstanceType" {
	description = "Instance size to use [t2.xlarge]"
	type = "string"
	default = "t2.xlarge"
}

## TODO: Save for later
#variable "KeypairName" {
#	description = "KeyPair used for external access (i.e. ssh)"
#	type = "string"
#}

variable "Team" {
	description = "Team Name"
	type = "string"
	default = "NoBodyKnows"
}

variable "WholeWorldCIDR" {
	description = "CIDR block to use [10.0.0.0/8]"
	type = "string"
	default = "10.0.0.0/8"
}

## TODO: Remove default to force entry.
variable "aws_email" {
	description = "user e-mail address"
	type = "string"
	default = "john.duquette@excella.com"
}

variable "prefix" {
	description = "Prefix used for identification of all created resources.  Leave blank if necessary"
	type = "string"
	default = "Duquette"
}	