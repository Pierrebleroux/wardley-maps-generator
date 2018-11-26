import base64
import subprocess
from distutils.dir_util import copy_tree
from unittest import TestCase

import requests
from syncer import sync

from browser.API_Browser import API_Browser
from utils.Dev import Dev
from utils.Files import Files
from utils.Show_Img import Show_Img
from utils.aws.Lambdas import Lambdas


class Test_lambda_create_map(TestCase):
    def setUp(self):
        self.src_tmp            = '/tmp/src_create_map'
        self.folder_src_lambdas = Files.path_combine(__file__, '../../../src/lambdas')
        self.folder_src_hugo    = Files.path_combine(__file__, '../../../src/hugo')

    def zip_update_invoke(self, payload = {}):
        self.copy_html_files()
        _lambda = Lambdas('create_map', 'create_map.run',memory = 3008).delete().create()
        copy_tree(_lambda.source         , self.src_tmp)
        copy_tree(self.folder_src_lambdas, self.src_tmp)
        _lambda.source = self.src_tmp
        return _lambda.update().invoke(payload)

    def just_invoke(self, payload):
        _lambda = Lambdas('create_map', 'create_map.run')
        return _lambda.invoke(payload)

    def copy_html_files(self):
        html_file = self.folder_src_hugo + '/layouts/visjs/simple.html'
        vis_js = self.folder_src_hugo + '/static/js/visjs/vis.js'
        cs_compiler = self.folder_src_hugo + '/static/js/repl/browser-compiler-coffeescript.js'
        cs_vis_js = self.folder_src_hugo + '/static/coffee/api-visjs.coffee'
        cs_map_1 = self.folder_src_hugo + '/static/coffee/map-1.coffee'
        Files.copy(html_file, self.src_tmp + '/html/map/simple/index.html')
        Files.copy(vis_js       , self.src_tmp + '/html/js/visjs/vis.js')
        Files.copy(cs_compiler  , self.src_tmp + '/html/js/repl/browser-compiler-coffeescript.js')
        Files.copy(cs_vis_js    , self.src_tmp + '/html/coffee/api-visjs.coffee')
        Files.copy(cs_map_1     , self.src_tmp + '/html/coffee/map-1.coffee')


    def save_image(self, result, png_file):
        png_data = result.get('base64_data')
        if (png_data):
            with open(png_file, "wb") as fh:
                fh.write(base64.decodebytes(png_data.encode()))
            Dev.pprint('Image saved to {0}'.format(png_file))
        else:
            Dev.pprint(result)

    def test_invoke(self):
        #result = self.zip_update_invoke()
        result = self.just_invoke()
        #Show_Img.from_png_string(result['base64_data'])
        pdf_data = result['base64_data']
        # Dev.pprint(len(pdf_data))
        with open('./lambda-result.pdf', "wb") as fh:
            fh.write(base64.decodebytes(pdf_data.encode()))

    def test_invoke_using_map_as_param(self):
        cs_map_2 = self.folder_src_hugo + '/static/coffee/map-2.coffee'
        payload = { 'coffee_script_code' : Files.contents(cs_map_2) }
        #result  = self.zip_update_invoke(payload)
        result = self.just_invoke(payload)

        self.save_image(result, './lambda-result.png')

    @sync
    async def take_screenshot(self):
        (_, _, _, browser) = await API_Browser().open('http://localhost:1234/map/simple')
        return await browser.screenshot()

    def test_create_local_server_and_take_screenshot(self):
        Files.folder_delete_all(self.src_tmp)
        self.copy_html_files()

        web_root = self.src_tmp + '/html'
        proc = subprocess.Popen(["python","-m", "SimpleHTTPServer","1234"], cwd = web_root)
        Dev.pprint(proc)
        self.take_screenshot()
        html =  requests.get('http://localhost:1234/map/').text
        proc.kill()
        Dev.pprint(html)