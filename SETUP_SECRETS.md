# 🔐 GitHub Secrets Setup Guide

## ❌ Current Error

You're getting this error because the required secrets are not configured in your GitHub repository:

```
Error: Username and password required
```

## 🚀 **IMMEDIATE ACTION REQUIRED**

### **Step 1: Go to GitHub Repository Settings**

1. Navigate to: https://github.com/Ananyakg1/Azure_Devops_Existing
2. Click **Settings** tab
3. Click **Secrets and variables** → **Actions**
4. Click **New repository secret**

### **Step 2: Add Required Secrets**

Add these secrets one by one:

#### **🔑 Container Registry Secrets**
```
Secret Name: REGISTRY_LOGIN_SERVER
Secret Value: your-registry.azurecr.io
Description: Azure Container Registry server URL
```

```
Secret Name: REGISTRY_USERNAME
Secret Value: your-registry-username
Description: Azure Container Registry username
```

```
Secret Name: REGISTRY_PASSWORD
Secret Value: your-registry-password
Description: Azure Container Registry password
```

#### **🔑 Azure Authentication Secrets**
```
Secret Name: AZURE_CLIENT_ID
Secret Value: your-service-principal-client-id
Description: Azure Service Principal Application ID
```

```
Secret Name: AZURE_CLIENT_SECRET
Secret Value: your-service-principal-client-secret
Description: Azure Service Principal Password
```

```
Secret Name: AZURE_TENANT_ID
Secret Value: your-azure-tenant-id
Description: Azure Active Directory Tenant ID
```

```
Secret Name: AZURE_SUBSCRIPTION_ID
Secret Value: your-azure-subscription-id
Description: Azure Subscription ID
```

#### **🔑 Kubernetes Secrets**
```
Secret Name: AKS_CLUSTER_NAME
Secret Value: your-aks-cluster-name
Description: Azure Kubernetes Service cluster name
```

```
Secret Name: AKS_RESOURCE_GROUP
Secret Value: your-resource-group-name
Description: Azure Resource Group containing AKS
```

#### **🔑 Security Scanning Secret**
```
Secret Name: SNYK_TOKEN
Secret Value: your-snyk-api-token
Description: Snyk API token for security scanning
```

## 🏗️ **How to Get These Values**

### **Azure Container Registry (ACR)**
1. Go to Azure Portal → Container Registries
2. Select your registry
3. Go to **Access keys**
4. Enable **Admin user**
5. Copy:
   - **Login server** → `REGISTRY_LOGIN_SERVER`
   - **Username** → `REGISTRY_USERNAME`
   - **Password** → `REGISTRY_PASSWORD`

### **Azure Service Principal**
Run these commands in Azure CLI:

```bash
# Create service principal
az ad sp create-for-rbac --name "github-actions-sp" --role contributor --scopes /subscriptions/YOUR_SUBSCRIPTION_ID

# Output will give you:
# appId → AZURE_CLIENT_ID
# password → AZURE_CLIENT_SECRET
# tenant → AZURE_TENANT_ID
```

### **Azure Subscription ID**
```bash
az account show --query id --output tsv
```

### **AKS Details**
```bash
# List AKS clusters
az aks list --query "[].{Name:name, ResourceGroup:resourceGroup}" --output table
```

### **Snyk Token**
1. Go to https://snyk.io
2. Sign up/Login
3. Go to Account Settings → API Token
4. Generate and copy the token

## ✅ **Verification Steps**

After adding all secrets:

1. **Check secrets are added**:
   - Go to your repo → Settings → Secrets and variables → Actions
   - You should see all 10 secrets listed

2. **Test the pipeline**:
   - Make a small change to your code
   - Push to main branch
   - Check the Actions tab

3. **Expected behavior**:
   - ✅ Build and test will pass
   - ✅ Docker build and push will succeed
   - ✅ Deployment to AKS will work

## 🔧 **Quick Test**

To test if secrets are working, create a simple test workflow:

```yaml
name: Test Secrets
on:
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - name: Test secrets
      run: |
        echo "Registry: ${{ secrets.REGISTRY_LOGIN_SERVER }}"
        echo "Username: ${{ secrets.REGISTRY_USERNAME }}"
        echo "Password: [MASKED]"
        echo "All secrets configured: ✅"
```

## 🆘 **Troubleshooting**

### **Common Issues:**

1. **"Secret not found"**
   - Double-check secret names (case-sensitive)
   - Ensure secrets are added to repository (not environment)

2. **"Authentication failed"**
   - Verify ACR admin user is enabled
   - Check service principal permissions

3. **"Access denied"**
   - Ensure service principal has contributor role
   - Check subscription and resource group access

### **Support Commands**

```bash
# Test Azure login
az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID

# Test ACR login
az acr login --name your-registry-name

# Test AKS access
az aks get-credentials --resource-group $AKS_RESOURCE_GROUP --name $AKS_CLUSTER_NAME
```

## 📋 **Checklist**

- [ ] All 10 secrets added to GitHub
- [ ] ACR admin user enabled
- [ ] Service principal created with contributor role
- [ ] AKS cluster accessible
- [ ] Snyk account created and token generated
- [ ] Secrets verified in GitHub repository settings
- [ ] Pipeline tested with a small commit

Once all secrets are configured, your GitHub Actions pipeline will work perfectly! 🚀
