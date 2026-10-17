# Azure blockchain provisioning experiment

Historical Terraform, Ansible and Docker experiments for provisioning an Azure VM and configuring a Geth node. This repository is an incomplete reference, not a verified validator deployment.

## Components

- `terraform/`: environment-specific VM/network configuration. Provider/resource schema issues remain to be resolved before deployment.
- `ansible/playbook.yml`: Docker/Geth setup with placeholder validator configuration.
- `gethClient/`: an older Geth image and activation experiment.
- `scripts/`: preflight and orchestration helpers.

The implementation uses Geth; it does not provide a complete Hyperledger Besu deployment, monitoring stack, key-management workflow or consensus/validator setup.

## Review and validation

Install Terraform, Ansible and the required Azure authentication tooling separately. Review all configuration and validate provider compatibility before executing provisioning commands. Supply your own Ansible inventory and replace the playbook's placeholders.

```bash
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform validate
# Only after configuration validation and review:
bash scripts/setup.sh low /absolute/path/to/inventory
```

Validation may currently fail on the historical resource schema. Do not treat the setup command as a complete quickstart. Scripts resolve paths from the repository root, check dependencies/inventory first, stop on failure and retain interactive Terraform approval.

## Planned workflow improvements

Update provider/resource configuration, replace placeholder validator steps, generate inventory from verified outputs, add offline checks and document tested teardown. No cloud deployment or blockchain-node validation is claimed by the repository cleanup.
