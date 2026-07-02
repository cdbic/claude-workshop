"""Tiny local notes CLI — demo project for the Claude workshop."""
import argparse
import sys

from notes_cli.storage import add_note, complete_note, list_notes


def main(argv=None):
    parser = argparse.ArgumentParser(prog="notes", description="A tiny notes CLI")
    sub = parser.add_subparsers(dest="command", required=True)

    add_p = sub.add_parser("add", help="Add a note")
    add_p.add_argument("text", help="Note text")

    sub.add_parser("list", help="List all notes")

    done_p = sub.add_parser("done", help="Mark a note as done")
    done_p.add_argument("note_id", type=int, help="Note id")

    args = parser.parse_args(argv)

    if args.command == "add":
        note = add_note(args.text)
        print(f"Added note #{note['id']}: {note['text']}")
    elif args.command == "list":
        notes = list_notes()
        if not notes:
            print("No notes yet.")
        for note in notes:
            status = "x" if note["done"] else " "
            print(f"[{status}] #{note['id']} {note['text']}")
    elif args.command == "done":
        if complete_note(args.note_id):
            print(f"Marked #{args.note_id} as done.")
        else:
            print(f"No note with id {args.note_id}", file=sys.stderr)
            return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
