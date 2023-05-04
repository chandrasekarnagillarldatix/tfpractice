resource "aws_lambda_function" "simple_lambda" {
    function_name = "Oregon_Lambda"  
    role = aws_iam_role.iam_for_lambda.arn
    filename      = "lambda_function_payload.zip"
    handler       = "index.test"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs16.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}


data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda.js"
  output_path = "lambda_function_payload.zip"
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}