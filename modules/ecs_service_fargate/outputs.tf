output "ecs_service_name" {
  value = aws_ecs_service.ecs_service.name
}

output "task_arn" {
  value = aws_ecs_task_definition.ecs_task.arn
}

output "my_ecs_service" {
  value = aws_ecs_service.ecs_service
}


output "my_ecs_task" {
  value = aws_ecs_task_definition.ecs_task
}

output "iam_id" {
  value = aws_iam_role.ecs_taskrole.id
}
