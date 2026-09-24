# hologrom

**Made by Medhansh.** Tony Stark–style holograms you move with your bare hands.

**Live demo:** https://medhu0505.github.io/hologrom/ (Chrome, allow the camera)

hologrom turns your webcam into a hand-tracked interface: notes, images and 3D models float over your camera as glass cards. You pinch them, throw them, stretch them, force-pull them across the room, and blow a model apart into its exploded view with a drag of two fingers. No headset, no controllers, no gloves.

## Run it locally (full version)

```
git clone https://github.com/medhu0505/hologrom
cd hologrom
python server.py
```

Open **http://127.0.0.1:8794/stage.html** in Chrome and allow the camera. On Windows you can double-click `run.bat` instead (port 8795). The server is stdlib Python; hand tracking (Google MediaPipe) and 3D (three.js) load from CDNs on first run.

The live demo is a static build: gestures, notes and props all work, but the AI hooks (the ring's live state, `bin/board.sh` commands, the OBS render page) need the local server.

## Give it your notes

The notes orb is just a folder of markdown, so an Obsidian vault works as-is. Point orbs at folders in `barehands.json`:

```json
{
  "name": "Assistant",
  "orbs": [
    { "title": "Notes", "path": "~/MyVault", "kind": "notes" },
    { "title": "Props", "path": "media",     "kind": "media" }
  ]
}
```

Drop images in `media/misc/`, transparent props in `media/fx/`, 3D models in `media/models/`, or in `media/holo/` for a blue hologram wireframe. Only files inside `media/` can ever appear on the board.

## Wire in your AI

- **The ring is a face.** Write `idle` / `listening` / `thinking` / `speaking` to `state/state` and the ring reacts.
- **The board is a stage.** `bin/board.sh '{"a":"present","title":"THE PLAN","body":"..."}'` flies a card center stage. `add_card`, `add_img`, `hand`, `explode`, `yank`, `hover` stage the rest; the server enforces an action allowlist and the media jail. `bin/board-state.sh` prints what's on the board.

Full setup walkthrough: [barehands.md](barehands.md).

## The gestures

Tap (quick pinch) opens and closes. Pinch-drag moves. Hold still while carrying to rotate in 3D. Two hands scale. Flick to throw. **Clap** (palms together, fingers up) brings the ring center stage. **The claw**: flash your hand open, claw, aim at something across the screen, let it strain for two seconds, then snap shut and it flies into your hand. An empty pinch dragged sideways scrubs a 3D model's exploded view.

Keys: `R` respawn, `C` switch camera, `D` debug overlay, `P` pose sampler. If a gesture misfires for your hand, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## Streaming / recording

`stage.html?role=render` is a transparent mirror of the tracker page for an OBS browser source. `&cursors=0` hides the finger rings, `&ss=2` renders at 2×, `?portrait=1` flips to 9:16, `?res=1280x720` rescues slow machines.

## What's new in this edition

- Stable hand identity: two hands no longer swap cursors, and a hand leaving the frame no longer steals the other hand's item.
- A one- or two-frame tracking dropout no longer drops what you're holding.
- A hand's first pinch registers immediately (no false "too fast" read).
- Switching cameras can no longer freeze the tracker.
- Static-host mode + GitHub Pages deploy (`build_static.py`, `.github/workflows/pages.yml`).

## Credits & license

Made by **Medhansh**, built on [barehands](https://github.com/jaredrhod/barehands) by Jared Rhodenizer. Hand tracking by [Google MediaPipe](https://developers.google.com/mediapipe) (Apache 2.0); 3D by [three.js](https://threejs.org) (MIT), both loaded from public CDNs.

Original work Copyright (c) 2026 Jared Rhodenizer. Modifications Copyright (c) 2026 Medhansh. Licensed under the GNU Affero General Public License, version 3 or later (AGPL-3.0-or-later); see [LICENSE](LICENSE).
