provider "aws" {
  version    = "~> 2.61"
  region     = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
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

resource "aws_subnet" "lb-subnet-1" {
  cidr_block        = "10.10.10.0/24"
  vpc_id            = "${var.vpc_jenkins}"
  availability_zone = "${var.region}b"

  tags = {
    Name = "LB-Public-Subnet-1"
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

resource "aws_alb_target_group" "frontend_alb_target_group" {  
  name     = "${var.fe_target_group_name}"  
  port     = "80"  
  protocol = "${var.load_balancer_protocol}"  
  vpc_id   = "${var.vpc_jenkins}"  

  health_check {    
    healthy_threshold   = 5    
    unhealthy_threshold = 3    
    timeout             = 5    
    interval            = 20    
    path                = "/"    
    port                = "80"  
  }
}

resource "aws_lb_target_group_attachment" "frontend_target_group_attachments" {
  count            = "3" 
  target_group_arn = "${aws_alb_target_group.frontend_alb_target_group.arn}"
  target_id        = "${lookup(var.fe_instance_ids, count.index)}" 
  port             = 80
}

resource "aws_alb" "frontend_alb" {
  name               = "${var.fe_alb_name}"  
  subnets            = ["${aws_subnet.public.*.id}"]
  security_groups    = ["${aws_security_group.sg_load_balancers.id}"]
  load_balancer_type = "${var.load_balancer_type}"
  internal           = false  
  idle_timeout       = "60"  
  ip_address_type    = "${var.ip_address_type}"  
}

resource "aws_alb_listener" "frontend_alb_listener" {  
  load_balancer_arn = "${aws_alb.frontend_alb.arn}"  
  port              = "80"  
  protocol          = "${var.load_balancer_protocol}" 
  
  default_action {    
    target_group_arn = "${aws_alb_target_group.frontend_alb_target_group.arn}"
    type             = "forward"  
  }
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

resource "aws_security_group" "sg_load_balancers" {
  name        = "load_balancer_rules"
  description = "Allow HTTP "
  vpc_id      = "${var.vpc_jenkins}"

  ingress {
    from_port   = 80
    to_port     = 80
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