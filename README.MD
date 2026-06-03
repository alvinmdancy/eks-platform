## What this demonstrates

- **Modular Terraform** — reusable VPC and EKS modules separating infrastructure logic from environment-specific values
- **GitOps with ArgoCD** — cluster state driven by Git, with automatic drift detection and self-healing
- **CI pipeline** — GitHub Actions runs Terraform format and validation checks on every push
- **Observability** — kube-prometheus-stack with exported Grafana dashboards committed to the repo
- **Cost-conscious design** — single NAT gateway, minimum node count, full destroy/apply cycle documented

## Design decisions

**Modular Terraform over a flat structure** — splitting infrastructure into modules means the VPC and EKS logic is defined once and reused across environments. Adding a staging environment means calling the same modules with different values, not duplicating code.

**GitOps over kubectl in CI** — ArgoCD watches the repo and pulls changes into the cluster rather than having a pipeline push them. This means the cluster self-heals if someone makes a manual change directly — ArgoCD detects the drift and corrects it back to what is in Git.

**Single NAT gateway** — in production you would run one NAT gateway per availability zone for redundancy. In a lab environment a single NAT gateway reduces cost while keeping the architecture otherwise identical to production.

**kube-prometheus-stack** — installs Prometheus, Grafana, and the Kubernetes metric exporters in one Helm chart with production-ready defaults. Dashboards are exported as JSON and committed to the repo so anyone cloning it gets working observability immediately.

## Prerequisites

- AWS account with credentials configured
- Terraform >= 1.5.0
- kubectl
- Helm
- ArgoCD CLI

## Deploy

```bash
# configure AWS credentials
export AWS_PROFILE=YOUR_PROFILE

# provision infrastructure
cd terraform/environments/dev
terraform init
terraform apply

# configure kubectl
aws eks update-kubeconfig --region us-east-2 --name eks-platform-dev

# verify cluster
kubectl get nodes
```

## Access

**ArgoCD**
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
# open https://localhost:8080
```

**Grafana**
```bash
kubectl port-forward svc/kube-prometheus-stack-grafana -n monitoring 3000:80
# open http://localhost:3000
```

## Destroy

```bash
cd terraform/environments/dev
terraform destroy
```

Run this when the cluster is not in use to avoid unnecessary AWS charges.
