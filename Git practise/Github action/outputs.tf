output "instance_id" {
  description = "ID of the practice EC2 instance"
  value       = aws_instance.web.id
}

output "website_url" {
  description = "Public URL of the practice web page"
  value       = "http://${aws_instance.web.public_ip}"
}
