#!/bin/bash
# deploy.sh — push lab portal to S3 + CloudFront + EKS
set -e

BUCKET="semea-se-lab-portal"
CF_DIST="E294W2KG94LUBD"
NAMESPACE="claude-lab"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HTML="$SCRIPT_DIR/index.html"

echo "→ Uploading to S3..."
aws s3 cp "$HTML" "s3://$BUCKET/index.html" --content-type text/html

echo "→ Invalidating CloudFront..."
INV_ID=$(aws cloudfront create-invalidation --distribution-id "$CF_DIST" --paths "/*" --query 'Invalidation.Id' --output text)
echo "  Invalidation: $INV_ID"

echo "→ Updating EKS ConfigMap..."
kubectl create configmap lab-portal-html \
  --from-file=index.html="$HTML" \
  -n "$NAMESPACE" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "→ Rolling out deployment..."
kubectl rollout restart deployment/lab-portal -n "$NAMESPACE"
kubectl rollout status deployment/lab-portal -n "$NAMESPACE" --timeout=60s

echo ""
echo "✅ Done."
echo "   CloudFront: https://d3rlte81e7mlg5.cloudfront.net"
echo "   EKS LB:     http://ace3b2ab9e98d44e08183168de23ece0-213f397c7e6ae9b1.elb.us-east-1.amazonaws.com"
