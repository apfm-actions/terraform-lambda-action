locals {
  environment_variables = "${jsondecode(var.environment_variables)}"

  policy_arns = "${"arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", concat(split(",", var.policy_arns)}"

  subnet_ids = "${split(",", var.subnet_ids)}"

  security_group_ids = "${split(",", var.security_group_ids)}"
}
