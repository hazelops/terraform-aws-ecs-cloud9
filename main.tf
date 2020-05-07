data "aws_region" "current" {}

locals {
  secret_names = concat(var.secret_names, [
  ])

  environment = merge(var.environment,
    {
      PUID: "1000"
      PGID: "1000"
      TZ: "America/Los_Angeles"
      USERNAME: "admin"
      PASSWORD: "Vr4KqHBgjLMMk92fsMkLd^ibHCJsy"
//      ECS_FARGATE = var.ecs_launch_type == "FARGATE" ? "true" : "false"
    }
  )

  container_definition = {
      name              = var.name
      image = "${var.docker_image_name}:${var.docker_image_tag}",
      memoryReservation = 128,
      essential = true,

      environment = [for k, v in local.environment : {name = k, value = v}]
      secrets = module.ssm.secrets

      portMappings = [{
       containerPort = var.docker_container_port,
       // In case of bridge an host use a dynamid port (0)
       hostPort = var.ecs_network_mode == "awsvpc" ? var.docker_container_port : 0
      }]

      volumeMappings = var.ecs_launch_type == "FARGATE" ? [] : [
        {
          containerVolume = "/var/run/docker.sock",
          hostVolume = "/var/run/docker.sock"
        }
      ],



//      logConfiguration = var.cloudwatch_log_group == "" ? {
//        logDriver = "json-file"
//      } : {
//        logDriver = "awslogs",
//        options = {
//          awslogs-group = var.cloudwatch_log_group
//          awslogs-region = data.aws_region.current.name
//          awslogs-stream-prefix = var.name
//        }
//      }
    }


}

module "ssm" {
  source = "../ssm-secrets"
  env = var.env
  app_name = var.app_name
  names = local.secret_names
}
