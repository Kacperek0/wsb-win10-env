### What's that?

Terraform IaC configuration for Windows 10 VM dev enviroment.

### How to run the script?

* Install Terraform.

* Install Azure CLI and log in.

* Clone repo and change **var.tfvars**

* Run Terraform script:

**
```bash
terraform init
```
**
```bash
terraform plan -var-file="var.tfvars" -out=plan
```
**
```bash
terraform apply "plan"
```

** Go to Azure portal, download RDP file and connect to VM.

** If you'd like to delete enviroment after you've finished using it please use:
```bash
terraform destroy -var-file="var.tfvars"
```

### Terraform providers and docs

* [Introduction to Terraform](https://www.terraform.io/intro/index.html)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* [Azure in Terraform](https://www.terraform.io/docs/providers/azurerm/index.html)
