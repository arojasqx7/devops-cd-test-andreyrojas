output "frontend_security_group_name" {
  value = "${aws_security_group.sg_frontend.name}"
}

output "frontend_instance_ips" {
  value = ["${aws_instance.swarm-infra-fe-instances.*.public_ip}"]
}

output "backend_security_group_name" {
  value = "${aws_security_group.sg_backend.name}"
}

output "backend_instance_ips" {
  value = ["${aws_instance.swarm-infra-be-instances.*.public_ip}"]
}

output "infra_route_table_name" {
  value = "${aws_route_table.infra-route-table.id}"
}

output "infra_public_subnet_name" {
  value = "${aws_subnet.infra-subnet-1.id}"
}

output "frontend_alb_target_group_name" {
  value = "${aws_alb_target_group.frontend_alb_target_group.name}"
}