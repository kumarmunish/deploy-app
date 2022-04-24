output "subnetid" {
  description = "subnet a id"
  value       = aws_default_subnet.default_subnet_1.id
}

output "securitygroupid" {
  description = "ecs service security group id"
  value       = aws_security_group.service_security_group.id
}

output "dns_name" {
  description = "alb dns to access the application"
  value       = join("", ["http://", aws_alb.application_load_balancer.dns_name, ":3000/"])
}

output "ecs_cluster_name" {
  description = "name of the ecs cluster"
  value       = aws_ecs_cluster.ecs_cluster.name
}