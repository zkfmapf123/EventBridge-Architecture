################################################## Provider ##################################################
provider "aws" {
  region = "ap-northeast-2"
}

terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
  }

  cloud {
    hostname     = "app.terraform.io" ## Fixed
    organization = "leedonggyu-org"   ## Organization Name

    ## Default Workspace
    workspaces {
      name = "service-purple"
    }
  }
}

################################################## Data ##################################################
data "tfe_outputs" "vpc" {
  organization = "leedonggyu-org"
  workspace    = "common-vpc"
}

data "tfe_outputs" "sqs" {
  organization = "leedonggyu-org"
  workspace    = "common-sqs"
}

locals {
  vpc = data.tfe_outputs.vpc.nonsensitive_values.vpc.vpc
  sqs = data.tfe_outputs.sqs.nonsensitive_values.queue
}


################################################ ECS ##################################################
module "purple" {
  source  = "zkfmapf123/ecs-fargate/lee"
  version = "1.0.3"

  prefix = "purple"

  vpc_attr = {
    vpc_id         = local.vpc.vpc_id
    alb_subnet_ids = values(local.vpc.webserver_subnets)
  }

  lb_attr = {
    internal             = false
    deregistration_delay = 60
  }

  lb_health = {
    path                = "/health"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }

  is_create_cluster = {
    is_enable           = false
    exists_cluster_name = "common-cluster"
  }

  is_create_ecr = {
    is_enable       = true
    exists_ecr_name = ""
  }

  ecs_attr = {
    port          = 3000
    cpu           = 256
    memory        = 512
    desired_count = 1
    subnet_ids    = values(local.vpc.was_subnets)
    is_public     = false
  }

  task_def = [{
    name      = "purple-container"
    image     = "${data.aws_ecr_repository.ecr.repository_url}:${random_id.version.hex}"
    cpu       = 256
    memory    = 512
    essential = true,

    environment = [
      {
        name  = "PORT",
        value = "3000"
      },
      {
        name  = "BLUE_QUEUE_URL",
        value = local.sqs.blue
      },
    ],
    portMappings = [
      {
        containerPort = 3000
        hostPort      = 3000
        protocol      = "tcp"
      },
    ],
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "purple"
        awslogs-create-group  = "true"
        awslogs-region        = "ap-northeast-2"
        awslogs-stream-prefix = "ecs"
      }
    }
  }]
}
