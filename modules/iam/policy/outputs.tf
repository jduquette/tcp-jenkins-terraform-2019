output "IAM_POLICY_ARN" {
  value = "${aws_iam_policy.tcp_jenkins-custom-policy.arn}"
}

output "iam_policy_name" {
  value = "${aws_iam_policy.tcp_jenkins-custom-policy.name}"
}