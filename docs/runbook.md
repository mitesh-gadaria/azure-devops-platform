# Runbook – AKS Deployment Failure (Architecture Mismatch)

## Incident Summary
During the initial deployment of the application to Azure Kubernetes Service (AKS), the pods entered a `CrashLoopBackOff` state immediately after startup.

## Impact
- Application pods failed to start
- Service unavailable in the cluster

## Symptoms
- Pods stuck in CrashLoopBackOff
- Logs showed: `exec format error`

## Root Cause
Docker image built for `arm64` while AKS nodes run `amd64`.

## Resolution
- Rebuilt image using `docker buildx --platform linux/amd64`
- Redeployed via CI/CD

## Prevention
- Enforced amd64 builds in CI
- Immutable image tags
