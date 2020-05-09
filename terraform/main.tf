provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "swarm-infra-fe-instances" {
  ami                    = "ami-0323c3dd2da7fb37d"
  instance_type          = "t2.medium"
  key_name               = "${var.keyname}"
  vpc_security_group_ids = ["${aws_security_group.sg_frontend.id}"]
  subnet_id              = "${aws_subnet.infra-subnet-1.id}"
  count                  = "3"  

  associate_public_ip_address = true
  tags = {
      Name = "${lookup(var.fe_instance_names, count.index)}"
  }
}

resource "aws_instance" "swarm-infra-be-instances" {
  ami                    = "ami-0323c3dd2da7fb37d"
  instance_type          = "t2.medium"
  key_name               = "${var.keyname}"
  vpc_security_group_ids = ["${aws_security_group.sg_backend.id}"]
  subnet_id              = "${aws_subnet.infra-subnet-1.id}"
  count                  = "3"  

  associate_public_ip_address = true
  tags = {
      Name = "${lookup(var.be_instance_names, count.index)}"
  }
}

resource "aws_subnet" "infra-subnet-1" {
  cidr_block        = "10.10.1.0/24"
  vpc_id            = "${var.vpc_jenkins}"
  availability_zone = "${var.region}a"

  tags = {
    Name = "Infra-Public-Subnet-1"
  }
}

resource "aws_route_table" "infra-route-table" {
  vpc_id = "${var.vpc_jenkins}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.vpc_gateway_id}"
  }

  tags = {
    Name = "Infra-Route-Table"
  }
}

resource "aws_route_table_association" "infra-subnet-rt-associate" {
  subnet_id      = "${aws_subnet.infra-subnet-1.id}"
  route_table_id = "${aws_route_table.infra-route-table.id}"
}

resource "aws_security_group" "sg_frontend" {
  name        = "frontend_rules"
  description = "Allow SSH and Angular inbound traffic"
  vpc_id      = "${var.vpc_jenkins}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4200
    to_port     = 4200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }   
}

resource "aws_security_group" "sg_backend" {
  name        = "backend_rules"
  description = "Allow SSH and Spring Boot inbound traffic"
  vpc_id      = "${var.vpc_jenkins}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }   
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-infra"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks-infra"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
