#
# Create the necessary IAM ROLE
#
resource "aws_iam_role" "iam_role" {
  name = "${var.prefix}-jenkins-${var.ProjectName}-role"
  description = "Jenkins IAM Role used for ${var.ProjectName}"
  tags = {
  	OwnerContact = "${var.aws_email}"
  }
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Action": "sts:AssumeRole",
   "Principal": {
   "Service": "ec2.amazonaws.com"
  },
  "Effect": "Allow",
  "Sid": ""
  }
 ]
}
EOF
}