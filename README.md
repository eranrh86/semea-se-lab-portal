# SEMEA SE Lab Portal

Interactive lab guide for the SEMEA SE team — hands-on demos using Claude Code, AWS EKS, and Datadog.

**Live URL (CloudFront):** https://d3rlte81e7mlg5.cloudfront.net  
**Live URL (EKS):** http://ace3b2ab9e98d44e08183168de23ece0-213f397c7e6ae9b1.elb.us-east-1.amazonaws.com

---

## How to make changes

```bash
# 1. Go to your local copy
cd ~/semea-se-lab-portal

# 2. Edit the portal
open index.html          # preview in browser
# or: code index.html    # open in VS Code

# 3. Deploy (make sure AWS creds are loaded first)
source /tmp/aws_env.sh
./deploy.sh

# 4. Save to GitHub
git add index.html
git commit -m "describe your change"
git push
```

CloudFront propagates in ~60 seconds after the invalidation.

---

## File structure

| File | Description |
|------|-------------|
| `index.html` | Full lab portal — single HTML file, ~120KB, **edit this** |
| `lab-portal-k8s.yaml` | Kubernetes manifests (Namespace, ConfigMap, Deployment, Service) |
| `deploy.sh` | Push to S3 + CloudFront + EKS in one command |

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

## Infrastructure

| Resource | Value |
|----------|-------|
| S3 bucket | `semea-se-lab-portal` (us-east-1) |
| CloudFront distribution | `E294W2KG94LUBD` |
| EKS cluster | `karpenter-demo` (us-east-1) |
| EKS namespace | `claude-lab` |
| Deployment | 2-replica nginx, `index.html` served from ConfigMap |

---

## First-time setup on a new machine

```bash
# Clone
git clone https://github.com/eranrh86/semea-se-lab-portal.git ~/semea-se-lab-portal

# Install tools if needed
brew install awscli kubectl

# Load AWS credentials (rotate hourly)
source /tmp/aws_env.sh

# Configure kubectl
aws eks update-kubeconfig --name karpenter-demo --region us-east-1
```
