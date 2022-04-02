output "aws_security_group_Kubernetes_server_details" {
  value = aws_security_group.cluster_sg_group_traffic
}

output "k8s_master_ip_addr" {
  value = aws_instance.k8s_master[0].public_ip
}

output "k8s_slave1_ip_addr" {
  value = aws_instance.k8s_slave[0].public_ip
}

output "k8s_slave2_ip_addr" {
  value = aws_instance.k8s_slave[1].public_ip
}

