module "ec2_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name          = "${var.environment}-bastion-host"
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.instance_keypair

  vpc_security_group_ids = [module.bastion_host_sg.security_group_id]
  subnet_ids             = module.vpc.public_subnets

  tags = {
    Environment = var.environment
    Type        = "Public"
  }
}

module "ec2_private" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "${var.environment}-private"
  instance_count = var.private_instance_count

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.instance_keypair
  user_data     = file("${path.module}/app1-install.sh")

  vpc_security_group_ids = [module.private_sg.security_group_id]
  subnet_ids             = module.vpc.private_subnets

  depends_on = [module.vpc]
  tags = {
    Environment = var.environment
    Type        = "Private"
  }
}