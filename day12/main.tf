locals {
  formatted_project_name = lower(var.project_name)
  formatted_bucket_name = substr(lower(var.bucket_name),0,63)
  port_list = split(",",var.allowed_ports)
  sg_rules =  [
    for port in local.port_list:
    {
      name =  "port-${port}"
      port = port
      description = "allow ports ${port}"

    }
  ] 
  instance_size = lookup(var.instance_sizes,var.env,"t2.medium")
  all_locations = concat(var.user_location,var.default_location)
  unique_locations = toset(local.all_locations)

  positive_cost = sum([
    for num in var.monthly_costs : num
    if num > 0
  ])

  max_cost= max(var.monthly_costs...)
  current_timestamp = timestamp()
  format1 = formatdate("dd-MMM-yyyy",local.current_timestamp)
}




resource "aws_s3_bucket" "example" {
  bucket = local.formatted_bucket_name

  tags = merge(var.default_tags,var.main_tag)
}