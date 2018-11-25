import asyncio
import base64
import os
import subprocess
from time import sleep

from utils.Process import Process
from utils.aws.Lambdas import load_dependency


def run(event, context):
    load_dependency('pyppeteer')

    path_headless_shell          = '/tmp/lambdas-dependencies/pyppeteer/headless_shell'     # path to headless_shell AWS Linux executable
    path_page_screenshot         = '/tmp/screenshot.png'                                    # path to store screenshot of url loaded
    os.environ['PYPPETEER_HOME'] = '/tmp'                                                   # tell pyppeteer to use this read-write path in Lambda aws

    web_root =  './html'

    proc = subprocess.Popen(["python", "-m", "http.server", "1234"], cwd=web_root, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    sleep(0.5)

    target_url = 'http://localhost:1234/map/simple'

    async def take_screenshot():
        from pyppeteer import launch                                                        # import pyppeteer dependency
        Process.run("chmod", ['+x', path_headless_shell])                                   # set the privs of path_headless_shell to execute
        browser = await launch(executablePath = path_headless_shell,                        # lauch chrome (i.e. headless_shell)
                               args = ['--no-sandbox','--single-process'])                  # two key settings or the requests will not work

        page = await browser.newPage()                                                      # typical pyppeteer code, where we create a new Page object
        await page.goto(target_url)                                                         #   - open an url

        await page.waitFor(2 * 1000);

        #await page.screenshot({'path': path_page_screenshot})                               # - take a screenshot of the page loaded and save it
        await page.pdf({'path': path_page_screenshot});
        await browser.close()

    asyncio.get_event_loop().run_until_complete(take_screenshot())
    proc.kill()

    with open(path_page_screenshot, "rb") as image_file:                                    # open path_page_screenshot file
        encoded_png =  base64.b64encode(image_file.read()).decode()                         # save it as a png string (base64 encoded to make it easier to return)

    return { "base64_data" : encoded_png}                                                   # return value to Lambda caller

    #return proc.stderr.read().decode()