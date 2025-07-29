output "stepfunctions_state_machine_info" {
  value       = aws_sfn_state_machine.this
  description = "Module output for stepfunctions state machine information"
}

output "stepfunctions_activity_info" {
  value       = aws_sfn_activity.this
  description = "Module output for stepfunctions activity information"
}

output "stepfunctions_alias_info" {
  value       = aws_sfn_alias.this
  description = "Module output for stepfunctions alias information"
} 