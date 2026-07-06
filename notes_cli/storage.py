"""JSON-file storage for notes_cli. Deliberately simple — one file, no DB."""
import json
from pathlib import Path

NOTES_FILE = Path("notes.json")


def _load():
    if not NOTES_FILE.exists():
        return []
    text = NOTES_FILE.read_text().strip()
    if not text:
        return []
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        return []


def _save(notes):
    NOTES_FILE.write_text(json.dumps(notes, indent=2))


def add_note(text):
    notes = _load()
    note = {"id": (notes[-1]["id"] + 1) if notes else 1, "text": text, "done": False}
    notes.append(note)
    _save(notes)
    return note


def list_notes():
    return _load()


def complete_note(note_id):
    notes = _load()
    for note in notes:
        if note["id"] == note_id:
            note["done"] = True
            _save(notes)
            return True
    return False
