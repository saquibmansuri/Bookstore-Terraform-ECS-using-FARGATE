

# Creating CloudWatch Logs log groups for ECS tasks

# For DB Migrator
resource "aws_cloudwatch_log_group" "db_migrator_log_group" {
  name              = "/ecs/TD-DbMigrator"
  retention_in_days = 90 # Set the desired retention period in days
}

# For Web
resource "aws_cloudwatch_log_group" "web_log_group" {
  name              = "/ecs/TD-Web"
  retention_in_days = 90 # Set the desired retention period in days
}

# For HTTP API Host
resource "aws_cloudwatch_log_group" "http_api_host_log_group" {
  name              = "/ecs/TD-HttpApiHost"
  retention_in_days = 90 # Set the desired retention period in days
}

# For Auth Server
resource "aws_cloudwatch_log_group" "auth_server_log_group" {
  name              = "/ecs/TD-AuthServer"
  retention_in_days = 90 # Set the desired retention period in days
}




# CREATING TASK DEFINITION FOR DB MIGRATOR
resource "aws_ecs_task_definition" "td_db_migrator" {
  family                   = "TD-DbMigrator"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  cpu   = 512
  memory= 1024
  
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name  = "DbMigrator"
      image = "505660359349.dkr.ecr.us-east-1.amazonaws.com/bookstore-app:db-migrator-latest"
      cpu   = 512
      memory= 1024
      portMappings = [
        {
          containerPort = 5432
          protocol      = "tcp"
          application   = "http"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/TD-DbMigrator"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      
      }
      environment = [
        {
          name  = "AWS_DEFAULT_REGION"
          value = "us-east-1"
        },
        {
          name  = "RUNNING_ENVIRONMENT"
          value = "Prod"
        },
        # Add more environment variables as needed
      ]
    }
  ])
}


# CREATING TASK DEFINITION FOR WEB
resource "aws_ecs_task_definition" "td_web" {
  family                   = "TD-Web"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  cpu   = 512
  memory= 1024
  
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name  = "Web"
      image = "505660359349.dkr.ecr.us-east-1.amazonaws.com/bookstore-app:web-latest"
      cpu   = 512
      memory= 1024
      portMappings = [
        {
          containerPort = 443  
          protocol      = "tcp"
          application   = "https"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/TD-Web"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }
      environment = [
        {
          name  = "AWS_DEFAULT_REGION"
          value = "us-east-1"
        },
        {
          name  = "RUNNING_ENVIRONMENT"
          value = "Prod"
        },
        {
          name  = "ASPNETCORE_URLS"
          value = "https://+"
        },
        {
          name  = "ASPNETCORE_HTTPS_PORT"
          value = "5002"
        },
        {
          name  = "ASPNETCORE_Kestrel__Certificates__Default__Password"
          value = "P@ssw0rd"
        },
        {
          name  = "ASPNETCORE_Kestrel__Certificates__Default__Path"
          value = "/https/certificate.pfx"
        },
        # Add more environment variables as needed
      ]
    }
  ])
}


# CREATING TASK DEFINITION FOR HTTP_API_HOST
resource "aws_ecs_task_definition" "td_http_api_host" {
  family                   = "TD-HttpApiHost"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  cpu   = 512
  memory= 1024
  
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name  = "HttpApiHost"
      image = "505660359349.dkr.ecr.us-east-1.amazonaws.com/bookstore-app:http-api-host-latest"
      cpu   = 512
      memory= 1024
      portMappings = [
        {
          containerPort = 443  
          protocol      = "tcp"
          application   = "https"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/TD-HttpApiHost"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }
      environment = [
        {
          name  = "AWS_DEFAULT_REGION"
          value = "us-east-1"
        },
        {
          name  = "RUNNING_ENVIRONMENT"
          value = "Prod"
        },
        {
          name  = "ASPNETCORE_URLS"
          value = "https://+"
        },
        {
          name  = "ASPNETCORE_HTTPS_PORT"
          value = "5001"
        },
        {
          name  = "ASPNETCORE_Kestrel__Certificates__Default__Password"
          value = "P@ssw0rd"
        },
        {
          name  = "ASPNETCORE_Kestrel__Certificates__Default__Path"
          value = "/https/certificate.pfx"
        },
        # Add more environment variables as needed
      ]
    }
  ])
}

# CREATING TASK DEFINITION FOR AUTH SERVER
resource "aws_ecs_task_definition" "td_auth_server" {
  family                   = "TD-AuthServer"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  cpu   = 512
  memory= 1024
  
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name  = "AuthServer"
      image = "505660359349.dkr.ecr.us-east-1.amazonaws.com/bookstore-app:authserver-latest"
      cpu   = 512
      memory= 1024
      portMappings = [
        {
          containerPort = 443  
          protocol      = "tcp"
          application   = "https"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/TD-AuthServer"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }
      environment = [
        {
          name  = "AWS_DEFAULT_REGION"
          value = "us-east-1"
        },
        {
          name  = "RUNNING_ENVIRONMENT"
          value = "Prod"
        },
        {
          name  = "ASPNETCORE_URLS"
          value = "https://+"
        },
        {
          name  = "ASPNETCORE_HTTPS_PORT"
          value = "5003"
        },
        {
          name  = "ASPNETCORE_Kestrel__Certificates__Default__Password"
          value = "P@ssw0rd"
        },
        {
          name  = "ASPNETCORE_Kestrel__Certificates__Default__Path"
          value = "/https/certificate.pfx"
        },
        # Add more environment variables as needed
      ]
    }
  ])
}













# CREATING BOOKSTORE CLUSTER
resource "aws_ecs_cluster" "bookstore_cluster" {
  name = "bookstore_cluster"
}

resource "aws_ecs_cluster_capacity_providers" "bookstore_cp" {
  cluster_name = aws_ecs_cluster.bookstore_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 1
    capacity_provider = "FARGATE"
  }
}



# CREATING ECS SERVICE FOR DB MIGRATOR
resource "aws_ecs_service" "db_migrator_service" {
  name            = "DBMigratorService"
  cluster         = aws_ecs_cluster.bookstore_cluster.id
  task_definition = aws_ecs_task_definition.td_db_migrator.arn
  desired_count   = 1     # Desired tasks: 1

  network_configuration {
    subnets = [aws_subnet.bookstore_subnet1.id]
    security_groups = [aws_security_group.bookstore_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_db_migrator.arn
    container_name   = "DbMigrator"
    container_port   = 5432
  }
}


# CREATING SERVICE FOR WEB
resource "aws_ecs_service" "web_service" {
  name            = "WebService"
  cluster         = aws_ecs_cluster.bookstore_cluster.id
  task_definition = aws_ecs_task_definition.td_web.arn
  desired_count   = 1     # Desired tasks: 1

  network_configuration {
    subnets = [aws_subnet.bookstore_subnet2.id]
    security_groups = [aws_security_group.bookstore_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_web.arn
    container_name   = "Web"
    container_port   = 443
  }

  # Ensuring that the web_service depends on the db_migrator_service
  depends_on = [aws_ecs_service.db_migrator_service]
}


# CREATING SERVICE FOR HTTP API HOST
resource "aws_ecs_service" "http_api_host_service" {
  name            = "HttpApiHostService"
  cluster         = aws_ecs_cluster.bookstore_cluster.id
  task_definition = aws_ecs_task_definition.td_http_api_host.arn
  desired_count   = 1     # Desired tasks: 1

  network_configuration {
    subnets = [aws_subnet.bookstore_subnet2.id]
    security_groups = [aws_security_group.bookstore_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_http_api_host.arn
    container_name   = "HttpApiHost"
    container_port   = 443
  }

  # Ensure that the http_api_host_service depends on the db_migrator_service
  depends_on = [aws_ecs_service.db_migrator_service]
}


# CREATING SERVICE FOR AUTH SERVER
resource "aws_ecs_service" "auth_server_service" {
  name            = "AuthServerService"
  cluster         = aws_ecs_cluster.bookstore_cluster.id
  task_definition = aws_ecs_task_definition.td_auth_server.arn
  desired_count   = 1     # Desired tasks: 1

  network_configuration {
    subnets = [aws_subnet.bookstore_subnet2.id]
    security_groups = [aws_security_group.bookstore_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_auth_server.arn
    container_name   = "AuthServer"
    container_port   = 443
  }

  # Ensure that the auth_server_service depends on the db_migrator_service
  depends_on = [aws_ecs_service.db_migrator_service]
}

