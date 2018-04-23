data "aws_ami" "ecs_ami" {
  count = "${length(var.stack_ami_version) > 0 ? 1 : 0}"

  filter {
    name = "name"
    values = ["buildkite-stack-${var.stack_ami_version}-*"]
  }

  owners = ["172840064832"]
  most_recent = true
}

resource "aws_cloudformation_stack" "stack" {
  name = "${var.stack_name}"
  template_url = "${var.stack_template_url}"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]

  parameters {
    AgentsPerInstance = "1"
    BuildkiteAgentToken = "${var.buildkite_agent_token}"
    BuildkiteQueue = "${var.stack_name}"
    ECRAccessPolicy = "poweruser"
    # https://github.com/hashicorp/terraform/issues/16726
    ImageId = "${element(concat(data.aws_ami.ecs_ami.*.id, list("")), 0)}"
    InstanceType = "${var.instance_type}"
    KeyName = "${var.key_name}"
    MaxSize = "${var.max_size}"
    MinSize = "${var.min_size}"
    ScaleDownAdjustment = "-${var.scale_adjustment}"
    ScaleDownPeriod = "3600"
    ScaleUpAdjustment = "${var.scale_adjustment}"
    SpotPrice = "${var.spot_price}"
  }

  lifecycle {
    ignore_changes = ["parameters.BuildkiteAgentToken"]
  }
}

resource "aws_s3_bucket_object" "stack_global_env" {
  bucket = "${aws_cloudformation_stack.stack.outputs["ManagedSecretsBucket"]}"
  key    = "/env"
  source = "${var.stack_config_env}"
  server_side_encryption = "aws:kms"
}