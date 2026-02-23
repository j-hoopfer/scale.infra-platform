# ── Security Group ─────────────────────────────────────────────────────────────
resource "aws_security_group" "alb_internal" {
  name        = "alb-internal-sg"
  description = "Allow 80/443 from VPC"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr_block]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ── Load Balancer ──────────────────────────────────────────────────────────────
resource "aws_lb" "internal" {
  name               = "shared-internal-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = data.terraform_remote_state.network.outputs.private_subnet_ids
  security_groups    = [aws_security_group.alb_internal.id]
}

# ── Listener ───────────────────────────────────────────────────────────────────
# Default action returns 404. Service stacks attach weighted routing rules here
# to enable Strangler Fig traffic shifting between EC2 and Fargate.
resource "aws_lb_listener" "internal_http" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}
