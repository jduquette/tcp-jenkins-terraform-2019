#
# Create custom policy
#
resource "aws_iam_policy" "tcp_jenkins-custom-policy" {
  name   = "${var.prefix}--tcp_jenkins-custom-policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.tcp_jenkins_custom_policy_document.json}"
}