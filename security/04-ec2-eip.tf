# Elastic IP for our Bastion Host
resource "aws_eip" "bastion_eip" {
  instance = module.ec2_bastion.id[0]
  vpc      = true
  depends_on = [
    module.vpc,
    module.ec2_bastion
  ]

  tags = {
    Name        = "${var.environment}-bastion-eip"
    Environment = var.environment
  }
}