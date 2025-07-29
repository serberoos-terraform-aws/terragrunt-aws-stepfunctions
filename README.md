# Terragrunt AWS Step Functions Module

AWS Step Functions를 관리하기 위한 Terraform 모듈입니다.

## 기능

- Step Functions 상태 머신 생성 및 관리
- Step Functions 액티비티 생성 및 관리
- Step Functions 별칭 생성 및 관리
- 로깅 설정 지원
- 태그 관리

## 사용법

### 기본 Step Functions 상태 머신 생성

```hcl
include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = find_in_parent_folders("env.hcl")
}

terraform {
  source = "tfr://serberoos-terraform-aws/terragrunt-aws-stepfunctions//?version=1.0.0"
}

inputs = {
  stepfunctions_state_machine_create = {
    "main-state-machine" = {
      name = "my-workflow"
      role_arn = "arn:aws:iam::123456789012:role/StepFunctionsExecutionRole"
      definition = jsonencode({
        StartAt = "StartState"
        States = {
          StartState = {
            Type = "Pass"
            Result = "Hello World"
            End = true
          }
        }
      })
      type = "STANDARD"
      tags = {
        Environment = "production"
        Project = "my-app"
      }
    }
  }
}
```

### 로깅이 활성화된 상태 머신

```hcl
inputs = {
  stepfunctions_state_machine_create = {
    "logging-state-machine" = {
      name = "my-logging-workflow"
      role_arn = "arn:aws:iam::123456789012:role/StepFunctionsExecutionRole"
      definition = jsonencode({
        StartAt = "StartState"
        States = {
          StartState = {
            Type = "Pass"
            Result = "Hello World"
            End = true
          }
        }
      })
      type = "STANDARD"
      log_level = "ALL"
      include_execution_data = true
      log_destination = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/states/my-workflow"
      tags = {
        Environment = "production"
        Logging = "enabled"
      }
    }
  }
}
```

### Step Functions 액티비티 생성

```hcl
inputs = {
  stepfunctions_activity_create = {
    "my-activity" = {
      name = "my-custom-activity"
      tags = {
        Environment = "production"
        Type = "custom-activity"
      }
    }
  }
}
```

### Step Functions 별칭 생성

```hcl
inputs = {
  stepfunctions_state_machine_create = {
    "main-state-machine" = {
      name = "my-workflow"
      role_arn = "arn:aws:iam::123456789012:role/StepFunctionsExecutionRole"
      definition = jsonencode({
        StartAt = "StartState"
        States = {
          StartState = {
            Type = "Pass"
            Result = "Hello World"
            End = true
          }
        }
      })
    }
  }
  
  stepfunctions_alias_create = {
    "production-alias" = {
      name = "production"
      state_machine_key = "main-state-machine"
      weight = 100
    }
  }
}
```

## 변수

### stepfunctions_state_machine_create

Step Functions 상태 머신 생성 설정

| 변수명 | 타입 | 기본값 | 설명 |
|--------|------|--------|------|
| name | string | - | 상태 머신 이름 (필수) |
| role_arn | string | - | 실행 역할 ARN (필수) |
| definition | string | - | 상태 머신 정의 JSON (필수) |
| type | string | "STANDARD" | 상태 머신 타입 (STANDARD/EXPRESS) |
| log_level | string | "OFF" | 로그 레벨 (OFF/ERROR/ALL) |
| include_execution_data | bool | false | 실행 데이터 포함 여부 |
| log_destination | string | null | 로그 대상 ARN |
| tags | map | {} | 태그 |

### stepfunctions_activity_create

Step Functions 액티비티 생성 설정

| 변수명 | 타입 | 설명 |
|--------|------|------|
| name | string | 액티비티 이름 (필수) |
| tags | map | 태그 |

### stepfunctions_alias_create

Step Functions 별칭 생성 설정

| 변수명 | 타입 | 설명 |
|--------|------|------|
| name | string | 별칭 이름 (필수) |
| state_machine_key | string | 참조할 상태 머신의 키 (필수) |
| weight | number | 라우팅 가중치 (필수) |

## 출력

### stepfunctions_state_machine_info

생성된 Step Functions 상태 머신 정보

### stepfunctions_activity_info

생성된 Step Functions 액티비티 정보

### stepfunctions_alias_info

생성된 Step Functions 별칭 정보

## 예시

```hcl
# 출력 사용 예시
output "state_machine_arn" {
  value = module.stepfunctions.stepfunctions_state_machine_info["main-state-machine"].arn
}

output "state_machine_name" {
  value = module.stepfunctions.stepfunctions_state_machine_info["main-state-machine"].name
}

output "activity_arn" {
  value = module.stepfunctions.stepfunctions_activity_info["my-activity"].arn
}
```

## 상태 머신 정의 예시

### 간단한 Pass 상태

```json
{
  "StartAt": "StartState",
  "States": {
    "StartState": {
      "Type": "Pass",
      "Result": "Hello World",
      "End": true
    }
  }
}
```

### 조건부 분기

```json
{
  "StartAt": "CheckCondition",
  "States": {
    "CheckCondition": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.value",
          "NumericEquals": 1,
          "Next": "State1"
        },
        {
          "Variable": "$.value",
          "NumericEquals": 2,
          "Next": "State2"
        }
      ],
      "Default": "DefaultState"
    },
    "State1": {
      "Type": "Pass",
      "Result": "Value was 1",
      "End": true
    },
    "State2": {
      "Type": "Pass",
      "Result": "Value was 2",
      "End": true
    },
    "DefaultState": {
      "Type": "Pass",
      "Result": "Default value",
      "End": true
    }
  }
}
```

### Lambda 함수 호출

```json
{
  "StartAt": "InvokeLambda",
  "States": {
    "InvokeLambda": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:my-function",
      "End": true
    }
  }
}
```

## 라이선스

MIT License
