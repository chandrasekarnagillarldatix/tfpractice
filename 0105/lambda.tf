resource "aws_lambda_function" "simple_lambda" {
    function_name = "Mongo_Lambda"  
    role = aws_iam_role.iam_for_lambda.arn
    filename      = "lambda_function_payload.zip"
    handler       = "lambda.run"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs16.x"
  timeout = 15

  environment {
    variables = {
      foo = "bar"
    }
  }
}


data "archive_file" "lambda" {
  type        = "zip"
  output_path = "lambda_function_payload.zip"
  //source_file = "lambda.js"
  //source_dir = "./node_modules/"

  source {
    content = data.template_file.mainjs.rendered
    filename = "lambda.js"
  }
  source {
    content = data.template_file.package.rendered
    filename = "package.json"
  }
  #   source {
  #   //content = data.template_file.nodemodules.rendered
  #   content = "${file(base64encode("node_modules.zip"))}".filesha256
  #   filename = "node_modules.zip"
  # }
  # depends_on = [ data.archive_file.nodemodules ]
}

data "template_file" "mainjs" {
  template = "${file("lambda.js")}"
}
data "template_file" "package" {
  template = "${file("package.json")}"
}



# data "template_file" "nodemodules" {
#   template = "${filebase64("node_modules.zip")}"
#   //template = data.archive_file.nodemodules.output_path
#   depends_on = [ 
#     data.archive_file.nodemodules
#     ]
# }

# data "archive_file" "nodemodules" {
#   type = "zip"
#   source_dir = "./node_modules/"
#   output_path = "node_modules.zip"
# }

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