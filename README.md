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