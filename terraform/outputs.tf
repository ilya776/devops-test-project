output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of EC2 instance"
}

output "load_balancer_dns" {
  value       = aws_lb.web_lb.dns_name
  description = "DNS name of the load balancer"
}

output "load_balancer_zone_id" {
  value       = aws_lb.web_lb.zone_id
  description = "Zone ID of the load balancer"
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC"
}

output "subnet_ids" {
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  description = "IDs of the public subnets"
}