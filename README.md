# Terraform vpc

##Variables

create a file with the following vars 

values.tfvars
```
vpc_cidr = "172.10.0.0/16"
prv_cidrs = ["172.10.0.0/24","172.10.1.0/24","172.10.2.0/24"]
pub_cidrs = ["172.10.3.0/24","172.10.4.0/24","172.10.5.0/24"]
```
enter the followoing commands to recreate the vpc

```bash
terraform init

terraform plan -var-file=/path/to/values.tfvars

terraform apply -var-file=/path/to/values.tfvars
```
