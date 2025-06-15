# Mencom Azure IAC

Mencom Informatics Azure IAC (Infrastructure as Code) Project

### Run Terraform Locally (Run from the infrastructure module folder)

```

For Applying

terraform init -backend-config=environment/dev/dev.tfbackend
terraform plan -var-file=environment/dev/dev.tfvars -input=false
terraform apply -auto-approve -var-file=environment/dev/dev.tfvars -input=false

For destroying

terraform apply -destroy -auto-approve -var-file=environment/dev/dev.tfvars -input=false

```

### Run workflow with github cli: plan-and-apply.yml

```
gh workflow run plan-and-apply.yml --ref main --field module=monitor --field environment=dev
gh workflow run plan-and-apply.yml --ref main --field module=network --field environment=dev
gh workflow run plan-and-apply.yml --ref main --field module=vault --field environment=dev
```

### Run workflow with github cli: plan-and-destroy.yml

```
gh workflow run plan-and-destroy.yml --ref main --field module=monitor --field environment=dev
gh workflow run plan-and-destroy.yml --ref main --field module=network --field environment=dev
gh workflow run plan-and-destroy.yml --ref main --field module=vault --field environment=dev
```

### List Workflow with Github CLI

```
gh run list --workflow=plan-and-destroy.yml
gh run show <run-id>
```