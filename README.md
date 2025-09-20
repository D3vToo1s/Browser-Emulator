## Chromium Emulator 🖥️🌐

This project runs Chromium 98 inside a lightweight desktop environment (LXDE) in your container.
It uses VNC + noVNC to give you a full browser interface accessible from your web browser.

## 🚀 Features

Chromium v98 (most compatible with older automation/emulation tooling).

Runs inside LXDE desktop environment.

VNC server + noVNC (HTML5 client) for browser access.

Managed with supervisord (auto-restarts services if they crash).

## 📦 Installation

Run the install script once to set up everything:

chmod +x install.sh startup.sh
./install.sh

## ▶️ Usage

Start the environment with:

./startup.sh


Then open in your browser:

http://127.0.0.1:6080/vnc.html


You’ll see the LXDE desktop running Chromium.

## ⚙️ Files

install.sh → Installs Chromium, LXDE, VNC, noVNC, supervisord, and generates supervisord.conf.

startup.sh → Cleans up old VNC sessions and starts everything via supervisord.

supervisord.conf → Auto-generated config that runs:

VNC server (tigervnc)

LXDE desktop

noVNC web client

Chromium 98

## 🛠️ Notes

Chromium runs with --no-sandbox --disable-dev-shm-usage --disable-gpu for container compatibility.

By default, VNC runs on :1 → port 5901.

noVNC is served at port 6080.
