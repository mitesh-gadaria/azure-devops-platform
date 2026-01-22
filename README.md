# Azure DevOps Platform – End‑to‑End CI/CD on AKS

## Overview

This project demonstrates a **production‑style DevOps platform** built end‑to‑end on Azure. The goal was not to showcase isolated tools, but to design, deploy, break, fix, and automate a **complete system** using real-world DevOps practices.

The platform deploys a containerised FastAPI application to **Azure Kubernetes Service (AKS)** using **Terraform** for infrastructure and **GitHub Actions** for CI/CD.

---

## Architecture

**High-level flow:**

1. Developer pushes code to `main`
2. GitHub Actions (CI):

   * Builds Docker image (linux/amd64)
   * Tags image with commit SHA
   * Pushes image to Azure Container Registry (ACR)
3. GitHub Actions (CD):

   * Pulls image from ACR
   * Deploys to AKS
   * Waits for rollout completion
4. Application runs in AKS behind a Kubernetes Service

**Core components:**

* **FastAPI application** (with health checks)
* **Docker** (containerisation)
* **Terraform** (IaC for Azure)
* **Azure Container Registry (ACR)**
* **Azure Kubernetes Service (AKS)**
* **GitHub Actions** (CI & CD)

---

## Repository Structure

```
.
├── app/                    # FastAPI application
├── docker/                 # Dockerfile
├── infra/terraform/        # Terraform IaC (AKS, ACR, RG, Log Analytics)
├── k8s/                    # Kubernetes manifests
├── .github/workflows/      # CI/CD pipelines
└── README.md
```

---

## Infrastructure as Code (Terraform)

Terraform provisions:

* Azure Resource Group
* Azure Container Registry (ACR)
* Azure Kubernetes Service (AKS)
* Log Analytics Workspace

Key practices:

* Clean module-style file separation
* Environment variables via `dev.tfvars`
* Terraform state **not committed** to GitHub
* Provider lock file committed for reproducibility

---

## Kubernetes Deployment

The application is deployed using Kubernetes manifests:

* Dedicated namespace
* Deployment with multiple replicas
* Liveness & readiness probes
* ClusterIP service

This ensures:

* Zero-downtime rollouts
* Health-based restarts
* Production-like behaviour

---

## CI/CD Pipelines

### Continuous Integration (CI)

Triggered on every push to `main`:

* Docker Buildx builds **linux/amd64** images
* Images tagged with immutable commit SHA
* Images pushed to ACR

### Continuous Deployment (CD)

Triggered after CI success:

* Deploys the new image to AKS
* Performs rolling update
* Verifies rollout completion

All deployments are fully automated.

---

## Real‑World Issue Encountered & Fixed

While deploying from an Apple Silicon (arm64) machine, the application initially failed in AKS with `CrashLoopBackOff` and `exec format error`.

**Root cause:**

* Docker images were built for `arm64`
* AKS nodes run `amd64`

**Resolution:**

* Switched to `docker buildx`
* Enforced `--platform linux/amd64`
* Automated architecture correctness in CI

This fix is now permanently enforced via GitHub Actions.

---

## Why This Project Matters

This project demonstrates:

* End‑to‑end system ownership
* Infrastructure automation
* Kubernetes operational understanding
* Real production debugging
* CI/CD best practices

It reflects how DevOps systems are built and operated in real teams.

---

## Next Improvements (Optional)

* Remote Terraform state backend (Azure Storage)
* Monitoring dashboards
* Blue/Green or Canary deployments
* Security scanning in CI

---

## Author

Built by **Mitesh Gadaria** as a practical DevOps portfolio project.



## Runbooks

- [AKS Deployment Failure – Architecture Mismatch](docs/runbook.md)
