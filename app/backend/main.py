from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from fastapi.responses import PlainTextResponse

app = FastAPI(title="backend")

# Allow the frontend served on http://localhost:8080 to call us
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8080"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

requests_total = Counter("backend_requests_total", "Total HTTP requests", ["path"])

@app.get("/api/healthz")
def health():
    requests_total.labels(path="/api/healthz").inc()
    return {"status": "healthy"}

@app.get("/api/")
def root():
    requests_total.labels(path="/api/").inc()
    return {"ok": True, "service": "backend"}

@app.get("/api/metrics")
def metrics():
    return PlainTextResponse(generate_latest(), media_type=CONTENT_TYPE_LATEST)
