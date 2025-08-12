variable "aws_region" {
  description = "region for aws"      # 필수 아님
}

variable "iam_user_list" {
  type = list(string)
}
