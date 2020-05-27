import os
import json

# https://gist.github.com/shyiko/1e622a5a490794b0457e served via https://raw.githack.com/
STYLE_URLS = ['https://gistcdn.githack.com/shyiko/1e622a5a490794b0457e/raw/59b54d624291705147a59885bad0f6a567e230c0/grip.css']

with open(os.path.join(os.path.dirname(__file__), "auth.json")) as f:
    auth = json.load(f)
    global USERNAME, PASSWORD
    USERNAME, PASSWORD = auth['USERNAME'], auth['PASSWORD']
