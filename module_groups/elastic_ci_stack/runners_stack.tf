module "runners_stack" {
  source = "../../modules/buildkite_elastic_stack"

  buildkite_agent_token = "${var.buildkite_agent_token}"
  instance_type = "c5.large"
  key_name = "${aws_key_pair.key_pair.key_name}"
  max_size = "64"
  scale_adjustment = "32"
  spot_price = "0.085"
  stack_ami_version = "${var.stack_ami_version}"
  stack_config_env = "${var.stack_config_env}"
  stack_name = "${var.buildkite_env_name}-runners"
  stack_template_url = "${var.stack_template_url}"
}