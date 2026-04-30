#!/bin/python3

import zlib, pathlib

raw = pathlib.Path("./payload").read_bytes()
packed = zlib.compress(raw, level=9)

print(packed.hex())
print(f"raw_len={len(raw)} packed_len={len(packed)}")
