from unittest import TestCase

from syncer import sync

from browser.API_Browser import API_Browser
from utils.Dev import Dev


class Test_VisJs(TestCase):
    @sync
    async def setUp(self):
        self.browser = API_Browser()
        #await self.browser.browser_connect(None, False)
        self.url = 'http://localhost:1313/visjs/just-visjs/'
        if self.url != await self.browser.url():
            await self.browser.open(self.url)


    #@sync
    #async def tearDown(self):
    #    await self.browser.screenshot()
    #    #await self.browser.browser_close()

    @sync
    async def test_api_visjs(self):
        #url = 'http://localhost:1313/visjs/just-visjs'
        #await page.setViewport({ "width": 10, "height": 200, "isMobile": True })
        #await self.browser.screenshot(url)

        #await self.browser.open(self.url)
        nodes = await self.browser.js_eval("api_visjs")
        Dev.pprint(nodes['answer'] == 42)

        # #await self.browser.js_eval("network.body.data.nodes.add({'id': 'aaaa','label':'bbbb'})")
        # await self.browser.js_eval("network.body.data.edges.add({'from': 'aaaa','to':'1'})")
        # await self.browser.js_eval("network.body.data.edges.add({'from': 'aaaa','to':'2'})")
        # await self.browser.js_eval("network.body.data.edges.add({'from': 'aaaa','to':'3'})")
        # await self.browser.js_eval("network.body.data.edges.add({'from': 'aaaa','to':'5'})")

    @sync
    async def nodes(self):
        return await self.browser.js_eval("nodes")


    def test_nodes(self):
        nodes = self.nodes()
        Dev.pprint(nodes)






