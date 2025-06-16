output "load_balancer_dns" {
  value       = aws_lb.web_lb.dns_name
  description = "DNS of the Load Balancer"
}

output "instance_public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of the EC2 instance"
}