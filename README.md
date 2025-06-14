# mencom-azr-iac

Mencom Informatics Azure IAC (Infrastructure as Code) Project

Run workflow with github cli

```
gh workflow run plan-and-apply.yml --ref main --field module=monitor --field environment=dev

gh workflow run plan-and-apply.yml --ref main --field module=network --field environment=dev

gh workflow run plan-and-apply.yml --ref main --field module=vault --field environment=dev
```
