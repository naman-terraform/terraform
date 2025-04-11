# modules/ASG/main.tf

resource "aws_autoscaling_group" "main" {
  name                      = "${var.project_name}-asg"
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  target_group_arns         = var.target_group_arns
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = merge(
      {
        Name = "${var.project_name}-asg"
      },
      var.tags
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.project_name}-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.scale_up_cooldown
  autoscaling_group_name = aws_autoscaling_group.main.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.project_name}-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.scale_down_cooldown
  autoscaling_group_name = aws_autoscaling_group.main.name
}
