resource "aws_security_group" "web_sg" {
  name        = "multi-rule-sg"
  description = "SG with multiple rules for same CIDR"

  tags = {
    Name = "multi-rule-sg"
  }
}

resource "aws_security_group_rule" "web_rules" {
  # Convert numbers → strings for for_each
  for_each = toset([for p in var.allowed_ports : tostring(p)])

  type              = "ingress"
  from_port         = tonumber(each.value)
  to_port           = tonumber(each.value)
  protocol          = "tcp"
  security_group_id = aws_security_group.web_sg.id
  cidr_blocks       = [var.cidr_block]
}
