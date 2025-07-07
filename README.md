# 🏠☠️ Home Alone: Exposing My Home Server to the Internet (and Judgment) with FRP + Jenkins + Bash

TL;DR:

I turned my home server into a publicly available chaos machine by automating FRP tunnels from Jenkins… running on a remote VPS… like some kind of over-caffeinated Bond villain.

After all, who doesn't want to broadcast their cat cam to friends?

## 💡 The Setup (a.k.a. the Overkill Stack)

- 🧠 Home Server (Worker Jenkins Node) on private network - Raspberry Pi, old laptop, toaster with Linux - whatever you have.
- 🌍 VPS (Main Jenkins Node) - Runs Jenkins jobs to control FRP clients.
- 🚇 FRP (Fast Reverse Proxy) - An open-source alternative to Ngrok.
- 🤖 Jenkins - Because we like suffering, but reproducible.

## 🌟 Goal

From Jenkins (already connected to the home server via a build agent), we want to:

1. Spin up secure FRP tunnels that expose ports from the home server.
2. Use Jenkins jobs like a dashboard - "Expose internal port 3000 as port 1000 externally on VPS", "Shut it down", etc.
3. Avoid manual interaction unless something literally catches fire.

## 🛠️ Use Cases (Excuses to Build This)

- 💻 Show off local dev apps to clients/friends
- 📦 Share self-hosted dashboards (Grafana, Prometheus, whatever)
- 🎥 Let your dog cam stream to the world
- ⛔ Temporarily expose private tools during demos

## How It Works

- FRP server runs on your VPS
- FRP client lives on your home server
- Jenkins jobs (run on a connected build agent) generate config files + launch tunnels

## Scripts:

- frp-server-up.sh
- frp-server-down.sh
- frp-client-up.sh
- frp-client-down.sh
