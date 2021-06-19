# Terraform-On-AWS

A series of projects for deploying infrastructure and running applications on AWS with Terraform

# Intro - Terraform Workflow

1. Init - initialize the working directory and download providers
2. Validate - validates the syntax and consistency of the config files
3. Plan - creates and presents and execution plan for creating resources
4. Apply - creates the resources
5. Destroy - destroys the resources

```bash
terraform init
terraform validate
terraform plan
terraform apply --auto-approve
terraform destroy --auto-approve
```

## Language Basics & Configuration Syntax

### Top Level Blocks

```terraform
# Block-1: Terraform Settings Block
terraform {
  required_version = "~> 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

# Adding Backend as S3 for Remote State Storage with State Locking
  backend "s3" {
    bucket = "terraform-stacksimplify"
    key    = "dev2/terraform.tfstate"
    region = "us-east-1"

    # For State Locking
    dynamodb_table = "terraform-dev-state-table"
  }
}


# Block-2: Provider Block
provider "aws" {
  profile = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
  region  = "us-east-1"
}

#####################################################################
# Block-3: Resource Block
resource "aws_instance" "ec2demo" {
  ami           = "ami-04d29b6f966df1537" # Amazon Linux
  instance_type = var.instance_type
}
#####################################################################
# Block-4: Input Variables Block
variable "instance_type" {
  default = "t2.micro"
  description = "EC2 Instance Type"
  type = string
}
#####################################################################
# Block-5: Output Values Block
output "ec2_instance_publicip" {
  description = "EC2 Instance Public IP"
  value = aws_instance.my-ec2-vm.public_ip
}
#####################################################################
# Block-6: Local Values Block
# Create S3 Bucket - with Input Variables & Local Values
locals {
  bucket-name-prefix = "${var.app_name}-${var.environment_name}"
}
#####################################################################
# Block-7: Data sources Block
# Get latest AMI ID for Amazon Linux2 OS
data "aws_ami" "amzlinux" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}
#####################################################################
# Block-8: Modules Block
# AWS EC2 Instance Module

module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "my-modules-demo"
  instance_count         = 2

  ami                    = data.aws_ami.amzlinux.id
  instance_type          = "t2.micro"
  key_name               = "terraform-key"
  monitoring             = true
  vpc_security_group_ids = ["sg-08b25c5a5bf489ffa"]  # Get Default VPC Security Group ID and replace
  subnet_id              = "subnet-4ee95470" # Get one public subnet id from default vpc and replace
  user_data               = file("apache-install.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
#####################################################################
```

1. Fundamental Blocks - Terraform, Provider, Resources
2. Variables Blocks - Input, Output, Local values
3. Referencing Blocks - Data Sources, Modules

# Blocks

## Fundamental/Basic Blocks

1. Terraform Block
    - Required Terraform version
    - List of required providers
    - Terraform backend for remote storage of state
    - NOTE: The Terraform block can NOT reference variables or named objects, its values must be hard-coded

```terraform
terraform {
  required_version = ">= 0.14" # At least version 0.14
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.46.0"
    }
  }

  backend "s3" {
      bucket = "backend-bucket"
      key = "path/to/key"
      region = "us-east-1"
  }
}

```

2. Provider Block
    - The "heart" of Terraform -> determines the Cloud providers of choice
    - Provider configuration belongs to root module
    - On `terraform init`, the Terraform CLI will acquire the provider from the Terraform public registry
    - The Provider simply communicates with the APIs of its respected Cloud provider
    - Each Provider is distributed independently from Terraform, with its own versions and release cycles

```terraform
provider "aws" {
  region = "us-east-1"
  profile = "developer"
}
```

```txt
[developer]
aws_access_key_id = Axxxx
aws_secret_access_key = Uxxxxx
```

3. Resouce Block
    - Defines the infrastructure objects that will provision resources on the Cloud provider
    - Resource behavior
        - Create resources that exist in the configuration and are not associated with the current state
        - Destroy resources that exists in state but not in configuration
        - Update-in-place resources whose aruments have changed -> adding a tag
        - Destroy and re-create resources whose arguments have changed but cannot be updated in place -> t2.micro to t3.small
    - Argument references are the arguments whose values we input into the block
    - Attribute refernces are outputs once resources are provisioned and can be referenced in other blocks

```
<BLOCK TYPE> "<RESOURCE TYPE>" "<RESOURCE LOCAL NAME>" {
    <IDENTIFIER> = <EXPRESSION>
}
```

```terraform
resource "aws_instance" "my_ec2" {
    provider = aws.aws-west-1 # This is a meta-argument, it changes the behavior of resources
    ami = "ami-0742b4e673072066f" # These are regular Resource Arguments
    instance_type = "t3.small"
}
```

### Terraform State Basics

-   Terraform state changes based on the resource behaviors described above
-   It is simply a database for actions to be performed
-   `terraform.tfstate` is created when using a local backend -> it references the default workspace
-   We can configure an S3 bucket as our backend to store and share a common `terraform.tfstate` file for a team
-   In summary, the system is just a diff between desired state and current state. If they are equal, no changes are made.

## Variables

1. Input variables
    - Serve as parameters for a Terraform module
    - Allows us to configure the module once, and change that value of variables in one place
    - Allows modules to be shared with different configurations
2. Output variables
    - Output values are like return values of a function, and Terraform has several uses for them
    - A root module can use outputs to print output values to the console after running `terraform apply`
    - A child module can use outputs to expose a subset of its resource attributes to the parent module
      When using remote state, the root module outputs can be accessed by other configurations via a `terraform_remote_state data source`
3. Datasources
    - Datasources allow data to fetched or computed for use elsewhere is Terraform configuration
    - We used filters to acquire the AMI we wanted, and used the id of that datasource when creating our EC2 instance
    - We can also use the datasource from another Terraform project

# Loops, MetaArgumnets, Splat Operator & Functions
