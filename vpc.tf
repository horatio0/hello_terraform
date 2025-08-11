# provider 설정
provider "aws" {
 region = "ap-northeast-2"		# 서울
}

# vpc 생성
resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"		# vpc가 가지는 ip 범위
 
 tags = {
  Name = "hello-terraform"
 }
}

# 퍼블릭 서브넷 생성
resource "aws_subnet" "public_subnet" {
 vpc_id = aws_vpc.main.id
 cidr_block = "10.0.0.0/24"

 tags = {
  Name = "public"
 } 
}

# 프라이빗 서브넷 생성
resource "aws_subnet" "private_subnet" {
 vpc_id = aws_vpc.main.id
 cidr_block = "10.0.1.0/24"

 tags = {
  Name = "private"
 }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id

 tags = {
  Name = "hello-igw"
 }
}

# 라우팅 테이블 생성
resource "aws_route_table" "public" {
 vpc_id = aws_vpc.main.id

 route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
 }

 tags = {
  Name = "route_table_for_public"
 }
}

resource "aws_route_table" "private" {
 vpc_id = aws_vpc.main.id

 tags = {
  Name = "route_table_for_private"
 }
}

# 라우팅 테이블 연결
resource "aws_route_table_association" "association_public" {
 subnet_id = aws_subnet.public_subnet.id
 route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "association_private" {
 subnet_id = aws_subnet.private_subnet.id
 route_table_id = aws_route_table.private.id
}

/*					# nat_gateway, EIP는 비용을 지불해야 함 => 주석 처리
# nat gateway 생성
resource "aws_nat_gateway" "nat_gateway" {
 allocation_id = aws_eip.nat.id

 subnet_id = aws_subnet.public_subnet.id

 tags = {
  Name = "nat-gateway"
 }
}

# 탄력적 ip 발급
resource "aws_eip" "nat" {		# 탄력적 ip 발급(nat gateway용)
 domain = "vpc"				# 이 탄력적 ip 는 vpc 용으로 사용될 것
 lifecycle{				# 만일 지우고 다시 만들어야 할 경우 만드는 거 먼저. ( 서비스가 중단될 가능성이 높음 )
  create_before_destroy = true
 }
}

# 프라이빗 서브넷에 연결된 라우팅 테이블에 nat gateway 연결
resource "aws_route" "private_nat" {
 route_table_id		= aws_route_table.private.id
 destination_cidr_block	= "0.0.0.0/0"
 nat_gateway_id		= aws_nat_gateway.nat_gateway.id
}
*/
