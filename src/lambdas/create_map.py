
import subprocess
from time import sleep
from utils.aws.Lambdas import load_dependency


def run(event, context):
    load_dependency('requests') ;
    import requests
    web_root =  './html'

    proc = subprocess.Popen(["python", "-m", "http.server", "1234"], cwd=web_root, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    sleep(0.5)
    html = requests.get('http://localhost:1234/map/simple').text

    proc.kill()

    return html

    #return proc.stderr.read().decode()