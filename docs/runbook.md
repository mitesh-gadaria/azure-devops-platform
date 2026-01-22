# Runbook – AKS Deployment Failure (Architecture Mismatch)

## Incident Summary

During the initial deployment of the application to Azure Kubernetes Service (AKS), the pods entered a `CrashLoopBackOff` state immediately after startup.

The application failed to become ready and no traffic could be served.

---

## Impact

* Application pods failed to start
* Kubernetes deployment could not reach a healthy state
* Service was unavailable in the cluster

---

## Symptoms Observed

* `kubectl get pods` showed repeated restarts
* Pod status alternated between `Error` and `CrashLoopBackOff`
* Readiness and liveness probes never succeeded

Logs from the container showed:

```
exec /usr/local/bin/uvicorn: exec format error
```

---

## Investigation Steps

1. Verified image pull status

   * Image pulled successfully from Azure Container Registry (ACR)
   * Ruled out authentication or image-not-found issues

2. Inspected pod logs

   * Used `kubectl logs --previous`
   * Identified `exec format error`

3. Checked runtime environment

   * Local development machine: Apple Silicon (arm64)
   * AKS node architecture: linux/amd64

4. Confirmed Docker build behaviour

   * Local Docker builds defaulted to arm64
   * Image was incompatible with AKS node architecture

---

## Root Cause

The Docker image was built for the **arm64** architecture (Apple Silicon), but AKS worker nodes run on **amd64**.

This caused the container runtime to fail when attempting to execute the application binary inside the container.

---

## Resolution

1. Rebuilt the Docker image using Docker Buildx
2. Explicitly targeted the correct platform:

```
docker buildx build --platform linux/amd64 --push
```

3. Updated the Kubernetes deployment to always pull the image

4. Restarted the deployment and verified rollout

After the fix:

* Pods started successfully
* Readiness and liveness probes passed
* Application became available

---

## Preventative Measures

To ensure this issue does not reoccur:

* GitHub Actions CI pipeline enforces `linux/amd64` builds
* Immutable image tags based on commit SHA are used
* Kubernetes deployment uses rolling updates

This ensures architecture compatibility is guaranteed automatically.

---

## Lessons Learned

* Local development architecture may differ from production
* Kubernetes `CrashLoopBackOff` often requires log inspection
* CI pipelines should enforce production constraints
* Automation prevents environment-specific issues from recurring

---

## Related Files

* `.github/workflows/ci.yml`
* `docker/Dockerfile`
* `k8s/deployment.yaml`

---

## Status

**Resolved** – Issue permanently mitigated through CI enforcement
