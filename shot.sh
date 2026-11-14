#!/bin/bash
# Loads index.html in headless Chrome with live weather data and prints what
# the page worked out. Usage: ./shot.sh [query]   e.g. ./shot.sh '?demo'
# Also saves a phone-size screenshot next to this script as phone.png.
S="$(cd "$(dirname "$0")" && pwd)"
D=/mnt/c/Users/Roger/Desktop/_db_shot
CHROME="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
rm -rf $D; mkdir $D && cp "$S/index.html" $D/
cd /mnt/c
"$CHROME" --headless --disable-gpu --virtual-time-budget=40000 --dump-dom \
  "file:///C:/Users/Roger/Desktop/_db_shot/index.html$1" 2>/dev/null > $D/dom.html
python3 "$S/read_dom.py" $D/dom.html
"$CHROME" --headless --disable-gpu --hide-scrollbars --window-size=520,1800 \
  --virtual-time-budget=40000 --screenshot='C:\Users\Roger\Desktop\_db_shot\p.png' \
  "file:///C:/Users/Roger/Desktop/_db_shot/index.html$1" 2>/dev/null
cp $D/p.png "$S/phone.png"
rm -rf $D
