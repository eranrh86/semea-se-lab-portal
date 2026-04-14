# SEMEA SE Lab Portal

Interactive lab guide for the SEMEA SE team — hands-on demos using Claude Code, AWS EKS, and Datadog.

**Live URL (CloudFront):** https://d3rlte81e7mlg5.cloudfront.net  
**Live URL (EKS):** http://ace3b2ab9e98d44e08183168de23ece0-213f397c7e6ae9b1.elb.us-east-1.amazonaws.com

---

## Contents

| File | Description |
|------|-------------|
| `index.html` | Full lab portal — single-page HTML (~120KB), served as-is |
| `lab-portal-k8s.yaml` | Kubernetes manifests (Namespace, ConfigMap, Deployment, Service) |
| `deploy.sh` | One-command deploy to S3 + CloudFront + EKS |

---

## Labs

| # | Lab | Time |
|---|-----|------|
| 1 | Karpenter + EKS — Intelligent Node Provisioning | 30 min |
| 2 | 3-Tier App + Observability Pipelines Worker | 45 min |
| 3 | Datadog MCP — Natural Language Observability | 30 min |
| 4 | APM + RUM + Synthetics | 40 min |
| 5 | GitHub Actions + CI Visibility | 30 min |

---

## MCP Servers (Prerequisites Step 6)

| MCP | Command |
|-----|---------|
| Datadog | `claude mcp add --transport http datadog https://mcp.datadoghq.com/mcp` |
| Atlassian (Jira + Confluence) | `claude mcp add --transport http -s user atlassian https://mcp.atlassian.com/v1/mcp` |
| Slack | `claude mcp add --transport http --client-id 1601185624273.8899143856786 --callback-port 3118 slack https://mcp.slack.com/mcp` |
| Google Drive | `claude mcp add datadog-google-workspace --transport http https://google-workspace-mcp-server-834963730936.us-central1.run.app/mcp` |
| Gmail | `claude mcp add --transport http gmail https://gmail.googleapis.com/mcp` |
| Google Calendar | `claude mcp add --transport http gcal https://calendar.googleapis.com/mcp` |

---

## Deploying Updates

### Quick deploy (all targets)
```bash
./deploy.sh
```

### Manual
```bash
# Update S3 + CloudFront
aws s3 cp index.html s3://semea-se-lab-portal/index.html --content-type text/html
aws cloudfront create-invalidation --distribution-id E294W2KG94LUBD --paths "/*"

# Update EKS
kubectl create configmap lab-portal-html --from-file=index.html=index.html -n claude-lab --dry-run=client -o yaml | kubectl apply -f -
kubectl rollout restart deployment/lab-portal -n claude-lab
```

---

## Infrastructure

- **S3 bucket:** `semea-se-lab-portal` (us-east-1)
- **CloudFront distribution:** `E294W2KG94LUBD`
- **EKS cluster:** `karpenter-demo` (us-east-1)
- **Namespace:** `claude-lab`
- **Deployment:** 2-replica nginx serving `index.html` from ConfigMap
