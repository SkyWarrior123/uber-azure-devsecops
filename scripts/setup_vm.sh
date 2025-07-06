#!/usr/bin/env bash
set -euo pipefail

# Variables
RG_NAME="rg-uber-clone"
LOCATION="westeurope"
VM_NAME="vm-uber-clone"
ADMIN_USER="azureuser"
SSH_KEY_PATH="$HOME/.ssh/id_rsa.pub"

# Create resource group
az group create -n "$RG_NAME" -l "$LOCATION"

# Create VM
az vm create \
  -g "$RG_NAME" -n "$VM_NAME" \
  --image UbuntuLTS --size Standard_B2ms \
  --admin-username "$ADMIN_USER" \
  --ssh-key-values "$SSH_KEY_PATH" \
  --authentication-type ssh

# Open ports
az vm open-port -g "$RG_NAME" -n "$VM_NAME" --port 22
az vm open-port -g "$RG_NAME" -n "$VM_NAME" --port 80
az vm open-port -g "$RG_NAME" -n "$VM_NAME" --port 443
az vm open-port -g "$RG_NAME" -n "$VM_NAME" --port 8080
az vm open-port -g "$RG_NAME" -n "$VM_NAME" --port 9000

# Assign managed identity
az vm identity assign -g "$RG_NAME" -n "$VM_NAME"
az role assignment create --role Contributor --assignee \
  $(az vm identity show -g "$RG_NAME" -n "$VM_NAME" --query principalId -o tsv) \
  --scope $(az group show -n "$RG_NAME" --query id -o tsv)

# Install dependencies and tools (run on VM via SSH)
cat << 'EOF' > install_tools.sh
#!/bin/bash
sudo su
apt update -y && apt install -y wget curl apt-transport-https gnupg lsb-release unzip

# Java 17
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc
... (rest as above)
EOF

echo "VM provisioned. Run 'ssh ${ADMIN_USER}@$(az vm show -g $RG_NAME -n $VM_NAME --query publicIpAddress -o tsv)' and execute 'bash install_tools.sh'"