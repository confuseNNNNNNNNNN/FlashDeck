import sqlite3
import json
from pathlib import Path
from spaced_repetition import calculate_review

class DatabaseManager:
    def __init__(self):
        # On iOS, we write to Documents. On PC/Sim, this defaults to user home.
        self.db_path = Path.home() / "Documents" / "app_database.db"

    def _get_conn(self):
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row # Access columns by name
        return conn

    def get_decks(self):
        with self._get_conn() as conn:
            rows = conn.execute("SELECT * FROM decks").fetchall()
            return [dict(row) for row in rows]

    def get_due_cards(self, deck_id: int):
        with self._get_conn() as conn:
            # Select cards where next_review is in the past (or now)
            cursor = conn.execute("""
                SELECT * FROM cards 
                WHERE deck_id = ? AND next_review <= datetime('now')
                LIMIT 20
            """, (deck_id,))
            return [dict(row) for row in cursor.fetchall()]

    def add_card(self, payload: dict):
        with self._get_conn() as conn:
            conn.execute("""
                INSERT INTO cards (deck_id, front, back, extra_data)
                VALUES (?, ?, ?, ?)
            """, (payload['deck_id'], payload['front'], payload['back'], json.dumps(payload['extra_data'])))
            conn.commit()

    def process_review(self, card_id: int, quality: int):
        with self._get_conn() as conn:
            # 1. Fetch current stats
            row = conn.execute("SELECT interval, ease_factor FROM cards WHERE id = ?", (card_id,)).fetchone()
            if not row: return

            # 2. Calculate new stats
            new_int, new_ease, next_rev = calculate_review(quality, row['interval'], row['ease_factor'])

            # 3. Update DB
            conn.execute("""
                UPDATE cards 
                SET interval = ?, ease_factor = ?, next_review = ? 
                WHERE id = ?
            """, (new_int, new_ease, next_rev, card_id))
            conn.commit()