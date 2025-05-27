output "public_dns" {
  value = aws_instance.devops_eks_2.public_dns
 }

 output "public_ip" {
   value = aws_instance.devops_eks_2.public_ip
 }

 output "private_dns" {
   value = aws_instance.devops_eks_2.private_dns
 }