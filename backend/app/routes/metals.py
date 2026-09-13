from fastapi import APIRouter, HTTPException, Query

from app.services.free_metal_service import (
    get_latest_metal_rates,
    get_metal_history,
)


router = APIRouter(
    prefix="/api/metals",
    tags=["Metals"],
)


@router.get("")
async def get_metals():

    try:
        return await get_latest_metal_rates()

    except Exception as exc:

        raise HTTPException(
            status_code=502,
            detail=(
                f"Unable to fetch live metal rates: {exc}"
            ),
        ) from exc


@router.get("/history")
async def get_history(
    metal: str = Query(
        "gold",
        description="gold or silver",
    ),

    hours: int = Query(
        24,
        ge=1,
        le=48,
    ),

    interval: int = Query(
        5,
        description="5, 15, 30 or 60 minutes",
    ),
):

    try:

        return await get_metal_history(
            metal=metal,
            hours=hours,
            interval_minutes=interval,
        )

    except ValueError as exc:

        raise HTTPException(
            status_code=400,
            detail=str(exc),
        ) from exc

    except Exception as exc:

        raise HTTPException(
            status_code=502,
            detail=(
                "Unable to fetch metal history: "
                f"{exc}"
            ),
        ) from exc


@router.post("/history/collect")
async def collect_history():

    from app.services.metal_history_collector import (
        collect_current_metal_prices,
    )

    try:

        await collect_current_metal_prices()

        return {
            "status": "ok",
            "message": "Current Gold and Silver prices saved.",
        }

    except Exception as exc:

        raise HTTPException(
            status_code=502,
            detail=(
                "Unable to collect metal prices: "
                f"{exc}"
            ),
        ) from exc
