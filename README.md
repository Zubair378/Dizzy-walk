# Dizzy-walk

Dizzy Walk – A 2D maze adventure simulation in x86 Assembly (MASM32). Features automated/keyboard-controlled pathfinding, obstacle collision, coin collection, and comprehensive file-based audit logging.

## 🖼️ Game Screenshots

*(Upload your screenshots named `screenshot1.png` and `screenshot2.png` to the repository to display them here!)*

![Screenshot 1](screenshot1.png)
![Screenshot 2](screenshot2.png)

## 🚀 Setup & Installation (Irvine32)

This project requires the **Irvine32 Library** and **MASM** (Microsoft Macro Assembler) via Visual Studio.

1. **Install Visual Studio**: Make sure you have C++ Desktop Development (containing MASM toolset) installed.
2. **Download Irvine32**: Download the Irvine32 library from standard resources (e.g., `Irvine_7th_Edition`).
3. **Configure Irvine32 Path**: Extract the library (commonly into `C:\Irvine`).
4. **Include & Link Paths**:
   * Open the `.slnx` / `.vcxproj` project file in Visual Studio.
   * Go to **Project Properties -> Linker -> General -> Additional Library Directories** and add `C:\Irvine`.
   * Go to **Project Properties -> Microsoft Macro Assembler -> General -> Include Paths** and add `C:\Irvine`.
5. **Additional Dependencies**: The game includes `GraphWin.inc` and links native Windows libraries (`user32.lib`, `kernel32.lib`, `gdi32.lib`, `winmm.lib`), which are included by default in the Windows SDK.

### Compilation / Build

1. Open `Project.slnx`.
2. Build the project using **Ctrl + Shift + B** in Visual Studio.
3. Run the compiled `.exe`. The game will automatically log your session status into `adventure_log.txt` generated next to the executable.

---

### 🎯 Core Gameplay

* **20x30 Maze Grid** — A rich obstacle course with walls, buildings, lakes, pits, coins, treasures, and keys
* **Dual Movement Modes** — Random AI-driven pathfinding or manual keyboard-controlled movement
* **Two Game Scenarios** — Step-limited mode (max 500 steps) or endless exploration mode
* **Collectibles System** — Pick up coins (+1 wallet), treasures (+5 wallet), and spare keys
* **Stumble Mechanic** — 2% chance per step of dropping the key, adding strategic tension
* **Home Door Victory** — Navigate to the destination with your key to win

### 🖥️ Technical Highlights

* **Native Win32 Window Application** — Custom `WNDCLASS`, message loop, and `WinProc` callback
* **GDI Rendering Pipeline** — 13 custom brushes, grid pen, cell-by-cell drawing with ellipse professor marker
* **Real-Time Game Loop** — 180ms timer ticks driving movement, interaction, and rendering
* **Console I/O Integration** — `AllocConsole` -> `ReadConsoleA` -> `FreeConsole` for name input
* **File I/O** — Automatic `adventure_log.txt` generation using `CreateOutputFile` / `WriteToFile`
* **Sound Effects** — Contextual audio via `MessageBeep` for coins, treasures, keys, pits, walls, and game-over
* **Comprehensive STRUCT Usage** — `Professor`, `PathEntry`, `TreasureRecord`, `Wall`, `Building`, `Lake`, `Pit`, `Coin`
* **Reusable MACROs** — `mFillCell`, `mHudText`, `mPlaySound`, `mSetColor`, `mWriteStr`, `mGotoXY`

### 📊 Heads-Up Display (HUD)

* Professor name with separator
* Live wallet counter with coin suffix
* Key status indicator (YES / LOST)
* Step counter with max limit display

### 🏗️ Architecture

```text
--------------------------------------------------
|                 ENTRY POINT                    |
|               start -> WinMain                 |
--------------------------------------------------
|   Console I/O   | | Win32 Window | | GDI Renderer |
| AllocConsole    | | RegisterClass| | CreateBrushes|
| ReadConsoleA    | | CreateWindow | | DrawMaze     |
| FreeConsole     | | Message Loop | | DrawHUD      |
|       |         | |      |       | |      |       |
|       v         | |      v       | |      v       |
--------------------------------------------------
|                GAME ENGINE                     |
|   GameTick      | | AttemptMove  | | Cell Handlers|
| Timer-based     | | Boundary     | | CheckPit     |
| 180ms loop      | | Validation   | | CheckCoin    |
| Mode check      | | Collision    | | CheckTreasure|
| Step count      | | Detection    | | CheckDestination|
| Stumble         | | Cell update  | | CheckStumble |
--------------------------------------------------
|   Maze Init     | |   File I/O   | | Sound Effects|
| InitMaze        | | SaveAdventure| | PlayCoinSound|
| PlaceWall       | | WriteToFile  | | PlayPitSound |
| PlaceBuilding   | | adventure_log| | PlayKeySound |
| PlaceLake       | | .txt output  | | PlayGameOver |
| PlacePit        | |              | | PlaySuccess  |
--------------------------------------------------
```

### Data Structures (STRUCTs)

| Structure | Fields | Description |
|---|---|---|
| `PathEntry` | `entryRow`, `entryCol` | Breadcrumb trail history |
| `TreasureRecord`| `tRow`, `tCol`, `tStep` | Treasure pickup log |
| `Wall` | `wallRow`, `wallCol`, `wallLen`, `wallDir` | Wall segment definition |
| `Building` | `bldRow`, `bldCol`, `bldHeight`, `bldWidth`| Rectangular obstacle |
| `Lake` | `lakeRow`, `lakeCol`, `lakeHeight`, `lakeWidth`| Water body obstacle |
| `Pit` | `pitRow`, `pitCol` | Single-cell death hazard |

### Cell Types

| Code | Type | Color | Description |
|---|---|---|---|
| `0` | Empty | ⬜ White | Open walkable floor |
| `1` | Wall | ⬛ Dark Grey | Impassable barrier |
| `2` | Building | 🟫 Brick Red | Solid obstacle block |
| `3` | Lake | 🟦 Blue-Orange | Water body (impassable) |
| `4` | Pit | ⚫ Black | Instant death hazard |
| `5` | Coin | 🟡 Gold | +1 wallet collectible |
| `6` | Destination| 🟩 Green | Home door (victory) |
| `7` | Visited | ⬜ Light Grey| Breadcrumb trail |
| `8` | Treasure | 🟣 Purple | +5 wallet collectible |
| `9` | Key | 🔵 Cyan | Spare key pickup |

### 🎮 Controls

| Key | Action |
|---|---|
| `↑` `↓` `←` `→` | Move professor (in Keyboard mode) |
| `R` | Toggle between RANDOM and KEYBOARD mode |
| `L` | Toggle between Step-Limit (Scenario 1) and Endless (Scenario 2) mode |