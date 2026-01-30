# Hytale Windows Offline Archive Builder

This repository contains an **automated GitHub Actions workflow** that downloads, builds, and packages the **official Hytale Windows client** into an **offline-ready archive**.

The project exists **purely for archival and preservation purposes**.
It uses **publicly accessible, official Hytale patch and runtime URLs** and does **not modify, crack, or bypass** the game in any way.

---

## 📌 What This Project Does

* Automatically checks for new Hytale Windows client versions
* Downloads the **official game patch** from public servers
* Applies the patch using the official **Butler** tool
* Bundles the **official Java Runtime Environment**
* Packages everything into a Windows-ready archive
* Publishes the build as a GitHub Release

The result is a **self-contained Windows build** that can be launched offline.

---

## ❗ Important Clarification (Not a Crack / Not a Hack)

This project:

* ❌ **Is NOT a crack**
* ❌ **Is NOT a hack**
* ❌ **Does NOT bypass DRM or authentication**
* ❌ **Does NOT modify game binaries**

Instead, it:

* ✅ Downloads game patches from **official, publicly accessible URLs**
* ✅ Uses **unmodified game data**
* ✅ Bundles an official Java runtime
* ✅ Runs the client in **offline mode only**

All download links used by this project are **publicly reachable** and require **no authentication**.

---

## 🪟 Using the Windows Build

After downloading and extracting a release archive:

```
Hytale/
├── game/
│   ├── data/
│   └── jre/
├── UserData/
└── start.bat
```

### Launching the Game

Double-click:

```
start.bat
```

Optional arguments:

```
start.bat PlayerName UUID
```

Example:

```
start.bat MyName 00000000-0000-0000-0000-000000000000
```

The game runs **offline**, using a bundled Java runtime, with all user data stored locally.

---

## 🎯 Purpose

This project is intended for:

* Archival and preservation
* Offline testing
* Historical version tracking
* Automation and CI experimentation

It is **not intended for online play or account access**.

---

## ⚠️ Disclaimer

* This project is **not affiliated with Hypixel Studios**
* All trademarks and game assets belong to their respective owners
* Use of this project should comply with the game’s terms of service
