# Dizzy-walk

Dizzy Walk – A 2D maze adventure simulation in x86 Assembly (MASM32). Features automated/keyboard-controlled pathfinding, obstacle collision, coin collection, and comprehensive file-based audit logging.

## 🖼️ Game Screenshots

*(Upload your screenshots named `screenshot1.png` and `screenshot2.png` to the repository to display them here!)*

![Screenshot 1](screenshot1.png)
![Screenshot 2](screenshot2.png)

---

## 🔧 Build & Run

### Prerequisites

- **Visual Studio** (2019 or later) with MASM build tools
- **Irvine32 Library** (Assumes default `C:\Irvine\` installation)

### Building from Visual Studio

1. Open `Project.slnx` in Visual Studio
2. Ensure the build configuration is set to **x86 (32-bit)**
3. Build the solution (`Ctrl + Shift + B`)
4. Run (`F5` or `Ctrl + F5`)

### Manual MASM Build

```bat
ml /c /coff /Zi /I"C:\Irvine" Project\i242065_i242095_i242102_coal_project_main.asm
link /SUBSYSTEM:WINDOWS /LIBPATH:"C:\Irvine" i242065_i242095_i242102_coal_project_main.obj Irvine32.lib kernel32.lib user32.lib gdi32.lib winmm.lib
```

---

## 📁 Project Structure

```text
Dizzy-Walk/
├── 📄 README.md                          # This file
├── 📄 Project.slnx                       # Visual Studio solution file
└── 📁 Project/                           # Main game project
    ├── 📄 Project.vcxproj                # VS project configuration
    ├── 📄 Project.vcxproj.filters        # VS project filters
    └── 📄 i242065_i242095_i242102_coal_project_main.asm # Main game source code
```

---

## 📝 Adventure Log Output

After each game session, an `adventure_log.txt` file is automatically generated next to the executable:

```text
=== Dizzy Walk Adventure Log ===

Professor: Zubair
Final Wallet: 3 coins
Key Status: YES
Total Steps: 50
Ending Reason: Fell into a pit! Adventure is over.
Treasures Found: 1
Path Length Recorded: 51 steps
```

---

## 🧠 Assembly Concepts Demonstrated

This project showcases a wide range of x86 assembly language concepts:

| Category | Concepts Used |
|---|---|
| **Registers** | `EAX`, `EBX`, `ECX`, `EDX`, `ESI`, `EDI` — general purpose register manipulation |
| **Addressing** | Direct, Register Indirect `[EDI]`, Base-Index `[EDI + EAX]`, Displacement |
| **Arithmetic** | `ADD`, `SUB`, `INC`, `DEC`, `MUL`, `DIV` for game logic calculations |
| **Bitwise** | `AND` masking, `SHL` bit shifting, `CMP` logic |
| **Control Flow** | `.IF/.ELSEIF/.ELSE`, conditional jumps `JE/JNE/JL/JG`, `JMP` |
| **Stack** | `PUSH/POP` register preservation |
| **Structs** | Custom structures `STRUCT/ENDS`, size extraction via `SIZEOF` operator |
| **Macros** | Reusable `MACRO/ENDM` definitions for rendering and audio |
| **Procedures** | `PROC/ENDP`, `INVOKE`, `PROTO`, `STDCALL` convention |
| **Win32 API** | Window creation, message loop handling (`WinProc`), GDI painting routines, system timer execution |
| **Memory** | `.data` and `.data?` segments, `DUP` array definitions, `OFFSET` usage |

---

### 🎯 Core Gameplay

* **20x30 Maze Grid** — A rich obstacle course with walls, buildings, lakes, pits, coins, treasures, and keys
* **Dual Movement Modes** — Random AI-driven pathfinding or manual keyboard-controlled movement
* **Two Game Scenarios** — Step-limited mode (max 500 steps) or endless exploration mode
* **Collectibles System** — Pick up coins (+1 wallet), treasures (+5 wallet), and spare keys
* **Stumble Mechanic** — 2% chance per step of dropping the key, adding strategic tension
* **Home Door Victory** — Navigate to the destination with your key to win

### 🎮 Controls

| Key | Action |
|---|---|
| `↑` `↓` `←` `→` | Move professor (in Keyboard mode) |
| `R` | Toggle between RANDOM and KEYBOARD mode |
| `L` | Toggle between Step-Limit (Scenario 1) and Endless (Scenario 2) mode |