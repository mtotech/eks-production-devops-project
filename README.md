# Production-Grade Amazon EKS DevOps Platform
A complete production-grade DevOps project built using AWS, Terraform, Kubernetes, Helm, GitHub Actions, Prometheus, Grafana, SonarQube, Trivy, and Blue-Green Deployments.
## Architecture Diagram
Developer

↓

GitHub Repository

↓

GitHub Actions CI/CD

├─
Pytest

├─
SonarQube

├─
Trivy

├─
Docker Build

└─ 
Docker Push

↓

Docker Hub

↓

Amazon EKS

├─ 
AWS Load Balancer Controller

├─ 
Ingress

├─ 
Helm

├─
Flask Application

├─ 
HPA

└─ 
Blue-Green Deployment

↓

Prometheus

↓

Grafana

## Directory Structure


```text
eks-production-devops-project/
│
├── app/
│   ├── app.py
│   ├── requirements.txt
│   ├── Dockerfile
│   └── __init__.py
│
├── tests/
│   └── test_app.py
│
├── terraform/
│   ├── backend.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── locals.tf
│   ├── vpc.tf
│   ├── subnets.tf
│   ├── igw.tf
│   ├── nat.tf
│   ├── route-tables.tf
│   ├── security-groups.tf
│   ├── iam-cluster.tf
│   ├── iam-nodegroup.tf
│   ├── eks-cluster.tf
│   ├── nodegroup.tf
│   └── outputs.tf
│
├── kubernetes/
│   └── base/
│       ├── namespace.yaml
│       ├── deployment.yaml
│       ├── service.yaml
│       ├── ingress.yaml
│       └── kustomization.yaml
│
├── helm/
│   └── flask-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── ingress.yaml
│           ├── hpa.yaml
│           └── _helpers.tpl
│
├── monitoring/
│   ├── prometheus/
│   ├── grafana/
│   └── alertmanager/
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── sonar-project.properties
├── pytest.ini
├── .gitignore
└── README.md
```



## Features

- Multi-AZ EKS Cluster
- Managed Node Groups
- Private Subnets
- NAT Gateway
- AWS Load Balancer Controller
- Ingress-Based Routing
- Horizontal Pod Autoscaler
- Helm Deployments
- GitHub Actions CI/CD
- SonarQube Quality Gates
- Trivy Security Scanning
- Prometheus Monitoring
- Grafana Dashboards
- Blue-Green Deployment Strategy
- Helm Rollback




## Project Phases
| Phase | Description |
|---------|------------|
| 1 | Flask Application |
| 2 | Dockerization |
| 3 | Terraform Backend |
| 4 | VPC Infrastructure |
| 5 | IAM Roles |
| 6 | EKS Cluster |
| 7 | Managed Node Group |
| 8 | Kubernetes Foundation |
| 9 | Helm Deployment |
| 10 | Monitoring |
| 11 | CI/CD |
| 12 | Security Scanning |
| 13 | HPA |
| 14 | Blue-Green Deployment |

## Deployment steps
### Prerequisites
AWS

•	AWS Account

•	IAM User with AdministratorAccess

•	AWS CLI configured

Verify:

aws sts get-caller-identity
________________________________________
### Required Tools
terraform version     |    kubectl version     |     helm version     |     docker version     |     aws --version     |     eksctl version
### Required:  
•	Terraform >= 1.5

•	kubectl

•	Helm

•	Docker

•	AWS CLI

•	eksctl

________________________________________
### Step 1: Clone Repository
git clone https://github.com/mtotech/eks-production-devops-project.git

cd eks-production-devops-project
________________________________________
### Step 2: Create Terraform Backend
Navigate to Terraform Directory

cd terraform

Create Backend Resources

terraform init

terraform apply -target=aws_s3_bucket.tf_state

terraform apply -target=aws_dynamodb_table.terraform_lock

#### Expected Output
•	     S3 Bucket Created         •	       DynamoDB Lock Table Created
________________________________________
### Step 3: Deploy Infrastructure
terraform init

terraform plan

terraform apply
#### Resources Created
•	VPC   •	  Public Subnets
•	Private Subnets
•	Internet Gateway
•	NAT Gateway
•	Route Tables
•	EKS Cluster
•	Managed Node Group
•	IAM Roles

#### Verify:
aws eks list-clusters
#### Expected:
eks-production
________________________________________
### Step 4: Configure kubectl
#### After EKS Cluster Creation:
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name eks-production
  
#### Verify:
kubectl get nodes
#### Expected:
2 Ready Nodes
________________________________________
### Step 5: Deploy Kubernetes Base Resources
#### Return to Project Root
cd ..
#### Deploy Base Resources
kubectl apply -f kubernetes/base/
#### Verify
kubectl get ns

kubectl get all -n production

#### Resources Created: 
•	Namespace   •	  ResourceQuota    •	LimitRange    •	    NetworkPolicy    •	  RBAC    •	    Secret    •	    ConfigMap    •	  ServiceAccount
________________________________________
### Step 6: Build Docker Image
#### Build Application

docker build -t flask-app ./app
#### Tag Image
docker tag flask-app:latest chauhanneru877/flask-app:v1
#### Login Docker Hub
docker login
#### Push Image
docker push chauhanneru877/flask-app:v1
#### Verify
docker images
________________________________________
### Step 7: Deploy Helm Application
#### Install Monitoring First
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm install monitoring \
prometheus-community/kube-prometheus-stack \
-n monitoring \
--create-namespace

#### Verify
kubectl get pods -n monitoring
#### Expected
•	Prometheus Running
•	Grafana Running
•	AlertManager Running
________________________________________
### Step 8: Install Metrics Server
#### Required for HPA
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
#### Verify
kubectl top nodes

kubectl top pods -n production
________________________________________
### Step 9: Deploy Application Using Helm
#### Install Application
helm install flask-app helm/flask-app -n production
#### Verify
helm list -n production

kubectl get all -n production
#### Expected
•	Deployment Running   •	Pods Running    •	  Service Created    •	  HPA Created    •	  Ingress Created    •	  ServiceMonitor Created
________________________________________
### Step 10: Configure AWS Load Balancer Controller
#### Create IAM Policy
aws iam create-policy \
--policy-name AWSLoadBalancerControllerIAMPolicy \
--policy-document file://aws-load-balancer-controller/iam_policy.json

Skip if already exists.
________________________________________
#### Associate OIDC Provider
aws eks describe-cluster \
--name eks-production \
--region ap-south-1 \
--query "cluster.identity.oidc.issuer"
________________________________________
#### Create IAM Service Account
eksctl create iamserviceaccount \
  --cluster eks-production \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::<ACCOUNT-ID>:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve \
  --region ap-south-1
________________________________________
#### Install Controller
helm repo add eks https://aws.github.io/eks-charts

helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eks-production \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
________________________________________
#### Fix VPC Discovery Issue
##### Get VPC ID

aws eks describe-cluster \
--name eks-production \
--region ap-south-1 \
--query "cluster.resourcesVpcConfig.vpcId" \
--output text
##### Upgrade Controller
helm upgrade aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eks-production \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=ap-south-1 \
  --set vpcId=<VPC-ID>   # change VPC ID HERE
________________________________________
#### Verify Controller
kubectl get pods -n kube-system | grep aws-load-balancer-controller

kubectl get deployment aws-load-balancer-controller -n kube-system

#### Expected
2/2 Running
________________________________________
### Step 11: Verify ALB
kubectl get ingress -n production -o wide
#### Expected
k8s-producti-flasking-xxxxxxxx.ap-south-1.elb.amazonaws.com
#### Test Application
curl http://<ALB-DNS-NAME>     # USE DNS-NAME HERE
#### Expected
{
  "Application":"Production Flask App",
  "Platform":"Amazon EKS",
  "Status":"Running"
}
________________________________________
#### Validation Commands
kubectl get nodes | kubectl get pods -A | kubectl get ingress -n production | kubectl get servicemonitor -n production | kubectl top nodes | kubectl top pods   production  helm list -A
________________________________________
#### Troubleshooting Encountered
ServiceMonitor CRD Missing

Error:

no matches for kind ServiceMonitor

#### Fix:
Install kube-prometheus-stack first.
________________________________________
#### Metrics API Not Available
Error:

kubectl top nodes

Metrics API not available

#### Fix:

Install Metrics Server.
________________________________________
#### HPA Unable to Fetch Metrics
Error:

unable to fetch metrics from resource metrics API

Fix:

Deploy Metrics Server.
________________________________________
#### AWS Load Balancer Controller CrashLoopBackOff
Error:

failed to get VPC ID

Fix:

Pass VPC ID explicitly using Helm upgrade.
________________________________________
#### Missing Service Account
Error:

serviceaccount aws-load-balancer-controller not found

Fix:

Create IRSA ServiceAccount using eksctl.

## Cleanup & Destroy Infrastructure
### Step 1: Delete Application Helm Release
helm uninstall flask-app -n production
#### Verify:
helm list -n production
________________________________________
### Step 2: Delete Monitoring Stack
helm uninstall monitoring -n monitoring
#### Verify:
kubectl get pods -n monitoring
#### Expected:
No resources found
________________________________________
### Step 3: Delete AWS Load Balancer Controller
helm uninstall aws-load-balancer-controller -n kube-system
#### Verify:
kubectl get pods -n kube-system | grep aws-load-balancer-controller
#### Expected:
No resources found
________________________________________
### Step 4: Delete Kubernetes Base Resources
kubectl delete -f kubernetes/base/
#### Verify:
kubectl get ns production
#### Expected:
NotFound
________________________________________
### Step 5: Verify Load Balancer Deletion
Check AWS Console:

•	EC2 → Load Balancers

OR

kubectl get ingress -n production
#### Expected:
No resources found

Wait until the ALB is deleted before proceeding.
________________________________________
#### Step 6: Destroy Terraform Infrastructure
Go to Terraform directory:

cd terraform

Initialize:


terraform init

Review destroy plan:

terraform plan -destroy
#### Destroy infrastructure:
terraform destroy

Type:

yes

Terraform will delete:

•	EKS Cluster

•	Node Groups

•	VPC

•	Subnets

•	Route Tables

•	Internet Gateway

•	NAT Gateway

•	Security Groups

•	IAM Resources
________________________________________
#### Step 7: Verify Everything Is Deleted
aws eks list-clusters
#### Expected:
{
  "clusters": []
}

Check VPCs:

aws ec2 describe-vpcs
#### Verify your project VPC is gone.
________________________________________
### Step 8: Delete Terraform Backend (Optional)
Only if you no longer need state storage.
#### Delete state file:
aws s3 rm s3://<neeraj-devops-terraform-state> --recursive
#### Delete bucket:
aws s3 rb s3://<neeraj-devops-terraform-state> --force
#### Delete lock table:
aws dynamodb delete-table \
  --table-name terraform-lock


## Author

Neeraj Kumar





