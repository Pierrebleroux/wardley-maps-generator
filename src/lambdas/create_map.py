import asyncio
import base64
import json
import os
import subprocess
import urllib
from distutils.dir_util import copy_tree
from time import sleep

from utils.Dev import Dev
from utils.Files import Files
from utils.Process import Process
from utils.aws.Lambdas import load_dependency

path_headless_shell          = '/tmp/lambdas-dependencies/pyppeteer/headless_shell'     # path to headless_shell AWS Linux executable
path_page_screenshot         = '/tmp/screenshot.png'                                    # path to store screenshot of url loaded
os.environ['PYPPETEER_HOME'] = '/tmp'                                                   # tell pyppeteer to use this read-write path in Lambda aws
target_url                   = 'http://localhost:1234/map/simple'
web_root                     = '/tmp/html'

def open_browser_and_take_screenshot():

    load_dependency('pyppeteer')

    async def take_screenshot():
        from pyppeteer import launch                                                        # import pyppeteer dependency
        Process.run("chmod", ['+x', path_headless_shell])                                   # set the privs of path_headless_shell to execute
        browser = await launch(executablePath = path_headless_shell,                        # lauch chrome (i.e. headless_shell)
                               args = ['--no-sandbox','--single-process'])                  # two key settings or the requests will not work

        page = await browser.newPage()                                                      # typical pyppeteer code, where we create a new Page object
        await page.goto(target_url)                                                         #   - open an url

        #await page.waitFor(2 * 1000);

        await page.screenshot({'path': path_page_screenshot, 'fullPage': True})             # - take a screenshot of the page loaded and save it
        #await page.pdf({'path': path_page_screenshot});
        await browser.close()

    asyncio.get_event_loop().run_until_complete(take_screenshot())

def get_file_data():
    return base64.b64encode(open(path_page_screenshot, 'rb').read()).decode()
    with open(path_page_screenshot, "rb") as image_file:                                    # open path_page_screenshot file
        encoded_png =  base64.b64encode(image_file.read()).decode()                         # save it as a png string (base64 encoded to make it easier to return)
    return encoded_png
    #return { "base64_data" : encoded_png}                                                   # return value to Lambda caller

def get_page_html():
    load_dependency('requests')   ; import requests
    return requests.get(target_url).text     # 'http://localhost:1234/map/'

def setup_tmp_web_root(payload):
    copy_tree('./html', web_root)
    cs_map_1 = web_root + '/coffee/map-1.coffee'
    if payload.get('coffee_script_code'):
        cs_code = payload.get('coffee_script_code')
        Files.write(cs_map_1, cs_code)

    if payload.get("queryStringParameters") and payload.get("queryStringParameters").get('code'):
        cs_code = payload.get("queryStringParameters").get('code')
        Files.write(cs_map_1, cs_code)
    return Files.contents(cs_map_1)

def run(event, context):

    setup_tmp_web_root(event)
    print('---------')
    Dev.pprint(event.get('queryStringParameters').get('code'))
    #Dev.pprint(urllib.parse.unquote(event.get('queryStringParameters')))


    proc = subprocess.Popen(["python", "-m", "http.server", "1234"], cwd=web_root, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    open_browser_and_take_screenshot()
    proc.kill()

    base64_data = get_file_data()

    return  {   'isBase64Encoded': True,
                'statusCode'     : 200,
                'headers'        : {'Content-Type': 'image/png'},
                'body'           : base64_data } #base64_encoded_binary_data}
    return {
        'statusCode': 200,
        'body': base64_data
    }




    #return html