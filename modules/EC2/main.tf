resource "aws_launch_template" "main" {
  name_prefix   = "${var.project_name}-template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = var.assign_public_ip
    security_groups             = var.security_group_ids
    delete_on_termination       = true
    ipv6_address_count          = var.enable_ipv6 ? 1 : 0
  }

  user_data = base64encode(var.user_data)

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = merge(
    {
      Name = "${var.project_name}-launch-template"
    },
    var.tags
  )
}
