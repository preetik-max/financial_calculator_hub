import time
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

import httpx


API_URL = "https://xaus.com/api/v1/spot"
INTRADAY_URL = "https://xaus.com/api/v1/intraday"

TROY_OUNCE_GRAMS = 31.1034768

CACHE_SECONDS = 900

_cache_data: Optional[Dict[str, Any]] = None
_cache_timestamp: float = 0.0


async def _fetch_spot() -> Dict[str, Any]:
    async with httpx.AsyncClient(timeout=15.0) as client:
        response = await client.get(
            API_URL,
            params={
                "currency": "INR",
            },
        )

        response.raise_for_status()

        return response.json()


async def get_latest_metal_rates() -> Dict[str, Any]:
    global _cache_data
    global _cache_timestamp

    now = time.time()

    if (
        _cache_data is not None
        and now - _cache_timestamp < CACHE_SECONDS
    ):
        return _cache_data

    data = await _fetch_spot()

    gold_oz_inr = float(data["xau"]["price"])

    gold_gram_inr = gold_oz_inr / TROY_OUNCE_GRAMS

    silver_usd_oz = float(data["silver_usd_oz"])
    fx_rate = float(data["fx_rate"])

    silver_oz_inr = silver_usd_oz * fx_rate
    silver_gram_inr = silver_oz_inr / TROY_OUNCE_GRAMS

    result = {
        "source": data.get("source", "xaus.com"),
        "price_source": data.get(
            "price_source",
            "gold-api.com",
        ),
        "currency": "INR",

        "updated_at": data.get("updated_at"),
        "price_as_of": data.get("price_as_of"),

        "data_state": data.get(
            "data_state",
            {},
        ),

        "gold": {
            "spot_per_gram": round(
                gold_gram_inr,
                2,
            ),
            "spot_per_10g": round(
                gold_gram_inr * 10,
                2,
            ),
            "spot_per_kg": round(
                gold_gram_inr * 1000,
                2,
            ),
            "spot_per_troy_oz": round(
                gold_oz_inr,
                2,
            ),

            "purity": {
                "24k": {
                    "karat": 24,
                    "fineness": 999,
                    "per_gram": round(
                        gold_gram_inr,
                        2,
                    ),
                    "per_10g": round(
                        gold_gram_inr * 10,
                        2,
                    ),
                },

                "22k": {
                    "karat": 22,
                    "fineness": 916,
                    "per_gram": round(
                        gold_gram_inr * 22 / 24,
                        2,
                    ),
                    "per_10g": round(
                        gold_gram_inr * 10 * 22 / 24,
                        2,
                    ),
                },

                "18k": {
                    "karat": 18,
                    "fineness": 750,
                    "per_gram": round(
                        gold_gram_inr * 18 / 24,
                        2,
                    ),
                    "per_10g": round(
                        gold_gram_inr * 10 * 18 / 24,
                        2,
                    ),
                },
            },
        },

        "silver": {
            "spot_per_gram": round(
                silver_gram_inr,
                2,
            ),
            "spot_per_10g": round(
                silver_gram_inr * 10,
                2,
            ),
            "spot_per_kg": round(
                silver_gram_inr * 1000,
                2,
            ),
            "spot_per_troy_oz": round(
                silver_oz_inr,
                2,
            ),

            "purity": {
                "999": {
                    "fineness": 999,
                    "per_gram": round(
                        silver_gram_inr * 999 / 1000,
                        2,
                    ),
                    "per_10g": round(
                        silver_gram_inr * 10 * 999 / 1000,
                        2,
                    ),
                    "per_kg": round(
                        silver_gram_inr * 1000 * 999 / 1000,
                        2,
                    ),
                },
            },
        },

        "indicative": True,

        "note": (
            "Indicative INR spot/reference price only. "
            "Gold purity values are calculated from the 24K spot reference. "
            "Retail jewellery prices may include GST, making charges, "
            "wastage, retailer margins and local market differences."
        ),
    }

    _cache_data = result
    _cache_timestamp = now

    return result


async def _fetch_intraday(
    symbol: str,
    hours: int,
) -> Dict[str, Any]:

    async with httpx.AsyncClient(timeout=20.0) as client:
        response = await client.get(
            INTRADAY_URL,
            params={
                "symbol": symbol,
                "hours": hours,
            },
        )

        response.raise_for_status()

        return response.json()


def _parse_timestamp(value: Any) -> Optional[datetime]:
    if value is None:
        return None

    text = str(value)

    try:
        if text.endswith("Z"):
            text = text[:-1] + "+00:00"

        dt = datetime.fromisoformat(text)

        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)

        return dt.astimezone(timezone.utc)

    except ValueError:
        return None


async def get_metal_history(
    metal: str,
    hours: int,
    interval_minutes: int,
) -> Dict[str, Any]:

    metal = metal.lower().strip()

    if metal not in ("gold", "silver"):
        raise ValueError(
            "metal must be gold or silver"
        )

    if hours < 1 or hours > 48:
        raise ValueError(
            "hours must be between 1 and 48"
        )

    if interval_minutes not in (5, 15, 30, 60):
        raise ValueError(
            "interval must be 5, 15, 30 or 60 minutes"
        )

    symbol = "xau" if metal == "gold" else "xag"

    data = await _fetch_intraday(
        symbol=symbol,
        hours=hours,
    )

    points = data.get("points", [])

    if not points:
        return {
            "metal": metal,
            "symbol": "XAU" if metal == "gold" else "XAG",
            "currency": "INR",
            "unit": "INR/gram"
            if metal == "gold"
            else "INR/kg",
            "hours": hours,
            "interval_minutes": interval_minutes,
            "source": "xaus.com",
            "data_state": data.get(
                "data_state",
                {
                    "status": "unavailable",
                    "as_of": None,
                    "source": None,
                    "age_seconds": None,
                },
            ),
            "coverage_seconds": data.get(
                "coverage_seconds",
                0,
            ),
            "updated_at": data.get(
                "updated_at"
            ),
            "candles": [],
        }

    # Get current INR FX conversion.
    spot = await _fetch_spot()

    fx_rate = float(
        spot.get(
            "fx_rate",
            1,
        )
    )

    # Current XAU/XAG prices are supplied in USD/oz.
    #
    # For historical INR values we use the current USD→INR
    # conversion because XAUS intraday provides the metal
    # price series, while its documented intraday response
    # does not provide historical FX points.
    #
    # This is clearly labelled as indicative.
    if metal == "gold":
        divisor = TROY_OUNCE_GRAMS
        multiplier = fx_rate
        unit = "INR/gram"
    else:
        divisor = TROY_OUNCE_GRAMS
        multiplier = fx_rate
        unit = "INR/kg"

    raw_points: List[Dict[str, Any]] = []

    for point in points:
        timestamp = _parse_timestamp(
            point.get("t")
        )

        price = point.get("p")

        if timestamp is None or price is None:
            continue

        usd_per_oz = float(price)

        inr_per_gram = (
            usd_per_oz
            * multiplier
            / divisor
        )

        if metal == "gold":
            value = inr_per_gram
        else:
            value = inr_per_gram * 1000

        raw_points.append(
            {
                "timestamp": timestamp,
                "price": value,
            }
        )

    if not raw_points:
        return {
            "metal": metal,
            "symbol": "XAU" if metal == "gold" else "XAG",
            "currency": "INR",
            "unit": unit,
            "hours": hours,
            "interval_minutes": interval_minutes,
            "source": "xaus.com",
            "data_state": {
                "status": "unavailable",
                "as_of": None,
                "source": None,
                "age_seconds": None,
            },
            "coverage_seconds": 0,
            "updated_at": None,
            "candles": [],
        }

    raw_points.sort(
        key=lambda item: item["timestamp"]
    )

    # -----------------------------------------
    # Build OHLC candles
    # -----------------------------------------

    buckets: Dict[int, List[float]] = {}

    interval_seconds = (
        interval_minutes * 60
    )

    for point in raw_points:

        timestamp = int(
            point["timestamp"].timestamp()
        )

        bucket = (
            timestamp // interval_seconds
        ) * interval_seconds

        buckets.setdefault(
            bucket,
            [],
        ).append(
            point["price"]
        )

    candles: List[Dict[str, Any]] = []

    for bucket in sorted(buckets.keys()):

        values = buckets[bucket]

        if not values:
            continue

        candles.append(
            {
                "time": datetime.fromtimestamp(
                    bucket,
                    tz=timezone.utc,
                ).isoformat(),

                "open": round(
                    values[0],
                    2,
                ),

                "high": round(
                    max(values),
                    2,
                ),

                "low": round(
                    min(values),
                    2,
                ),

                "close": round(
                    values[-1],
                    2,
                ),

                "points": len(values),
            }
        )

    first_time = raw_points[0]["timestamp"]
    last_time = raw_points[-1]["timestamp"]

    coverage_seconds = int(
        (
            last_time - first_time
        ).total_seconds()
    )

    data_state = data.get(
        "data_state",
        {
            "status": "fresh",
            "as_of": data.get(
                "updated_at"
            ),
            "source": "upstream",
            "age_seconds": 0,
        },
    )

    return {
        "metal": metal,

        "symbol": (
            "XAU"
            if metal == "gold"
            else "XAG"
        ),

        "currency": "INR",

        "unit": unit,

        "hours": hours,

        "interval_minutes": interval_minutes,

        "source": "xaus.com",

        "data_state": data_state,

        "coverage_seconds": coverage_seconds,

        "updated_at": data.get(
            "updated_at"
        ),

        "fx_rate_used": fx_rate,

        "candles": candles,
    }

async def get_latest_metal_rates_fresh() -> Dict[str, Any]:
    """
    Fetch fresh Gold and Silver prices directly from XAUS.

    This bypasses the normal 15-minute application cache and is
    intended for historical price collection.
    """

    data = await _fetch_spot()

    gold_oz_inr = float(data["xau"]["price"])
    gold_gram_inr = gold_oz_inr / TROY_OUNCE_GRAMS

    silver_usd_oz = float(data["silver_usd_oz"])
    fx_rate = float(data["fx_rate"])

    silver_oz_inr = silver_usd_oz * fx_rate
    silver_gram_inr = silver_oz_inr / TROY_OUNCE_GRAMS

    return {
        "source": data.get("source", "xaus.com"),
        "price_source": data.get(
            "price_source",
            "gold-api.com",
        ),
        "currency": "INR",
        "updated_at": data.get("updated_at"),
        "price_as_of": data.get("price_as_of"),

        "gold": {
            "spot_per_gram": round(
                gold_gram_inr,
                2,
            ),
        },

        "silver": {
            "spot_per_gram": round(
                silver_gram_inr,
                2,
            ),
            "spot_per_kg": round(
                silver_gram_inr * 1000,
                2,
            ),
        },
    }
