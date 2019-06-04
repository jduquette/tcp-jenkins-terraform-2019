provider "aws" {
  region     = "us-east-1"
}

#
# Create the necessary IAM ROLE and POLICIES
#

module "iam_role" {
	prefix = "${var.prefix}"
	ProjectName = "${var.ProjectName}"
	aws_email = "${var.aws_email}"
	source = "./modules/iam/role"		
}

#
# Create custom policy
#
module "iam_policy" {
	prefix = "${var.prefix}"
	ProjectName = "${var.ProjectName}"
	aws_email = "${var.aws_email}"
	source = "./modules/iam/policy"
}

#
# Attach custom policy
#
resource "aws_iam_role_policy_attachment" "attach-JenkinsPolicy" {
  role       = "${module.iam_role.iam_role_name}"
  policy_arn = "arn:aws:iam::090999229429:policy/${module.iam_policy.iam_policy_name}"
}

#
# Attach ReadOnly policy (?)
#
resource "aws_iam_role_policy_attachment" "attach-ReadOnly" {
  role       = "${module.iam_role.iam_role_name}"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}