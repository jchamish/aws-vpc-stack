# aws-vpc-stack

Creating a VPC with two subnets public, two private internal service, two private database


### Prerequisites

- [Terraform 0.12.28](https://learn.hashicorp.com/tutorials/terraform/install-cli) - used to build the infrastructure

```bash
terraform init
terraform workspace new <workspace_name>
terraform apply -var 'profile=<profile-name>' -auto-approve
```
