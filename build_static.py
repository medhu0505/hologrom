#!/usr/bin/env python3
# barehands (Medhansh's edition) — static snapshot builder.
# Based on barehands, Copyright (C) 2026 Jared Rhodenizer.
# Modifications Copyright (C) 2026 Medhansh.
# SPDX-License-Identifier: AGPL-3.0-or-later
"""Snapshot the server's read-only endpoints into ./static/ so the board
runs on a plain static host (GitHub Pages) with no Python behind it.

  static/config.json      = GET /config
  static/tree-<N>.json    = GET /tree?orb=N
  static/props.json       = GET /props
  static/notes/<N>/<rel>  = GET /note?f=<N>/<rel>

stage.html switches to these files automatically when it isn't served
from localhost. The live-only channels (/state, /cmd, /orb) have no
static form: on a static host the ring idles and your AI can't drive it.
"""
import json
import shutil

import server

OUT = server.HERE / "static"


def main():
    if OUT.exists():
        shutil.rmtree(OUT)
    (OUT / "notes").mkdir(parents=True)
    cfg = server.public_config()
    (OUT / "config.json").write_text(json.dumps(cfg))
    for i, orb in enumerate(cfg["orbs"]):
        if orb["kind"] != "notes":
            continue
        tree, _ = server.notes_tree(i)
        (OUT / f"tree-{i}.json").write_text(json.dumps(tree))
        root = server.orb_root(i)

        def copy(t):
            for n in t["notes"]:
                rel = n["file"].split("/", 1)[1]
                dst = OUT / "notes" / str(i) / rel
                dst.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(root / rel, dst)
            for d in t["dirs"]:
                copy(d)
        copy(tree)
    props, _ = server.props_tree()
    (OUT / "props.json").write_text(json.dumps(props))
    print(f"static snapshot written to {OUT}")


if __name__ == "__main__":
    main()
