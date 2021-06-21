module "elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 3.0.0"

  name = "my-${var.environment}-elb"

  subnets         = module.vpc.public_subnets
  security_groups = [module.loadbalancer_sg.security_group_id]
  internal        = false

  listener = [
    {
      instance_port     = 80
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    },
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  number_of_instances = var.private_instance_count
  instances           = module.ec2_private.id

  tags = {
    Environment = var.environment
  }
}
