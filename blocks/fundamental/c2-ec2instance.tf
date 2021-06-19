# Resource: EC2 Instance
resource "aws_instance" "myec2vm" {
  ami           = "ami-0aeeebd8d2ab47354"
  instance_type = "t3.small"
  user_data     = file("${path.module}/app1-install.sh")
  tags = {
    "Name" = "EC2 Demo"
  }
}
