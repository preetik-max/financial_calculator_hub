from datetime import datetime, timezone

from app.database.metal_database import save_metal_price
from app.services.free_metal_service import (
    get_latest_metal_rates_fresh,
)


async def collect_current_metal_prices() -> None:
    """
    Fetch fresh Gold and Silver prices and save them
    into the SQLite history database.

    Gold  = INR/gram
    Silver = INR/kg
    """

    data = await get_latest_metal_rates_fresh()

    timestamp = (
        data.get("updated_at")
        or data.get("price_as_of")
        or datetime.now(timezone.utc).isoformat()
    )

    gold_price = float(
        data["gold"]["spot_per_gram"]
    )

    silver_price = float(
        data["silver"]["spot_per_kg"]
    )

    save_metal_price(
        metal="gold",
        timestamp=timestamp,
        price_inr=gold_price,
    )

    save_metal_price(
        metal="silver",
        timestamp=timestamp,
        price_inr=silver_price,
    )
