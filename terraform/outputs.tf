output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app.public_ip
}

output "public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.app.public_dns
}

output "frontend_url" {
  description = "Open this URL to see the frontend (allow 2-3 minutes after apply)"
  value       = "http://${aws_instance.app.public_ip}"
}
