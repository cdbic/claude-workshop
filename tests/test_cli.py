"""Smoke test for notes_cli storage. Run with: python -m unittest tests.test_cli"""
import importlib
import os
import tempfile
import unittest

from notes_cli import storage


class NotesCliTest(unittest.TestCase):
    def test_add_list_complete_roundtrip(self):
        with tempfile.TemporaryDirectory() as tmp:
            cwd = os.getcwd()
            os.chdir(tmp)
            try:
                importlib.reload(storage)  # rebind NOTES_FILE relative to tmp cwd

                note = storage.add_note("write demo notes")
                self.assertEqual(note["id"], 1)
                self.assertFalse(note["done"])

                self.assertEqual(len(storage.list_notes()), 1)

                self.assertTrue(storage.complete_note(1))
                self.assertTrue(storage.list_notes()[0]["done"])
                self.assertFalse(storage.complete_note(99))
            finally:
                os.chdir(cwd)
                importlib.reload(storage)


if __name__ == "__main__":
    unittest.main()
