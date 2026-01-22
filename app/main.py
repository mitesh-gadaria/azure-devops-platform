from fastapi import FastAPI

app = FastAPI(title="Azure DevOps Platform Demo", version="1.0.0")

@app.get("/")
def root():
    return {"status": "ok", "message": "Hello from FastAPI running on Azure/Kubernetes"}

@app.get("/health")
def health():
    return {"status": "healthy"}
