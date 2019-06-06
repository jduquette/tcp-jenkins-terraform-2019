output "IAM_ROLE_ARN" {
  value = "${aws_iam_role.iam_role.arn}"
}

output "iam_role_name" {
	value = "${aws_iam_role.iam_role.name}"
}
