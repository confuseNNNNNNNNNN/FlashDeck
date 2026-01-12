import sqlite3
import json
import os

# Define your starter decks
DECKS = [
    {"name": "Polish 500", "icon": "language"},
    {"name": "Engineering", "icon": "engineering"},
    {"name": "Math", "icon": "calculate"}
]

# Sample Polish Data (You would expand this list to 500)
POLISH_WORDS = [
    ("Man", "Mężczyzna", "M"), 
    ("Woman", "Kobieta", "F"), 
    ("Car", "Samochód", "M"), 
    ("Knowledge", "Wiedza", "F"),
    ("Teacher (M)", "Nauczyciel", "M"),
    ("Teacher (F)", "Nauczycielka", "F")
]

def create_seed():
    db_name = "app_database.db"
    # Clean slate
    if os.path.exists(db_name):
        os.remove(db_name)

    conn = sqlite3.connect(db_name)
    cursor = conn.cursor()
    
    # 1. Create Tables
    cursor.execute("""
        CREATE TABLE decks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE NOT NULL,
            icon TEXT
        )
    """)
    
    cursor.execute("""
        CREATE TABLE cards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            deck_id INTEGER,
            front TEXT NOT NULL,
            back TEXT NOT NULL,
            extra_data TEXT, 
            next_review TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            ease_factor REAL DEFAULT 2.5,
            interval INTEGER DEFAULT 0,
            FOREIGN KEY(deck_id) REFERENCES decks(id)
        )
    """)

    # 2. Insert Decks
    deck_map = {}
    for deck in DECKS:
        cursor.execute("INSERT INTO decks (name, icon) VALUES (?, ?)", (deck['name'], deck['icon']))
        deck_map[deck['name']] = cursor.lastrowid

    # 3. Insert Polish Words
    print("Seeding Polish Deck...")
    polish_id = deck_map["Polish 500"]
    
    for eng, pl, gender in POLISH_WORDS:
        # We store metadata as JSON string
        meta = json.dumps({"gender": gender})
        cursor.execute("""
            INSERT INTO cards (deck_id, front, back, extra_data) 
            VALUES (?, ?, ?, ?)
        """, (polish_id, eng, pl, meta))

    conn.commit()
    conn.close()
    print(f"✅ Success! '{db_name}' created. Move it to your 'assets/' folder.")

if __name__ == "__main__":
    create_seed()