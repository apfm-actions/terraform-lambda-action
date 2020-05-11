output "lambda_name" {
  description = "Name of the created function"
  value = "${aws_lambda_function.function.function_name}"
}

output "lambda_arn" {
  description = "ARN of the created function"
  value = "${aws_lambda_function.function.arn}"
}

output "lambda_invoke_arn" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri"
  value = "${aws_lambda_function.function.invoke_arn}"
}

output "lambda_role" {
  description = " IAM role attached to the Lambda Function"
  value = "${aws_iam_role.lambda_role.id}"
}
