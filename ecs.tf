resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_cluster"
}


# Create task definations

resource "aws_ecs_task_definition" "service_task" {
  family                   = "service_task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions = jsonencode([
    {
      name    = "service_task"
      image   = "servian/techchallengeapp:latest"
      command = ["serve"]
      secrets = [{ "name" : "VTT_DBPASSWORD", "valueFrom" : aws_ssm_parameter.db_password.arn }]
      environment = [
        { "name" : "VTT_DBHOST", "value" : "${aws_db_instance.appdb.address}" },
        { "name" : "VTT_DBPORT", "value" : "${tostring(var.dbport)}" },
        { "name" : "VTT_DBUSER", "value" : "${var.db_username}" },
        { "name" : "VTT_DBNAME", "value" : "app" },
        { "name" : "VTT_LISTENHOST", "value" : "0.0.0.0" }
      ]
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "updatedb_task" {
  family                   = "updatedb_task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions = jsonencode([
    {
      name    = "updatedb_task"
      image   = "servian/techchallengeapp:latest"
      command = ["updatedb", "-s"]
      secrets = [{ "name" : "VTT_DBPASSWORD", "valueFrom" : aws_ssm_parameter.db_password.arn }]
      environment = [
        { "name" : "VTT_DBHOST", "value" : "${aws_db_instance.appdb.address}" },
        { "name" : "VTT_DBPORT", "value" : "${tostring(var.dbport)}" },
        { "name" : "VTT_DBUSER", "value" : "${var.db_username}" },
        { "name" : "VTT_DBNAME", "value" : "app" },
        { "name" : "VTT_LISTENHOST", "value" : "0.0.0.0" }
      ]
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "app_service" {
  name            = "app_service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.service_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = aws_ecs_task_definition.service_task.family
    container_port   = 3000 # Specifying the container port
  }

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_1.id}", "${aws_default_subnet.default_subnet_2.id}", "${aws_default_subnet.default_subnet_3.id}"]
    assign_public_ip = true
    security_groups  = ["${aws_security_group.service_security_group.id}"]
  }
}


resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.app_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "autoscale_policy_cpu" {
  name               = "autoscale_policy_cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70
  }
}

resource "aws_appautoscaling_policy" "autoscale_policy_memory" {
  name               = "autoscale_policy_memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }
}
