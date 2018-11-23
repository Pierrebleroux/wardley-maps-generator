import json
from asyncio import sleep
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
        #self.url = 'http://visjs.org/examples/network/basicUsage.html'


        if self.url != await self.browser.url():
            await self.browser.open(self.url)

    @sync
    async def api_visjs(self, method, params = {}):
        js_code = 'api_visjs.{0}({1})'.format(method, json.dumps(params))
        await self.browser.sleep(200)
        return await self.browser.js_eval(js_code)



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


    def test_add_node(self):
        node = {"id": 'id_new_node', "label": "an label"}
        self.api_visjs('remove_node', node['id'])
        self.api_visjs('add_node', node)
        assert self.api_visjs('nodes')['id_new_node'] == node
        self.api_visjs('remove_node', node['id'])

    def test_add_node(self):
        node_1 = {"id": 'id_new_node_1', "label": "an label 1"}
        node_2 = {"id": 'id_new_node_2', "label": "an label 2"}
        self.api_visjs('remove_node', node_1['id']) ; self.api_visjs('add_node'   , node_1)
        self.api_visjs('remove_node', node_2['id']) ; self.api_visjs('add_node'   , node_2)

        assert self.api_visjs('nodes')['id_new_node_1'] == node_1
        assert self.api_visjs('nodes')['id_new_node_2'] == node_2

        self.api_visjs('add_edge',{"from": node_1['id'], 'to': node_2['id']})

        self.api_visjs('remove_node', node_1['id'])
        self.api_visjs('remove_node', node_2['id'])

    def test_edges(self):
        edges = self.api_visjs('edges')
        edge = list(edges.values())[0]
        assert edge['from'] == 1
        assert edge['to'  ] == 3
        #assert nodes['1'] == {'id': 1, 'label': 'Node 1', 'shape': 'box'}

    def test_nodes(self):
        nodes = self.api_visjs('nodes')
        assert nodes['1'] == {'id': 1, 'label': 'Node 1', 'shape': 'box'}






