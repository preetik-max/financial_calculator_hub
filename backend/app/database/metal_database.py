import sqlite3
from pathlib import Path
from typing import List, Dict, Any


DATABASE_PATH = (
    Path(__file__).resolve().parent / "metals.db"
)


def get_connection() -> sqlite3.Connection:
    connection = sqlite3.connect(
        str(DATABASE_PATH)
    )

    connection.row_factory = sqlite3.Row

    return connection


def initialize_database() -> None:
    connection = get_connection()

    try:
        connection.execute(
            """
            CREATE TABLE IF NOT EXISTS metal_prices (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                metal TEXT NOT NULL,
                timestamp TEXT NOT NULL,
                price_inr REAL NOT NULL
            )
            """
        )

        connection.execute(
            """
            CREATE INDEX IF NOT EXISTS
            idx_metal_prices_metal_timestamp
            ON metal_prices (
                metal,
                timestamp
            )
            """
        )

        # Prevent duplicate observations for the same
        # metal and timestamp.
        connection.execute(
            """
            CREATE UNIQUE INDEX IF NOT EXISTS
            idx_unique_metal_timestamp
            ON metal_prices (
                metal,
                timestamp
            )
            """
        )

        connection.commit()

    finally:
        connection.close()


def save_metal_price(
    metal: str,
    timestamp: str,
    price_inr: float,
) -> None:

    connection = get_connection()

    try:
        connection.execute(
            """
            INSERT OR IGNORE INTO metal_prices (
                metal,
                timestamp,
                price_inr
            )
            VALUES (?, ?, ?)
            """,
            (
                metal,
                timestamp,
                price_inr,
            ),
        )

        connection.commit()

    finally:
        connection.close()


def get_metal_prices(
    metal: str,
    start_timestamp: str,
) -> List[Dict[str, Any]]:

    connection = get_connection()

    try:
        rows = connection.execute(
            """
            SELECT
                id,
                metal,
                timestamp,
                price_inr
            FROM metal_prices
            WHERE metal = ?
              AND timestamp >= ?
            ORDER BY timestamp ASC
            """,
            (
                metal,
                start_timestamp,
            ),
        ).fetchall()

        return [
            dict(row)
            for row in rows
        ]

    finally:
        connection.close()