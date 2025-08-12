# Terraform backend 사용해 보기
# S3 버킷을 생성해 tfstate 를 저장하고
# DynamoDB 를 이용해 동시 접근이 불가능 하도록 막음

provider "aws" {
  region = "ap-northeast-2"
}

# Backend 용 S3 버킷 생성
resource "aws_s3_bucket" "tfstate" {
  bucket = "hello-terraform-state"

  versioning {
    enabled = true
  }
}

# Terraform state lock을 위한 DynamoDB
resource "aws_dynamodb_table" "terraform_state_lock" {
  name = "terraform-lock"                   # 테이블 이름
  hash_key = "LockID"                       # Key 이름
  billing_mode = "PAY_PER_REQUEST"          # 과금 모드 : 요청 당 지불

  attribute {                               # 속성 정의
    name = "LockID"                         # 속성 이름
    type = "S"                              # 타입 : String
  }
}

# 위와 같은 방법으로 DynamoDB 와 S3 를 생성한 후 적용시킬 파일에 아래의 코드를 삽입해야 함
/*
terraform {
    backend "s3" {
      bucket         = "terraform-s3-bucket"                            # s3 bucket 이름
      key            = <own-your-path>/terraform.tfstate"               # s3 내에서 저장되는 경로를 의미합니다. 로컬 경로와 같은게 편함
      region         = "ap-northeast-2"  
      encrypt        = true
      dynamodb_table = "terraform-lock"
    }
}
*/

