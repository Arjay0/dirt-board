"""Print what the dirt board page worked out, from a saved copy of its DOM."""
import re
import sys

h = open(sys.argv[1], encoding="utf-8", errors="replace").read()
print("page finished" if "data-done" in h else "PAGE DID NOT FINISH")
print(re.search(r'id="sub">([^<]*)', h).group(1))
for card in re.findall(r'<div class="area">(.*?)(?=<div class="area">|</div><div class="legend"|<div class="legend")', h, re.S):
    name = re.search(r'class="name">([^<]*)', card).group(1)
    chips = re.findall(r'class="chip (\w+)"', card)
    closed = re.findall(r'closedline">([^<]*)', card)
    why = re.search(r'class="why">([^<]*)', card).group(1)
    tuned = re.findall(r'tuned">([^<]*)', card)
    print(f"{name:16} {' '.join(chips):22} {why}")
    for line in closed + tuned:
        print(f"{'':16} -> {line}")
for a, b in re.findall(r"<li><span>([^<]*)</span><small>([^<]*)", h):
    print("report:", a, "|", b)
print(re.search(r'id="stamp">([^<]*)', h).group(1).strip())
