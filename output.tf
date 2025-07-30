output "stepfunctions_state_machine_info" {
  value       = aws_sfn_state_machine.this
  
}

output "stepfunctions_activity_info" {
  value       = aws_sfn_activity.this
  
}

output "stepfunctions_alias_info" {
  value       = aws_sfn_alias.this
  
} 
