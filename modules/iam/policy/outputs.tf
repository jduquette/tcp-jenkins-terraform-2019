output "iam_policy_arn" {
  value = "${aws_iam_policy.tcp_jenkins-custom-policy.arn}"
}

output "iam_policy_name" {
  value = "${aws_iam_policy.tcp_jenkins-custom-policy.name}"
}
