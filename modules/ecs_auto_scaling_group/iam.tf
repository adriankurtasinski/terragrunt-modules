resource "aws_iam_instance_profile" "ecs_instance_profile" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.environment_name}-ecs-instance"
  role = "${aws_iam_role.ecs_instance_role.name}"
}

resource "aws_iam_role" "ecs_instance_role" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.environment_name}-ecs-instance"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.environment_name}-ecs-instance"
  role = "${aws_iam_role.ecs_instance_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
