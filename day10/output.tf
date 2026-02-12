#output variables
# output "vpc_id" {
#   value = aws_vpc.myvpc.id
# }
# output "instance_ip" {
#   value = aws_instance.myinstance.public_ip
# }


output "ip" {
  value = local.all_instances_publicIP
}