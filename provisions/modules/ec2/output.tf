output "public_dns" {
  value = aws_instance.devops_eks.public_dns
 }

 output "public_ip" {
   value = aws_instance.devops_eks.public_ip
 }

 output "private_dns" {
   value = aws_instance.devops_eks.private_dns
 }