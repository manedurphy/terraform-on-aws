resource "null_resource" "creation" {
  depends_on = [module.ec2_bastion]

  # Connection credentials needed to connect to bastion host
  connection {
    type        = "ssh"
    host        = aws_eip.bastion_eip.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/aws/sandbox.pem")
  }

  # Copying private key to the file system of bastion host
  provisioner "file" {
    source      = "~/.ssh/aws/sandbox.pem"
    destination = "/tmp/sandbox.pem"
  }

  # Change file permissions of private key
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/sandbox.pem"
    ]
  }

  # Run a local script when creating resources
  provisioner "local-exec" {
    command     = "echo 'Resources created at ${timestamp()}' >> resource-time-log.txt"
    working_dir = "local-exec-output"
    # on_failure  = continue
  }

}

resource "null_resource" "destroy" {
  # Run the same local script on destroy
  provisioner "local-exec" {
    command     = "echo 'Resources destroyed at ${timestamp()}' >> resource-time-log.txt"
    working_dir = "local-exec-output"
    when        = destroy
    # on_failure = continue
  }
}