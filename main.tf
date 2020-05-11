resource "aws_lambda_function" "function" {
  function_name    = "${var.function_name}"
  filename         = "${var.zip_payload}"
  source_code_hash = "${base64sha256(file(var.zip_payload))}"
  handler          = "${var.handler}"
  runtime          = "${var.runtime}"
  role             = "${aws_iam_role.lambda_role.id}"
  timeout          = "${var.lambda_timeout}"

  vpc_config {
    subnet_ids         = ["${local.subnet_ids}"]
    security_group_ids = ["${local.security_group_ids}"]
  }

  environment {
    variables = "${local.environment_variables}"
  }
}

# A role is required for functions. This will effectively give the function
# empty permissions, and is used by default if no role is passed to the module.
resource "aws_iam_role" "lambda_role" {
  name = "${var.function_name}-default-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attatchments" {
  for_each   = local.policy_arns
  role       = "${aws_iam_role.lambda_role.id}"
  policy_arn = each.value
}


resource "aws_cloudwatch_event_target" "cw_target" {
  count     = "${var.enable_cloudwatch_event_trigger ? 1 : 0}"
  target_id = "${aws_lambda_function.function.function_name}"
  arn       = "${aws_lambda_function.function.arn}"
  rule      = "${var.cloudwatch_event_name}"
}
resource "aws_lambda_permission" "cw_permission" {
  count         = "${var.enable_cloudwatch_event_trigger ? 1 : 0}"
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.function.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${var.cloudwatch_event_arn}"
}
