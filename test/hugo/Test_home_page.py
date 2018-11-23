from unittest import TestCase

from pyquery import PyQuery
import requests

from utils.Dev import Dev


class Test_home_page(TestCase):
    def setUp(self):
        self.base_url = "http://127.0.0.1:1313/"

    def test_home_page(self):
        html = requests.get(self.base_url).text
        q = PyQuery(html)

        assert q("title").text() == 'Wardley Maps Creator'
        q('h1').html()           == 'Wardley Maps Creator'


