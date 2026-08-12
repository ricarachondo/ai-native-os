#!/usr/bin/env python3
"""parse_pkpass.py — inspect an Apple Wallet .pkpass (it's a zip).
Usage: python parse_pkpass.py path/to/file.pkpass
Prints pass.json (minus image bulk), barcode format, and flags dev leftovers
(placeholder webServiceURL, stray/attributed values) which are real findings."""
import json, sys, zipfile

def main(path):
    with zipfile.ZipFile(path) as z:
        names = z.namelist()
        with z.open('pass.json') as f:
            d = json.load(f)
    core = {k: v for k, v in d.items() if k not in ('barcodes', 'barcode')}
    print("files:", names)
    print(json.dumps(core, indent=1)[:2000])
    bc = (d.get('barcodes') or [{}])[0]
    print("barcode format:", bc.get('format'))
    # leftovers / smells
    smells = []
    ws = d.get('webServiceURL', '')
    if 'example.com' in ws or not ws:
        smells.append(f"webServiceURL placeholder/empty -> passes won't update remotely ({ws!r})")
    blob = json.dumps(d)
    for junk in ('"hello"', 'test', 'TODO', 'lorem'):
        if junk in blob:
            smells.append(f"possible dev leftover: {junk}")
    print("smells:", smells or "none")

if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else 'apple-wallet-ticket.pkpass')
