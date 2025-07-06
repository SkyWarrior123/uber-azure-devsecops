# Azure DevSecOps CI/CD Pipeline Demo

This repository contains all infrastructure-as-code, scripts, and CI/CD pipeline configuration to set up a DevSecOps workflow on Azure using:

- Azure VM (Ubuntu 22.04)
- Jenkins as the CI/CD orchestrator
- SonarQube for code quality
- OWASP Dependency-Check & Trivy for security scanning
- Azure Container Registry (ACR)
- Azure Kubernetes Service (AKS)
- Terraform for infrastructure provisioning

## Prerequisites

- Azure CLI installed locally
- An Azure subscription with sufficient permissions
- SSH keypair for VM access
- Git installed locally

## Steps to Reproduce

1. **Clone the repository**
    ```bash
    git clone https://github.com/<your-username>/azure-devsecops-demo.git
    cd azure-devsecops-demo
    ```

2. **Provision the Ubuntu VM on Azure**

   1. Edit variables in scripts/setup_vm.sh (resource group, VM name, location)
   2. Make script executable: `chmod +x scripts/setup_vm.sh`
   3. Run script to provision and configure your VM: `./scripts/setup_vm.sh`

3. **SSH into the VM**

    ```bash
    ssh azureuser@$(az vm show -g rg-uber-clone -n vm-uber-clone --query publicIpAddress -o tsv)
    ```

4. Verify tool installations on VM

   1. Java: `java --version`
   2. Jenkins: `jenkins --version`
   3. Docker: `docker --version`
   4. Azure CLI: `az version` 
   5. Terraform: `terraform --version`
   6. Kubernetes Client: `kubectl version --client`

5. **Configure Jenkins**

    1. Browse to http://<VM-IP>:8080 and complete the initial setup.
    2. Install plugins: Terraform, SonarQube Scanner, NodeJS, OWASP Dependency-Check, Docker Pipeline, Kubernetes CLI.
    3. Add global tools: Java 17, NodeJS 16.x, Terraform, SonarQube Scanner.
    4. Add credentials for SonarQube token and ACR (username/password).

6. **Deploy infrastructure with Terraform**

   1. cd to `infrastructure` directory
   2. Initialize: `terraform init`
   3. Apply changes (provision storage account and AKS cluster): `terraform apply -auto-approve`

7. **Configure AKS context**

    ```bash
    az aks get-credentials --resource-group rg-uber-clone --name uberAKS
    ```

8. **Create Jenkins Pipeline**

   1. In Jenkins, create a new Pipeline job pointing to this repository's `jenkins/Jenkinsfile`.

9. **Run the Pipeline**

   1. The pipeline will perform code checkout, SonarQube analysis, OWASP Dependency-Check, Trivy scans, Docker build & push to ACR, Terraform apply, and Kubernetes deployment.

10. **Teardown Resources**

    cd into `infrastructure` directory
    Destroy infrastructure: `terraform destroy -auto-approve`

Directory Overview:

1. `infrastructure/`: Terraform code for storage account, AKS cluster
2. `jenkins/Jenkinsfile`: Declarative pipeline as code
3. `k8s/`: Kubernetes Deployment & Service manifests
4. `scripts/setup_vm.sh`: Bash script to provision and configure VM
