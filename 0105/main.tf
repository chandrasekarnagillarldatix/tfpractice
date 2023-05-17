provider "aws" {
    region = "us-west-2"  
}

resource "aws_api_gateway_rest_api" "agw_rapi" {

  name = "oregonapi"

  endpoint_configuration {
    types = ["REGIONAL"]
  }


body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "example"
      version = "1.0"
    }
    paths = {
      "/path1" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }
}
)

}


resource "aws_api_gateway_rest_api_policy" "agw_rapi_policy" {

  rest_api_id = aws_api_gateway_rest_api.agw_rapi.id
  policy      = data.aws_iam_policy_document.policydoc.json
  
}

resource "aws_api_gateway_resource" "agw_oregon" {

    rest_api_id = aws_api_gateway_rest_api.agw_rapi.id
    parent_id = aws_api_gateway_rest_api.agw_rapi.root_resource_id
    path_part = "path2"
    
}

resource "aws_api_gateway_method" "api_method" {
    rest_api_id = aws_api_gateway_rest_api.agw_rapi.id
    resource_id = aws_api_gateway_resource.agw_oregon.id
    http_method = "GET"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "agw_integration" {
    rest_api_id = aws_api_gateway_rest_api.agw_rapi.id
    resource_id = aws_api_gateway_resource.agw_oregon.id
    http_method = aws_api_gateway_method.api_method.http_method
    integration_http_method = "ANY"
    type = "AWS_PROXY"
    uri = aws_lambda_function.simple_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "agw_deployment" {
  rest_api_id = aws_api_gateway_rest_api.agw_rapi.id
}


resource "aws_api_gateway_stage" "agw_stage" {
    rest_api_id = aws_api_gateway_rest_api.agw_rapi.id
    stage_name = "stage1"    
    deployment_id = aws_api_gateway_deployment.agw_deployment.id
}

resource "aws_api_gateway_method_settings" "agw_method_settings" {
    rest_api_id = aws_api_gateway_rest_api.agw_rapi.id
    stage_name = aws_api_gateway_stage.agw_stage.stage_name
    method_path = "path1/GET"
    settings {
      metrics_enabled = false
      logging_level = "OFF"
    }
}