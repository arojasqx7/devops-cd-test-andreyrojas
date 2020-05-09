output "frontend_security_group_name" {
  value = "${aws_security_group.sg_frontend.name}"
}

output "backend_security_group_name" {
  value = "${aws_security_group.sg_backend.name}"
}

output "infra_route_table_name" {
  value = "${aws_route_table.infra-route-table.id}"
}

output "infra_public_subnet_name" {
  value = "${aws_subnet.infra-subnet-1.id}"
}

output "dynamodb_table_name" {
  value = "${aws_dynamodb_table.terraform_locks.name}"
}
