#!/usr/bin/env bash
set -euo pipefail
repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
specification=${1:-low}
inventory=${2:-}
case "$specification" in low|medium|high) ;; *) echo 'Specification must be low, medium or high.' >&2; exit 2;; esac
if [[ -z "$inventory" || ! -f "$inventory" ]]; then
  echo 'Usage: bash scripts/setup.sh [low|medium|high] /path/to/ansible-inventory' >&2
  exit 2
fi
inventory=$(cd "$(dirname "$inventory")" && pwd)/$(basename "$inventory")
command -v terraform >/dev/null
command -v ansible-playbook >/dev/null
terraform -chdir="$repo_dir/terraform" init
terraform -chdir="$repo_dir/terraform" validate
terraform -chdir="$repo_dir/terraform" apply -var="specification=$specification"
ANSIBLE_CONFIG="$repo_dir/ansible/ansible.cfg" ansible-playbook -i "$inventory" "$repo_dir/ansible/playbook.yml"
echo 'Provisioning and configuration commands completed.'
