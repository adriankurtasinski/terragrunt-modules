locals {
  desired_capacity = "${length(var.desired_capacity) > 0 ? var.desired_capacity : "2"}"
  ecs_ami_version = "${length(var.ecs_ami_version) > 0 ? var.ecs_ami_version : "2017.03.g"}"
  max_size = "${length(var.max_size) > 0 ? var.max_size : "4"}"
  min_size = "${length(var.min_size) > 0 ? var.min_size : "2"}"
}

module "vpc" {
  source = "../../modules/vpc"
  skip = "${var.skip}"

  environment_name = "${var.environment_name}"
  vpc_cidr = "${var.vpc_cidr}"
}

module "ecs_subnets" {
  source = "../../modules/public_private_subnets"
  skip = "${var.skip}"

  environment_name = "${var.environment_name}"
  internet_gw_id = "${module.vpc.internet_gw_id}"
  private_subnets = "${var.private_ecs_subnets}"
  public_subnets = "${var.public_subnets}"
  subnet_adjective = "ECS"
  vpc_id = "${module.vpc.vpc_id}"
}

module "ecs_cluster" {
  source = "../../modules/ecs_cluster"
  skip = "${var.skip}"

  name = "${var.environment_name}-cluster"
}

module "ecs_auto_scaling_group" {
  source = "../../modules/ecs_auto_scaling_group"
  skip = "${var.skip}"

  desired_capacity = "${local.desired_capacity}"
  max_size = "${local.max_size}"
  min_size = "${local.min_size}"

  ec2_subnet_ids = "${module.ecs_subnets.private_subnet_ids}"
  ecs_ami_version = "${local.ecs_ami_version}"
  ecs_cluster_name = "${module.ecs_cluster.ecs_cluster_name}"
  environment_name = "${var.environment_name}"
  lc_instance_type = "${var.lc_instance_type}"
  public_key = "${var.ec2_public_key}"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "log_group" {
  source = "../../modules/log_group"
  skip = "${var.skip}"

  name = "${var.environment_name}-log"
}