#!/bin/bash

# Script to orchestrate provisioning and setup process using Terraform and Ansible

specification=$1

echo "Provisioning VMs with specification: $specification"

terraform init

terraform plan

terraform apply -auto-approve -var="specification=$specification"

echo "Running Ansible playbook for configuration management"
ansible-playbook -i inventory playbook.yml



echo "Deployment completed successfully."
