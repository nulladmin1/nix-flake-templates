import unittest
from unittest.mock import patch
from hashlib import sha256

from sha256_python_with_tests.main import main, get_sha256


class TestSHA256(unittest.TestCase):
    @patch("builtins.input", side_effect=["hello"])
    @patch("builtins.print")
    def test_main(mock_print, mock_input):
        mock_print.assertIn(main(), sha256("hello".encode()).hexdigest())

    def test_get_sha256(self):
        self.assertEqual(get_sha256("hello"), sha256("hello".encode()).hexdigest())


if __name__ == "__main__":
    unittest.main()
