resource "aws_sfn_state_machine" "this" {
  for_each = var.stepfunctions_state_machine_create

  name     = each.value.name
  role_arn = each.value.role_arn
  definition = each.value.definition

  type = lookup(each.value, "type", "STANDARD")

  logging_configuration {
    level                  = lookup(each.value, "log_level", "OFF")
    include_execution_data = lookup(each.value, "include_execution_data", false)
    log_destination        = lookup(each.value, "log_destination", null)
  }

  tags = merge(
    {
      Name = each.value.name
      Type = "stepfunctions-state-machine"
    },
    lookup(each.value, "tags", {})
  )
}

resource "aws_sfn_activity" "this" {
  for_each = var.stepfunctions_activity_create

  name = each.value.name

  tags = merge(
    {
      Name = each.value.name
      Type = "stepfunctions-activity"
    },
    lookup(each.value, "tags", {})
  )
}

resource "aws_sfn_alias" "this" {
  for_each = var.stepfunctions_alias_create

  name             = each.value.name
  state_machine_name = aws_sfn_state_machine.this[each.value.state_machine_key].name

  routing_configuration {
    state_machine_version_arn = aws_sfn_state_machine.this[each.value.state_machine_key].arn
    weight                    = each.value.weight
  }
} 