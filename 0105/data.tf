data "aws_iam_policy_document" "policydoc" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["execute-api:Invoke"]
    resources = [aws_api_gateway_rest_api.agw_rapi.execution_arn]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["123.123.123.123/32"]
    }
  }
}