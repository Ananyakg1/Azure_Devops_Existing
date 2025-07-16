# Azure DevOps Pipeline Secrets Configuration

## Required Secrets/Variables

Configure these secrets in your Azure DevOps project under **Pipelines > Library > Variable Groups** or **Project Settings > Pipelines > Service Connections**.

### 1. Security Scanning
```
SNYK_TOKEN
```
- **Description**: Token for Snyk security scanning
- **How to get**: Register at https://snyk.io and generate an API token
- **Usage**: Used for vulnerability scanning of dependencies

### 2. Azure Authentication
```
AZURE_CLIENT_ID
AZURE_CLIENT_SECRET
AZURE_TENANT_ID
AZURE_SUSCRIPTION_ID
```
- **Description**: Service Principal credentials for Azure authentication
- **How to get**: 
  1. Create a Service Principal in Azure AD
  2. Grant appropriate permissions to your resource group/subscription
  3. Get the Application (client) ID, Secret, Tenant ID, and Subscription ID
- **Usage**: Used for Azure CLI login and AKS access

### 3. Container Registry
```
REGISTRY_LOGIN_SERVER
REGISTRY_USERNAME
REGISTRY_PASSWORD
```
- **Description**: Azure Container Registry credentials
- **How to get**: 
  1. Go to your ACR in Azure Portal
  2. Enable Admin user in Access Keys
  3. Copy Login server, Username, and Password
- **Usage**: Used for Docker image push/pull operations

### 4. Azure Kubernetes Service
```
AKS_CLUSTER_NAME
AKS_RESOURCE_GROUP
```
- **Description**: AKS cluster details
- **How to get**: From your AKS cluster in Azure Portal
- **Usage**: Used for kubectl configuration and deployment

## Example Values

```yaml
# Security
SNYK_TOKEN: "your-snyk-token-here"

# Azure Authentication
AZURE_CLIENT_ID: "12345678-1234-1234-1234-123456789012"
AZURE_CLIENT_SECRET: "your-client-secret-here"
AZURE_TENANT_ID: "87654321-4321-4321-4321-210987654321"
AZURE_SUSCRIPTION_ID: "11111111-2222-3333-4444-555555555555"

# Container Registry
REGISTRY_LOGIN_SERVER: "myregistry.azurecr.io"
REGISTRY_USERNAME: "myregistry"
REGISTRY_PASSWORD: "your-registry-password"

# AKS
AKS_CLUSTER_NAME: "my-aks-cluster"
AKS_RESOURCE_GROUP: "my-resource-group"
```

## Setting Up Secrets in Azure DevOps

### Method 1: Variable Groups (Recommended)
1. Go to **Pipelines > Library**
2. Click **+ Variable group**
3. Name it "pipeline-secrets"
4. Add all the variables above
5. Mark sensitive variables as "Secret" (lock icon)
6. Save the variable group
7. In your pipeline, reference it with:
   ```yaml
   variables:
   - group: pipeline-secrets
   ```

### Method 2: Pipeline Variables
1. Go to your pipeline
2. Click **Edit**
3. Click **Variables**
4. Add each variable
5. Mark sensitive ones as "Secret"

## Security Best Practices

1. **Never commit secrets** to source control
2. **Use least privilege** for service principal permissions
3. **Rotate secrets regularly** (every 90 days recommended)
4. **Monitor secret usage** in Azure AD audit logs
5. **Use Azure Key Vault** for additional security (optional)

## Troubleshooting

### Common Issues:
1. **"Authentication failed"** - Check Azure credentials
2. **"Image pull failed"** - Verify registry credentials
3. **"kubectl command not found"** - Pipeline installs kubectl automatically
4. **"Namespace not found"** - Pipeline creates namespace automatically

### Debug Steps:
1. Check secret values in pipeline logs (they should be masked)
2. Verify service principal has contributor access to resource group
3. Ensure ACR admin user is enabled
4. Check AKS cluster name and resource group spelling
