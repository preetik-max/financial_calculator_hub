from fastapi import FastAPI

from app.routes.metals import router as metals_router


app = FastAPI(
    title="Finora Financial API",
    version="1.0.0",
    description="Free indicative Gold and Silver market rates API.",
)


app.include_router(metals_router)


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
