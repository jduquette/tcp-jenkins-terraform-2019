output "app_asg_arn" {
  value = "${aws_autoscaling_group.app_asg.arn}"
}

output "app_asg_id" {
  value = "${aws_autoscaling_group.app_asg.id}"
}

output "app_asg_name" {
  value = "${aws_autoscaling_group.app_asg.name}"
}

output "app_elb_arn" {
  value = "${aws_elb.app_elb.arn}"
}

output "app_elb_id" {
  value = "${aws_elb.app_elb.id}"
}

output "app_elb_name" {
  value = "${aws_elb.app_elb.name}"
}

output "app_sg_id" {
  value = "${module.app_sg.this_security_group_id}"
}

output "app_sg_name" {
  value = "${module.app_sg.this_security_group_name}"
}

output "asg_config_id" {
  value = "${aws_launch_configuration.asg_conf.id}"
}

output "asg_config_name" {
  value = "${aws_launch_configuration.asg_conf.name}"
}

output "elb_bucket_name" {
  value = "${aws_s3_bucket.elb_bucket.id}"
}

output "iam_role_name" {
  value = "${module.iam_role.iam_role_name}"
}

output "iam_role_arn" {
  value = "${module.iam_role.iam_role_arn}"
}

output "iam_policy_arn" {
  value = "${module.iam_policy.iam_policy_arn}"
}

output "iam_policy_name" {
  value = "${module.iam_policy.iam_policy_name}"
}

output "lb_sg_name" {
  value = "${module.lb_sg.this_security_group_name}"
}

output "lb_sg_id" {
  value = "${module.lb_sg.this_security_group_id}"
}

output "profile_name" {
  value = "${aws_iam_instance_profile.profile.name}"
}

output "profile_id" {
  value = "${aws_iam_instance_profile.profile.id}"
}

output "profile_arn" {
  value = "${aws_iam_instance_profile.profile.arn}"
}
