# GitHub Actions Setup Guide

## Overview

This repository contains two GitHub Actions workflows:

1. **CI/CD Pipeline** (`ci-cd.yml`) - Full deployment pipeline for main branch
2. **Development CI** (`dev-ci.yml`) - Testing and validation for feature branches

## Required Secrets

You need to configure these secrets in your GitHub repository:

### 🔐 Setting up GitHub Secrets

1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each of the following secrets:

### Required Secrets List

```bash
# Security Scanning
SNYK_TOKEN                    # Snyk API token for security scanning

# Azure Authentication
AZURE_CLIENT_ID              # Azure Service Principal Client ID
AZURE_CLIENT_SECRET          # Azure Service Principal Client Secret
AZURE_TENANT_ID              # Azure Tenant ID
AZURE_SUBSCRIPTION_ID        # Azure Subscription ID

# Container Registry
REGISTRY_LOGIN_SERVER        # Azure Container Registry server (e.g., myregistry.azurecr.io)
REGISTRY_USERNAME            # ACR username
REGISTRY_PASSWORD            # ACR password

# Kubernetes
AKS_CLUSTER_NAME            # Azure Kubernetes Service cluster name
AKS_RESOURCE_GROUP          # Azure resource group containing AKS
```

## Workflow Details

### 1. CI/CD Pipeline (ci-cd.yml)

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main`

**Jobs:**
1. **Build and Test**
   - Python 3.9 setup
   - Install dependencies
   - Snyk security scan
   - Run tests with coverage
   - Run linting
   - Upload test artifacts

2. **Build and Push Docker**
   - Build Docker image
   - Push to Azure Container Registry
   - Tag with branch and SHA

3. **Deploy to AKS** (only on main branch)
   - Azure login
   - Get AKS credentials
   - Create namespace and secrets
   - Deploy to Kubernetes
   - Run post-deployment tests

### 2. Development CI (dev-ci.yml)

**Triggers:**
- Push to `develop` or `feature/*` branches
- Pull requests to `develop`

**Jobs:**
1. **Build and Test**
   - Same as CI/CD pipeline
   - Adds PR commenting with test results

2. **Build Docker Dev** (only on push)
   - Build and push development images
   - Run Trivy security scan on image

## Branch Strategy

```
main ────────────────────────────────── Production deployments
 ↑
develop ─────────────────────────────── Development testing
 ↑
feature/feature-name ──────────────────── Feature development
```

## Image Tagging Strategy

- **Main branch**: `latest`, `main-{sha}`
- **Develop branch**: `develop-{sha}`
- **Feature branches**: `{branch-name}-{sha}`, `dev-{sha}`

## Deployment Process

### Automatic Deployment (Main Branch)
1. Code pushed to `main`
2. Tests run automatically
3. Docker image built and pushed
4. Deployed to AKS production namespace

### Manual Deployment (Other Branches)
1. Code pushed to `develop` or feature branch
2. Tests run automatically
3. Docker image built and tagged for development
4. No automatic deployment (manual deployment possible)

## Security Features

- **Snyk vulnerability scanning** for dependencies
- **Trivy container scanning** for Docker images
- **Secret masking** in logs
- **Least privilege** Azure service principal
- **Network policies** in Kubernetes

## Monitoring and Notifications

- **Test results** uploaded as artifacts
- **Coverage reports** available in artifacts
- **PR comments** with test results
- **Deployment status** visible in Actions tab

## Local Development

```bash
# Run tests locally
make test

# Build Docker image locally
make docker-build

# Run linting
make lint

# Run security scan (requires SNYK_TOKEN)
snyk test
```

## Troubleshooting

### Common Issues

1. **"Secret not found"**
   - Ensure all secrets are configured in GitHub repository settings
   - Check secret names match exactly

2. **"Authentication failed"**
   - Verify Azure service principal credentials
   - Check service principal has correct permissions

3. **"Image pull failed"**
   - Verify ACR credentials are correct
   - Ensure ACR admin user is enabled

4. **"Deployment failed"**
   - Check AKS cluster name and resource group
   - Verify service principal has AKS permissions

### Debug Steps

1. Check the Actions tab for detailed logs
2. Secrets are masked in logs for security
3. Use `kubectl` commands in the workflow for debugging
4. Check Azure portal for resource status

## Manual Deployment Commands

If you need to deploy manually:

```bash
# Set environment variables
export REGISTRY_LOGIN_SERVER="your-registry.azurecr.io"
export IMAGE_TAG="main-$(git rev-parse --short HEAD)"

# Build and push
docker build -t $REGISTRY_LOGIN_SERVER/python-flask-app:$IMAGE_TAG .
docker push $REGISTRY_LOGIN_SERVER/python-flask-app:$IMAGE_TAG

# Deploy to AKS
az aks get-credentials --resource-group $AKS_RESOURCE_GROUP --name $AKS_CLUSTER_NAME
kubectl apply -f k8s/
```

## Performance Optimization

- **Docker layer caching** enabled
- **Pip dependency caching** for faster builds
- **Parallel job execution** where possible
- **Conditional deployments** (only on main branch)

## Security Best Practices

1. **Never commit secrets** to the repository
2. **Use dedicated service principals** for CI/CD
3. **Rotate secrets regularly** (every 90 days)
4. **Monitor workflow runs** for suspicious activity
5. **Use branch protection rules** for main branch
