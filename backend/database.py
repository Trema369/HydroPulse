import sqlite3
from datetime import datetime

DB = "hydropulse.db"


def init_db():
    conn = sqlite3.connect(DB)
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ph REAL,
            temperature REAL,
            turbidity REAL,
            score INTEGER,
            overview TEXT,
            timestamp TEXT
        )
    """)

    conn.commit()
    conn.close()


def save_result(result):
    conn = sqlite3.connect(DB)
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO results (ph, temperature, turbidity, score, overview, timestamp)
        VALUES (?, ?, ?, ?, ?, ?)
    """, (
        result["ph"],
        result["temperature"],
        result["turbidity"],
        result["score"],
        result["overview"],
        datetime.now().isoformat()
    ))

    conn.commit()
    conn.close()
