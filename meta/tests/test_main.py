import unittest
from unittest.mock import patch

from meta import main, get_sha256
from hashlib import sha256

class TestMain(unittest.TestCase):
    def test_sha256(self):
        unencodedString = "teststring123"
        assert sha256(unencodedString.encode()).hexdigest() == get_sha256(unencodedString)

    @patch('builtins.input', side_effect=["Lorem ipsum dolor sit amet"])
    @patch('builtins.print')
    def test_main_print(self, mock_print, mock_input):
        main()
        mock_print.assert_any_call("16aba5393ad72c0041f5600ad3c2c52ec437a2f0c7fc08fadfc3c0fe9641d7a3")


if __name__ == "__main__":
    unittest.main()
