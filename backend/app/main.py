from fastapi import FastAPI


app = FastAPI(
    title="Finora Financial API",
    version="1.0.0",
    description="Finora Financial Calculator API.",
)


@app.get("/")
async def root():
    return {
        "app": "Finora Financial API",
        "status": "ok",
        "message": "API is running",
    }


@app.get("/health")
async def health():
    return {
        "status": "healthy",
    }
