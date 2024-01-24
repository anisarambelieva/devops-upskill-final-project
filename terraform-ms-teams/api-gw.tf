resource "aws_api_gateway_rest_api" "approval_api" {
  name        = "ms-teams-approval_api"
  description = "MS Teams approval api"
  policy      = data.aws_iam_policy_document.webhook_api_gateway_policy.json

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_resource" "approval_resource" {
  rest_api_id = aws_api_gateway_rest_api.approval_api.id
  parent_id   = aws_api_gateway_rest_api.approval_api.root_resource_id
  path_part   = "approval"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.approval_api.id
  resource_id   = aws_api_gateway_resource.approval_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = aws_api_gateway_rest_api.approval_api.id
  resource_id = aws_api_gateway_resource.approval_resource.id
  http_method = aws_api_gateway_method.method.http_method

  integration_http_method = "POST" 
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.approval_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.approval_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.approval_resource.id,
      aws_api_gateway_method.method.id,
      aws_api_gateway_integration.integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  depends_on = [aws_cloudwatch_log_group.execution_logs]

  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.approval_api.id
  stage_name    = "prod"

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.access_logs.arn
    format          = "$context.identity.sourceIp $context.identity.caller $context.identity.user [$context.requestTime] $context.httpMethod $context.resourcePath $context.protocol $context.status $context.responseLength $context.requestId"
  }
}

resource "aws_api_gateway_method_settings" "webhook" {
  rest_api_id = aws_api_gateway_rest_api.approval_api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name

  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = var.api_execution_log_level
  }
}


resource "aws_cloudwatch_log_group" "access_logs" {
  name              = "/aws/apigw/ms-teams-lambda"
  retention_in_days = var.api_access_log_retention
  kms_key_id        = var.logs_kms_key_id

  tags = var.additional_tags
}

resource "aws_cloudwatch_log_group" "execution_logs" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.approval_api.id}/prod"
  retention_in_days = var.api_execution_log_retention
  kms_key_id        = var.logs_kms_key_id

  tags = var.additional_tags
}

data "aws_iam_policy_document" "webhook_api_gateway_policy" {
  statement {
    sid     = "AllowAllByDefault"
    effect  = "Allow"
    actions = ["execute-api:Invoke"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*/*/*/*"
    ]
  }

#   statement {
#     sid     = "BlockUnlessFromMSTeams"
#     effect  = "Deny"
#     actions = ["execute-api:Invoke"]
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }
#     resources = [
#       "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*/*/*/*"
#     ]
#     condition {
#       test     = "NotIpAddress"
#       variable = "aws:SourceIp"
#       values   = var.ms_teams_server_ips
#     }
#   }
}