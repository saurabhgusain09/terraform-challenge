output "project" {
  value = local.formatted_project_name
}

output "all_ports" {
  value = local.sg_rules
}

output "type_of_instance" {
  value = local.instance_size
}