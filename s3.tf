# S3 만들기
# S3 = 그냥 저장소임
# cdn이랑 잘쓰면 정적 웹 서버 ( nginx 같은 정적파일 제공 서버 ) 로 사용 가능
#
# aws s3 cp <복사할 파일 이름> s3://<S3 버킷 이름>/                 => 업로드 명령어
# aws s3 cp s3://<S3 버킷 이름>/<다운로드 할 파일 이름> <경로>      => 다운로드 명령어


provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_s3_bucket" "main" {
  bucket  = "new_s3"

  tags = {
    Name  = "new_s3"
  }
}
