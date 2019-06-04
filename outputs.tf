output "IAM_ROLE_ARN" {
  value = "${aws_iam_role.role.arn}"
}

output "iam_role_name" {
  value = "${module.iam_role.iam_role_name}"
}

output "lb_sg_name" {
  value = "${module.lb_sg.this_security_group_name}"
}

output "lb_sg_id" {
  value = "${module.lb_sg.this_security_group_id}"
}

output "app_sg_id" {
  value = "${module.app_sg.this_security_group_id}"
}

output "profile_name" {
  value = "${aws_iam_instance_profile.profile.name}"
}