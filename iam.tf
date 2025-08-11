provider "aws" {
  region = "ap-northeast-2"                         # 사실 IAM 은 리전이 상관없음. 
}

resource "aws_iam_user" "horatio" {                 # IAM 유저 생성
  name = "horatio"
}

resource "aws_iam_group" "devops" {                 # IAM 그룹 생성
  name = "devops"
}

resource "aws_iam_group_membership" "devops" {      # 그룹에 유저 추가
  name = aws_iam_group.devops.name

  users = [
    aws_iam_user.horatio.name
  ]

  group = aws_iam_group.devops.name
}

resource "aws_iam_user_policy" "devops" {           # 유저에 권한 추가. ( 그룹에 추가시 group_policy )
  name = "super_admin"
  user = aws_iam_user.horatio.name

  policy = <<EOF
  {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "*"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  }
  EOF
}


resource "aws_iam_role" "hello" {                   # 권한을 추가해
  name               = "hello-iam-role"
  path               = "/"                          # assume_role_policy : 누가 이 역할을 가질 수 있는지 정의 [Principal 이 Action 하는 것을 Effect 함].
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "hello_s3" {         # 실제 권한 
  name   = "hello-s3-download"
  role   = aws_iam_role.hello.id
  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "AllowAppArtifactsReadAccess",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "*"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF

}


resource "aws_iam_instance_profile" "hello" {               # EC2 는 직접 역할을 부여받을 수 없고 "인스턴스 프로파일"을 통해 부여받음
  name = "hello-profile"
  role = aws_iam_role.hello.name
}
