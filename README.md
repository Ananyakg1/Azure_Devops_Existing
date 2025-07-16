# Flask Application CI/CD Setup Guide

## Prerequisites

Before using this pipeline, you need to configure the following in Azure DevOps:

### 1. Azure Container Registry (ACR)
- Create an Azure Container Registry
- Note down the registry name (e.g., `yourregistry.azurecr.io`)

### 2. Azure Kubernetes Service (AKS)
- Create an AKS cluster
- Note down the cluster name and resource group

### 3. Azure DevOps Service Connections

#### ACR Service Connection:
1. Go to Project Settings → Service Connections
2. Create a new service connection of type "Docker Registry"
3. Choose "Azure Container Registry"
4. Select your ACR and name it (e.g., `your-acr-service-connection`)

#### AKS Service Connection:
1. Go to Project Settings → Service Connections
2. Create a new service connection of type "Azure Resource Manager"
3. Choose "Service Principal (automatic)"
4. Select your subscription and resource group
5. Name it (e.g., `your-aks-service-connection`)

## Pipeline Variables to Update

Update these variables in `azure-pipelines.yml`:

```yaml
variables:
  - name: dockerRegistryServiceConnection
    value: 'your-acr-service-connection'  # Your ACR service connection name
  - name: containerRegistry
    value: 'yourregistry.azurecr.io'      # Your ACR registry URL
  - name: aksServiceConnection
    value: 'your-aks-service-connection'  # Your AKS service connection name
  - name: aksClusterName
    value: 'your-aks-cluster'             # Your AKS cluster name
  - name: resourceGroupName
    value: 'your-resource-group'          # Your Azure resource group name
```

## Kubernetes Deployment Files to Update

### In `k8s/deployment.yaml`:
- Update `image: yourregistry.azurecr.io/python-flask-app:latest` with your ACR URL
- Update `imagePullSecrets.name` with your ACR secret name

### In `k8s/service.yaml`:
- Update `your-domain.com` with your actual domain name (if using ingress)

## Pipeline Features

### Build Stage:
- Python 3.9 setup
- Dependency installation
- Unit tests with pytest
- Code coverage reporting
- Linting with pylint
- Test results publishing

### Docker Stage:
- Docker image build
- Push to Azure Container Registry
- Tags with build ID and 'latest'

### Deploy Stage:
- Azure CLI login
- kubectl installation
- AKS credentials configuration
- Kubernetes secret creation for ACR
- Application deployment to AKS

## Local Development

### Prerequisites:
```bash
pip install -r requirements.txt
```

### Run the application:
```bash
python app.py
```

### Run tests:
```bash
python -m pytest test_app.py -v
```

### Build Docker image locally:
```bash
docker build -t python-flask-app .
docker run -p 8080:8080 python-flask-app
```

## Deployment Options

### Development Environment:
Use `k8s/deployment-dev.yaml` for development deployments with:
- Single replica
- Development environment variables
- Reduced resource requirements

### Production Environment:
Use `k8s/deployment.yaml` for production deployments with:
- Multiple replicas (3)
- Production environment variables
- Health checks and resource limits
- Load balancer service

## Application Endpoints

- **Health Check**: `GET /`
- **Change Calculator**: `GET /change/<dollar>/<cents>`
  - Example: `GET /change/1/34` returns change for $1.34

## Security Features

- Non-root user in Docker container
- Resource limits in Kubernetes
- Health checks for container monitoring
- Image pull secrets for private registry access
- Namespace isolation options

## Monitoring and Logging

The deployment includes:
- Liveness and readiness probes
- Resource quotas and limits
- ConfigMap for environment variables
- Service monitoring endpoints

## Troubleshooting

### Common Issues:
1. **Pipeline fails at Docker stage**: Check ACR service connection
2. **Deployment fails**: Verify AKS service connection and cluster access
3. **Image pull errors**: Ensure ACR credentials are properly configured
4. **Application not accessible**: Check service and ingress configuration

### Debug Commands:
```bash
# Check pod status
kubectl get pods

# View pod logs
kubectl logs -f deployment/python-flask-app

# Check service status
kubectl get svc

# Describe deployment
kubectl describe deployment python-flask-app
```
