; ============================================================================
; Name   : Abdul Rahim, Zubair Tariq, Tehrem Wasim.
; Roll No: i242065, i242095, i242102
; Course : Computer Organization and Assembly Language - Spring 2026
; File   : i242065_i242095_i242102_coal_project_main.asm
; Desc   : Dizzy Walk 
; ============================================================================

.386
.model flat, stdcall
option casemap:none

include Irvine32.inc
include GraphWin.inc

includelib Irvine32.lib
includelib kernel32.lib
includelib user32.lib
includelib gdi32.lib
includelib winmm.lib

; ============================================================================
; CONSTANTS (GraphWin + Irvine32)
; ============================================================================

IFNDEF CS_HREDRAW
CS_HREDRAW              EQU 0002h
ENDIF
IFNDEF CS_VREDRAW
CS_VREDRAW              EQU 0001h
ENDIF
IFNDEF CS_DBLCLKS
CS_DBLCLKS              EQU 0008h
ENDIF

IFNDEF WS_EX_APPWINDOW
WS_EX_APPWINDOW         EQU 00040000h
ENDIF

IFNDEF WM_PAINT
WM_PAINT                EQU 000Fh
ENDIF
IFNDEF WM_CREATE
WM_CREATE               EQU 0001h
ENDIF
IFNDEF WM_TIMER
WM_TIMER                EQU 0113h
ENDIF
IFNDEF WM_KEYDOWN
WM_KEYDOWN              EQU 0100h
ENDIF
IFNDEF WM_CHAR
WM_CHAR                 EQU 0102h
ENDIF
IFNDEF WM_DESTROY
WM_DESTROY              EQU 0002h
ENDIF

IFNDEF SRCCOPY
SRCCOPY                 EQU 00CC0020h
ENDIF
IFNDEF TRANSPARENT
TRANSPARENT             EQU 1
ENDIF

IFNDEF WS_OVERLAPPED
WS_OVERLAPPED       EQU 00000000h
ENDIF
IFNDEF WS_CAPTION
WS_CAPTION          EQU 00C00000h
ENDIF
IFNDEF WS_SYSMENU
WS_SYSMENU          EQU 00080000h
ENDIF
IFNDEF WS_MINIMIZEBOX
WS_MINIMIZEBOX      EQU 00020000h
ENDIF
IFNDEF WS_POPUP
WS_POPUP             EQU 80000000h
ENDIF
IFNDEF WS_VISIBLE
WS_VISIBLE           EQU 10000000h
ENDIF
IFNDEF SW_SHOW
SW_SHOW             EQU 5
ENDIF
IFNDEF IDI_APPLICATION
IDI_APPLICATION     EQU 32512
ENDIF
IFNDEF IDC_ARROW
IDC_ARROW           EQU 32512
ENDIF

IFNDEF VK_BACK
VK_BACK            EQU 08h
ENDIF
IFNDEF VK_RETURN
VK_RETURN          EQU 0Dh
ENDIF

IFNDEF SM_CXSCREEN
SM_CXSCREEN          EQU 0
ENDIF
IFNDEF SM_CYSCREEN
SM_CYSCREEN          EQU 1
ENDIF

IFNDEF FW_BOLD
FW_BOLD              EQU 700
ENDIF
IFNDEF ANSI_CHARSET
ANSI_CHARSET         EQU 0
ENDIF
IFNDEF OUT_DEFAULT_PRECIS
OUT_DEFAULT_PRECIS   EQU 0
ENDIF
IFNDEF CLIP_DEFAULT_PRECIS
CLIP_DEFAULT_PRECIS  EQU 0
ENDIF
IFNDEF DEFAULT_QUALITY
DEFAULT_QUALITY      EQU 0
ENDIF
IFNDEF DEFAULT_PITCH
DEFAULT_PITCH        EQU 0
ENDIF
IFNDEF FF_DONTCARE
FF_DONTCARE          EQU 0
ENDIF

IFNDEF TA_LEFT
TA_LEFT             EQU 0
ENDIF
IFNDEF TA_CENTER
TA_CENTER           EQU 6
ENDIF

ID_TIMER                EQU 1
ID_MENU_TIMER           EQU 2

MAZE_ROWS               EQU 100
MAZE_COLS               EQU 150
MAZE_SIZE               EQU MAZE_ROWS * MAZE_COLS
CELL_SIZE               EQU 7
HUD_WIDTH               EQU 220
STATUS_HEIGHT           EQU 60
WIN_WIDTH               EQU (MAZE_COLS * CELL_SIZE) + HUD_WIDTH
WIN_HEIGHT              EQU (MAZE_ROWS * CELL_SIZE) + STATUS_HEIGHT

PANEL_WIDTH             EQU 720
PANEL_HEIGHT            EQU 460
NAME_BUF_LEN            EQU 64
NAME_MAX                EQU 20
MENU_FONT_HEIGHT        EQU -54
UI_FONT_HEIGHT          EQU -20

CELL_EMPTY              EQU 0
CELL_WALL               EQU 1
CELL_BUILDING           EQU 2
CELL_LAKE               EQU 3
CELL_PIT                EQU 4
CELL_COIN               EQU 5
CELL_TREASURE           EQU 6
CELL_DEST               EQU 7
CELL_START              EQU 8
CELL_VISITED            EQU 9
CELL_TRAP               EQU 10

DIR_UP                  EQU 0
DIR_DOWN                EQU 1
DIR_LEFT                EQU 2
DIR_RIGHT               EQU 3

MODE_RANDOM             EQU 0
MODE_KEYBOARD           EQU 1

STATE_MENU              EQU 0
STATE_PLAYING           EQU 1
STATE_OVER              EQU 2
STATE_HISTORY           EQU 3
STATE_NAME              EQU 4
STATE_MODE              EQU 5

MAX_STEPS               EQU 1000
MAX_TREASURES           EQU 25
COIN_COUNT              EQU 60
TREASURE_COUNT          EQU 18
PIT_COUNT               EQU 12
TRAP_COUNT              EQU 14
STUMBLE_CHANCE          EQU 0
TRAP_KEY_CHANCE         EQU 50

HISTORY_MAX             EQU 10
HISTORY_LINE_LEN        EQU 64

TERM_PIT                EQU 1
TERM_DEST_KEY           EQU 2
TERM_DEST_NOKEY         EQU 3
TERM_STEPS              EQU 4

COLOR_BG                EQU 00303030h
COLOR_EMPTY             EQU 00C4C4C4h
COLOR_WALL              EQU 00404040h
COLOR_BUILDING          EQU 002B5A8Bh
COLOR_LAKE              EQU 00FFD5BFh
COLOR_PIT               EQU 00111111h
COLOR_TRAP              EQU 004545D6h
COLOR_COIN              EQU 004CC9F2h
COLOR_TREASURE          EQU 004A99F2h
COLOR_DEST              EQU 0071CC2Eh
COLOR_PROF              EQU 00205E1Bh
COLOR_VISITED           EQU 00FFD3D9h
COLOR_HUD_BG            EQU 00525252h
COLOR_HUD_TEXT          EQU 000D0D0Dh
COLOR_HUD_ACCENT        EQU 000B4F6Ch
COLOR_TEXT              EQU 0066D1FFh
COLOR_MENU_BODY         EQU 00969696h
COLOR_ACCENT            EQU 008AE0FFh
COLOR_GLOW_OUTER        EQU 008A5B38h
COLOR_MENU_BG_TOP       EQU 000F1E2Fh
COLOR_MENU_BG_STEP      EQU 00010102h
COLOR_GAME_BG_TOP       EQU 00303030h
COLOR_GAME_BG_STEP      EQU 00010101h
COLOR_PANEL             EQU 001A2C45h
COLOR_PANEL_BORDER      EQU 003B9AC8h
COLOR_MAP_BORDER        EQU 000D0D0Dh

; ============================================================================
; STRUCTURES
; ============================================================================

WNDCLASSEXA STRUCT
    cbSize              DWORD ?
    style               DWORD ?
    lpfnWndProc         DWORD ?
    cbClsExtra          DWORD ?
    cbWndExtra          DWORD ?
    hInstance           DWORD ?
    hIcon               DWORD ?
    hCursor             DWORD ?
    hbrBackground       DWORD ?
    lpszMenuName        DWORD ?
    lpszClassName       DWORD ?
    hIconSm             DWORD ?
WNDCLASSEXA ENDS

PAINTSTRUCT STRUCT
    hdc                 DWORD ?
    fErase              DWORD ?
    rcPaint             RECT <>
    fRestore            DWORD ?
    fIncUpdate          DWORD ?
    rgbReserved         BYTE 32 DUP(?)
PAINTSTRUCT ENDS

MSG STRUCT
    hwnd                DWORD ?
    message             DWORD ?
    wParam              DWORD ?
    lParam              DWORD ?
    time                DWORD ?
    pt                  POINT <>
MSG ENDS

Professor STRUCT
    profName        BYTE 64 DUP(0)
    posX            DWORD ?
    posY            DWORD ?
    hasKey          DWORD ?
    wallet          DWORD ?
    stepCount       DWORD ?
    treasures       DWORD ?
    gameMode        DWORD ?
    gameState       DWORD ?
    outcome         DWORD ?
    lastDirX        DWORD ?
    lastDirY        DWORD ?
Professor ENDS

; ============================================================================
; API PROTOTYPES (not covered by Irvine32/GraphWin)
; ============================================================================

BeginPaint              PROTO :DWORD, :PTR PAINTSTRUCT
EndPaint                PROTO :DWORD, :PTR PAINTSTRUCT
RegisterClassExA         PROTO :PTR WNDCLASSEXA
GetDC                   PROTO :DWORD
ReleaseDC               PROTO :DWORD, :DWORD
CreateCompatibleDC      PROTO :DWORD
CreateCompatibleBitmap  PROTO :DWORD, :DWORD, :DWORD
SelectObject            PROTO :DWORD, :DWORD
DeleteDC                PROTO :DWORD
DeleteObject            PROTO :DWORD
CreateSolidBrush        PROTO :DWORD
FillRect                PROTO :DWORD, :PTR RECT, :DWORD
BitBlt                  PROTO :DWORD, :SDWORD, :SDWORD, :SDWORD, :SDWORD, :DWORD, :SDWORD, :SDWORD, :DWORD
Ellipse                 PROTO :DWORD, :SDWORD, :SDWORD, :SDWORD, :SDWORD
CreateFontA             PROTO :SDWORD, :SDWORD, :SDWORD, :SDWORD, :SDWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :PTR BYTE
; Use the decorated GDI name to avoid clashing with Irvine32 SetTextColor.
EXTERNDEF SetTextColor@8:PROC
SetBkMode               PROTO :DWORD, :DWORD
SetTextAlign            PROTO :DWORD, :DWORD
TextOutA                PROTO :DWORD, :SDWORD, :SDWORD, :DWORD, :DWORD
GetSystemMetrics        PROTO :DWORD
SetTimer                PROTO :DWORD, :DWORD, :DWORD, :DWORD
KillTimer               PROTO :DWORD, :DWORD
InvalidateRect          PROTO :DWORD, :DWORD, :DWORD
TranslateMessage        PROTO :PTR MSG
Beep                    PROTO :DWORD, :DWORD

; ============================================================================
; DATA SEGMENT
; ============================================================================

.data

    maze                BYTE MAZE_SIZE DUP(0)
    visitedCells        BYTE MAZE_SIZE DUP(0)

    professor           Professor <>

    pathX               DWORD MAX_STEPS DUP(0)
    pathY               DWORD MAX_STEPS DUP(0)
    treasureX           DWORD MAX_TREASURES DUP(0)
    treasureY           DWORD MAX_TREASURES DUP(0)
    treasureCount       DWORD 0

    gameHwnd            DWORD 0

    fileHandle          DWORD 0
    logBuffer           BYTE 4096 DUP(0)
    logFileName         BYTE "adventure_log.txt", 0
    historyLines        BYTE HISTORY_MAX * HISTORY_LINE_LEN DUP(0)
    historyCount        DWORD 0
    historyIndex        DWORD 0
    nameLen             DWORD 0
    nameIgnoreChar      DWORD 0

    msgPit              BYTE "GAME OVER - FELL INTO A PIT!", 0
    msgDestKey          BYTE "SUCCESS - PROFESSOR IS HOME SAFE!", 0
    msgDestNoKey        BYTE "PROFESSOR SLEEPS OUTSIDE - KEY LOST!", 0
    msgStepsEnd         BYTE "ADVENTURE OVER - MAX STEPS REACHED!", 0
    msgMenuTitle        BYTE "DIZZY WALK", 0
    msgMenuSubtitle     BYTE "Navigate the maze. Find your way home.", 0
    msgMenuPrompt       BYTE "Press P to Play   H: History   Q: Quit", 0
    msgNameTitle        BYTE "ENTER PROFESSOR NAME", 0
    msgNameLabel        BYTE "Name: ", 0
    msgNameHint         BYTE "Type and press Enter", 0
    msgModeTitle        BYTE "CHOOSE MODE", 0
    msgModeHint         BYTE "R: Random   K: Keyboard", 0
    msgHistoryHint      BYTE "ESC: Back to Menu", 0
    defaultName         BYTE "PROFESSOR", 0
    msgRegFail           BYTE "RegisterClassExA failed.", 0
    msgCreateFail        BYTE "CreateWindowExA failed.", 0
    msgMemDcFail         BYTE "CreateCompatibleDC failed.", 0
    msgMemBmpFail        BYTE "CreateCompatibleBitmap failed.", 0
    msgMemSelFail        BYTE "SelectObject for bitmap failed.", 0

    emptyStr            BYTE 0
    yesStr              BYTE "YES", 0
    noStr               BYTE "NO", 0
    homeStr             BYTE "HOME", 0
    pitStr              BYTE "PIT", 0
    noKeyStr            BYTE "NO KEY", 0
    stepsStr            BYTE "STEPS", 0
    walletStr           BYTE "WALLET", 0
    keyStr              BYTE "KEY", 0
    treasureStr         BYTE "TREASURES", 0
    modeRandomStr       BYTE "RANDOM", 0
    modeKeyboardStr     BYTE "KEYBOARD", 0

    hInstance           DWORD 0
    hWnd                DWORD 0
    hDC                 DWORD 0
    hMemDC              DWORD 0
    hMemBmp             DWORD 0
    hOldBmp             DWORD 0
    useMemBuffer         DWORD 0
    winWidth            DWORD WIN_WIDTH
    winHeight           DWORD WIN_HEIGHT
    cellSize            DWORD CELL_SIZE
    mazeWidthPx         DWORD 0
    mazeHeightPx        DWORD 0
    hBrush              DWORD 0
    hFont               DWORD 0
    hOldFont            DWORD 0
    hMenuFont           DWORD 0
    hOldMenuFont         DWORD 0
    hOldBrush           DWORD 0

    className           BYTE "DizzyWalkClass", 0
    windowTitle         BYTE "Dizzy Walk - Professor's Adventure", 0
    menuFontName        BYTE "Bahnschrift SemiCondensed", 0

    paintStruct         PAINTSTRUCT <>
    msg                 MSG <>

    fullRect            RECT <0,0,WIN_WIDTH,WIN_HEIGHT>
    cellRect            RECT <0,0,0,0>
    hudRect             RECT <MAZE_COLS * CELL_SIZE, 0, WIN_WIDTH, MAZE_ROWS * CELL_SIZE>
    statusRect          RECT <0, MAZE_ROWS * CELL_SIZE, WIN_WIDTH, WIN_HEIGHT>
    overlayRect         RECT <0, 0, 0, 0>

    lineBuf             BYTE 256 DUP(0)
    hudLine1            BYTE "DIZZY WALK", 0
    hudLine2            BYTE "Professor: ", 0
    hudLine3            BYTE "Position: ", 0
    hudLine4            BYTE "Wallet: ", 0
    hudLine5            BYTE "Key: ", 0
    hudLine6            BYTE "Steps: ", 0
    hudLine7            BYTE "Treasures: ", 0
    hudLine8            BYTE "Mode: ", 0
    hudLine9            BYTE "WASD/Arrows: Move   ESC: Quit", 0
    menuMsg1            BYTE "PLAY GAME", 0
    menuMsg2            BYTE "HISTORY", 0
    menuMsg3            BYTE "QUIT GAME", 0
    overMsg1            BYTE "GAME OVER", 0
    overMsg2            BYTE "Returning to menu...", 0
    historyTitle        BYTE "HISTORY", 0
    historyEmpty        BYTE "No history yet.", 0
    historyHome         BYTE "WIN - SLEPT HOME", 0
    historyOutside      BYTE "LOSS - SLEPT OUTSIDE", 0
    historyPit          BYTE "LOSS - PIT", 0
    historySteps        BYTE "LOSS - STEPS", 0
    legendTitle         BYTE "Legend:", 0
    legendWall          BYTE "Wall - Blocked", 0
    legendBuilding      BYTE "Building - Blocked", 0
    legendLake          BYTE "Lake - Blocked", 0
    legendTrap          BYTE "Trap - 50% Lose Key", 0
    legendPit           BYTE "Pit - Game Over", 0
    legendCoin          BYTE "Coin - +1 Wallet", 0
    legendTreasure      BYTE "Treasure - +5 Wallet", 0
    legendDest          BYTE "Home - Finish", 0
    legendStart         BYTE "Start - Spawn", 0
    legendVisited       BYTE "Visited - Trail", 0
    legendProf          BYTE "Professor - You", 0
    randomStateStr      BYTE "RANDOM", 0
    keyboardStateStr    BYTE "KEYBOARD", 0
    playingStr          BYTE "PLAYING", 0
    menuStr             BYTE "MENU", 0
    overStr             BYTE "OVER", 0

; ============================================================================
; CODE SEGMENT
; ============================================================================

.code

;---------------------------------------------------
; InitGameState
; Description : Reset professor state, arrays, and maze
;---------------------------------------------------
InitGameState PROC
    push ebp
    mov ebp, esp

    mov professor.posX, MAZE_ROWS / 2
    mov professor.posY, MAZE_COLS / 2
    mov professor.hasKey, 1
    mov professor.wallet, 0
    mov professor.stepCount, 0
    mov professor.treasures, 0
    mov professor.gameMode, MODE_RANDOM
    mov professor.gameState, STATE_MENU
    mov professor.outcome, 0
    mov professor.lastDirX, 0
    mov professor.lastDirY, 0

    mov edi, OFFSET pathX
    mov ecx, MAX_STEPS * 2
    xor eax, eax
    rep stosd

    mov edi, OFFSET treasureX
    mov ecx, MAX_TREASURES * 2
    xor eax, eax
    rep stosd

    mov treasureCount, 0

    mov edi, OFFSET visitedCells
    mov ecx, MAZE_SIZE
    xor eax, eax
    rep stosb

    pop ebp
    ret
InitGameState ENDP

;---------------------------------------------------
; ClearNameInput
; Description : Reset professor name buffer and length
;---------------------------------------------------
ClearNameInput PROC
    push ebp
    mov ebp, esp

    mov edi, OFFSET professor.profName
    mov ecx, NAME_BUF_LEN
    xor eax, eax
    rep stosb
    mov nameLen, 0

    pop ebp
    ret
ClearNameInput ENDP

;---------------------------------------------------
; UpdateLayout
; Description : Update rectangles based on winWidth/winHeight
;---------------------------------------------------
UpdateLayout PROC
    push ebp
    mov ebp, esp

    mov fullRect.left, 0
    mov fullRect.top, 0
    mov eax, winWidth
    mov fullRect.right, eax
    mov eax, winHeight
    mov fullRect.bottom, eax

    mov eax, winWidth
    sub eax, HUD_WIDTH
    cmp eax, 1
    jg LayoutWidthOk
    mov eax, 1
LayoutWidthOk:
    xor edx, edx
    mov ebx, MAZE_COLS
    div ebx
    mov ecx, eax

    mov eax, winHeight
    sub eax, STATUS_HEIGHT
    cmp eax, 1
    jg LayoutHeightOk
    mov eax, 1
LayoutHeightOk:
    xor edx, edx
    mov ebx, MAZE_ROWS
    div ebx
    cmp ecx, eax
    jbe LayoutCellSet
    mov ecx, eax
LayoutCellSet:
    cmp ecx, 4
    jge LayoutCellOk
    mov ecx, 4
LayoutCellOk:
    mov cellSize, ecx

    mov eax, MAZE_COLS
    imul eax, ecx
    mov mazeWidthPx, eax
    mov eax, MAZE_ROWS
    imul eax, ecx
    mov mazeHeightPx, eax

    mov eax, mazeWidthPx
    mov hudRect.left, eax
    mov hudRect.top, 0
    mov eax, winWidth
    mov hudRect.right, eax
    mov eax, mazeHeightPx
    mov hudRect.bottom, eax

    mov statusRect.left, 0
    mov eax, mazeHeightPx
    mov statusRect.top, eax
    mov eax, winWidth
    mov statusRect.right, eax
    mov eax, winHeight
    mov statusRect.bottom, eax

    mov eax, winWidth
    sub eax, PANEL_WIDTH
    shr eax, 1
    mov overlayRect.left, eax
    add eax, PANEL_WIDTH
    mov overlayRect.right, eax

    mov eax, winHeight
    sub eax, PANEL_HEIGHT
    shr eax, 1
    mov overlayRect.top, eax
    add eax, PANEL_HEIGHT
    mov overlayRect.bottom, eax

    call InitFonts

    pop ebp
    ret
UpdateLayout ENDP

;---------------------------------------------------
; InitFonts
; Description : Create menu and HUD fonts
;---------------------------------------------------
InitFonts PROC
    push ebp
    mov ebp, esp

    cmp hMenuFont, 0
    je SkipMenuDelete
    invoke DeleteObject, hMenuFont
SkipMenuDelete:
    cmp hFont, 0
    je SkipFontDelete
    invoke DeleteObject, hFont
SkipFontDelete:
    invoke CreateFontA,
        MENU_FONT_HEIGHT,
        0,
        0,
        0,
        FW_BOLD,
        0,
        0,
        0,
        ANSI_CHARSET,
        OUT_DEFAULT_PRECIS,
        CLIP_DEFAULT_PRECIS,
        DEFAULT_QUALITY,
        DEFAULT_PITCH or FF_DONTCARE,
        ADDR menuFontName
    mov hMenuFont, eax

    invoke CreateFontA,
        UI_FONT_HEIGHT,
        0,
        0,
        0,
        FW_BOLD,
        0,
        0,
        0,
        ANSI_CHARSET,
        OUT_DEFAULT_PRECIS,
        CLIP_DEFAULT_PRECIS,
        DEFAULT_QUALITY,
        DEFAULT_PITCH or FF_DONTCARE,
        ADDR menuFontName
    mov hFont, eax

    pop ebp
    ret
InitFonts ENDP

;---------------------------------------------------
; InitMaze
; Description : Initialize maze layout and items
;---------------------------------------------------
InitMaze PROC
    push ebp
    mov ebp, esp

    mov edi, OFFSET maze
    mov ecx, MAZE_SIZE
    xor eax, eax
    rep stosb

    call PlaceWallSegments
    call PlaceBuildings
    call PlaceLakes
    call PlaceCoins
    call PlaceTreasures
    call PlacePits
    call PlaceTraps

TryStart:
    call GetRandom
    xor edx, edx
    mov ebx, MAZE_ROWS - 2
    div ebx
    add edx, 1
    push edx

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_COLS - 2
    div ebx
    add edx, 1
    mov ebx, edx
    pop eax

    call SetMazeCell
    cmp BYTE PTR [esi], CELL_EMPTY
    jne TryStart
    mov BYTE PTR [esi], CELL_START
    mov professor.posX, eax
    mov professor.posY, ebx

TryDest:
    call GetRandom
    xor edx, edx
    mov ebx, MAZE_ROWS - 2
    div ebx
    add edx, 1
    push edx

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_COLS - 2
    div ebx
    add edx, 1
    mov ebx, edx
    pop eax

    call SetMazeCell
    cmp BYTE PTR [esi], CELL_EMPTY
    jne TryDest
    mov BYTE PTR [esi], CELL_DEST

    pop ebp
    ret
InitMaze ENDP

;---------------------------------------------------
; PlaceBorderWalls
; Description : Draw border walls around maze
;---------------------------------------------------
PlaceBorderWalls PROC
    push ebp
    mov ebp, esp

    mov eax, 0
    mov ecx, MAZE_COLS
    xor ebx, ebx
TopBorderLoop:
    call SetMazeCell
    mov BYTE PTR [esi], CELL_WALL
    inc ebx
    loop TopBorderLoop

    mov eax, MAZE_ROWS - 1
    mov ecx, MAZE_COLS
    xor ebx, ebx
BottomBorderLoop:
    call SetMazeCell
    mov BYTE PTR [esi], CELL_WALL
    inc ebx
    loop BottomBorderLoop

    xor ebx, ebx
    mov ecx, MAZE_ROWS
    xor eax, eax
LeftBorderLoop:
    call SetMazeCell
    mov BYTE PTR [esi], CELL_WALL
    inc eax
    loop LeftBorderLoop

    mov ebx, MAZE_COLS - 1
    mov ecx, MAZE_ROWS
    xor eax, eax
RightBorderLoop:
    call SetMazeCell
    mov BYTE PTR [esi], CELL_WALL
    inc eax
    loop RightBorderLoop

    pop ebp
    ret
PlaceBorderWalls ENDP

;---------------------------------------------------
; PlaceWallSegments
; Description : Place a few random horizontal and vertical wall segments
;---------------------------------------------------
PlaceWallSegments PROC
    push ebp
    mov ebp, esp

    mov ecx, 3
HWallLoop:
    push ecx
    call GetRandom
    xor edx, edx
    mov ebx, MAZE_ROWS - 6
    div ebx
    add edx, 2
    mov eax, edx
    push eax

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_COLS - 22
    div ebx
    add edx, 2
    mov ebx, edx
    pop eax

    mov ecx, 20
HSegLoop:
    cmp ecx, 0
    jle HSegDone
    push ecx
    call SetMazeCell
    cmp BYTE PTR [esi], CELL_EMPTY
    jne HSegSkip
    mov BYTE PTR [esi], CELL_WALL
HSegSkip:
    inc ebx
    pop ecx
    dec ecx
    jmp HSegLoop
HSegDone:
    pop ecx
    loop HWallLoop

    mov ecx, 3
VWallLoop:
    push ecx
    call GetRandom
    xor edx, edx
    mov ebx, MAZE_COLS - 6
    div ebx
    add edx, 2
    mov ebx, edx
    push ebx

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_ROWS - 14
    div ebx
    add edx, 2
    mov eax, edx
    pop ebx

    mov ecx, 12
VSegLoop:
    cmp ecx, 0
    jle VSegDone
    push ecx
    call SetMazeCell
    cmp BYTE PTR [esi], CELL_EMPTY
    jne VSegSkip
    mov BYTE PTR [esi], CELL_WALL
VSegSkip:
    inc eax
    pop ecx
    dec ecx
    jmp VSegLoop
VSegDone:
    pop ecx
    loop VWallLoop

    pop ebp
    ret
PlaceWallSegments ENDP

;---------------------------------------------------
; PlaceBuildings
; Description : Place two rectangular building blocks
;---------------------------------------------------
PlaceBuildings PROC
    push ebp
    mov ebp, esp
    push edi

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_ROWS - 8
    div ebx
    add edx, 2
    mov eax, edx
    push eax

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_COLS - 11
    div ebx
    add edx, 2
    mov ebx, edx
    mov edi, ebx
    pop eax

    mov ecx, 6
B1RowLoop:
    push ecx
    mov ebx, edi
    mov edx, 9
B1ColLoop:
    cmp edx, 0
    jle B1RowNext
    call SetMazeCell
    cmp BYTE PTR [esi], CELL_EMPTY
    jne B1Skip
    mov BYTE PTR [esi], CELL_BUILDING
B1Skip:
    inc ebx
    dec edx
    jmp B1ColLoop
B1RowNext:
    pop ecx
    inc eax
    loop B1RowLoop

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_ROWS - 8
    div ebx
    add edx, 2
    mov eax, edx
    push eax

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_COLS - 10
    div ebx
    add edx, 2
    mov ebx, edx
    mov edi, ebx
    pop eax

    mov ecx, 6
B2RowLoop:
    push ecx
    mov ebx, edi
    mov edx, 8
B2ColLoop:
    cmp edx, 0
    jle B2RowNext
    call SetMazeCell
    cmp BYTE PTR [esi], CELL_EMPTY
    jne B2Skip
    mov BYTE PTR [esi], CELL_BUILDING
B2Skip:
    inc ebx
    dec edx
    jmp B2ColLoop
B2RowNext:
    pop ecx
    inc eax
    loop B2RowLoop

    pop edi
    pop ebp
    ret
PlaceBuildings ENDP

;---------------------------------------------------
; PlaceLakes
; Description : Place two zigzag lake lines
;---------------------------------------------------
PlaceLakes PROC
    push ebp
    mov ebp, esp

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_ROWS - 12
    div ebx
    add edx, 2
    mov eax, edx
    push eax

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_COLS - 20
    div ebx
    add edx, 2
    mov ebx, edx
    pop eax

    mov ecx, 10
Lake1Loop:
    cmp ecx, 0
    jle Lake1Done
    push ecx
    call SetMazeCell
    cmp BYTE PTR [esi], CELL_EMPTY
    jne Lake1Skip
    mov BYTE PTR [esi], CELL_LAKE
Lake1Skip:
    inc eax
    add ebx, 2
    pop ecx
    dec ecx
    jmp Lake1Loop
Lake1Done:

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_ROWS - 9
    div ebx
    add edx, 2
    mov eax, edx
    push eax

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_COLS - 9
    div ebx
    add edx, 2
    mov ebx, edx
    pop eax

    mov ecx, 8
Lake2Loop:
    cmp ecx, 0
    jle Lake2Done
    push ecx
    call SetMazeCell
    cmp BYTE PTR [esi], CELL_EMPTY
    jne Lake2Skip
    mov BYTE PTR [esi], CELL_LAKE
Lake2Skip:
    inc eax
    inc ebx
    pop ecx
    dec ecx
    jmp Lake2Loop
Lake2Done:

    pop ebp
    ret
PlaceLakes ENDP

;---------------------------------------------------
; PlaceCoins
; Description : Scatter coins at random empty cells
;---------------------------------------------------
PlaceCoins PROC
    push ebp
    mov ebp, esp
    mov ecx, COIN_COUNT
CoinLoop:
    cmp ecx, 0
    jle CoinDone
TryCoin:
    call GetRandom
    xor edx, edx
    mov ebx, MAZE_ROWS - 2
    div ebx
    add edx, 1
    push edx

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_COLS - 2
    div ebx
    add edx, 1
    mov ebx, edx
    pop eax

    push ecx
    call SetMazeCell
    cmp BYTE PTR [esi], CELL_EMPTY
    jne CoinRetry
    mov BYTE PTR [esi], CELL_COIN
    pop ecx
    dec ecx
    jmp CoinLoop
CoinRetry:
    pop ecx
    jmp TryCoin
CoinDone:
    pop ebp
    ret
PlaceCoins ENDP

;---------------------------------------------------
; PlaceTreasures
; Description : Scatter treasures at random empty cells
;---------------------------------------------------
PlaceTreasures PROC
    push ebp
    mov ebp, esp
    mov ecx, TREASURE_COUNT
TreasureLoop:
    cmp ecx, 0
    jle TreasureDone
TryTreasure:
    call GetRandom
    xor edx, edx
    mov ebx, MAZE_ROWS - 2
    div ebx
    add edx, 1
    push edx

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_COLS - 2
    div ebx
    add edx, 1
    mov ebx, edx
    pop eax

    push ecx
    call SetMazeCell
    cmp BYTE PTR [esi], CELL_EMPTY
    jne TreasureRetry
    mov BYTE PTR [esi], CELL_TREASURE
    pop ecx
    dec ecx
    jmp TreasureLoop
TreasureRetry:
    pop ecx
    jmp TryTreasure
TreasureDone:
    pop ebp
    ret
PlaceTreasures ENDP

;---------------------------------------------------
; PlacePits
; Description : Scatter pits at random empty cells
;---------------------------------------------------
PlacePits PROC
    push ebp
    mov ebp, esp
    mov ecx, PIT_COUNT
PitLoop:
    cmp ecx, 0
    jle PitDone
TryPit:
    call GetRandom
    xor edx, edx
    mov ebx, MAZE_ROWS - 2
    div ebx
    add edx, 1
    push edx

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_COLS - 2
    div ebx
    add edx, 1
    mov ebx, edx
    pop eax

    push ecx
    call SetMazeCell
    cmp BYTE PTR [esi], CELL_EMPTY
    jne PitRetry
    mov BYTE PTR [esi], CELL_PIT
    pop ecx
    dec ecx
    jmp PitLoop
PitRetry:
    pop ecx
    jmp TryPit
PitDone:
    pop ebp
    ret
PlacePits ENDP

;---------------------------------------------------
; PlaceTraps
; Description : Scatter traps at random empty cells
;---------------------------------------------------
PlaceTraps PROC
    push ebp
    mov ebp, esp
    mov ecx, TRAP_COUNT
TrapLoop:
    cmp ecx, 0
    jle TrapDone
TryTrap:
    call GetRandom
    xor edx, edx
    mov ebx, MAZE_ROWS - 2
    div ebx
    add edx, 1
    push edx

    call GetRandom
    xor edx, edx
    mov ebx, MAZE_COLS - 2
    div ebx
    add edx, 1
    mov ebx, edx
    pop eax

    push ecx
    call SetMazeCell
    cmp BYTE PTR [esi], CELL_EMPTY
    jne TrapRetry
    mov BYTE PTR [esi], CELL_TRAP
    pop ecx
    dec ecx
    jmp TrapLoop
TrapRetry:
    pop ecx
    jmp TryTrap
TrapDone:
    pop ebp
    ret
PlaceTraps ENDP

;---------------------------------------------------
; SetMazeCell
; Description : Return address of maze[row * MAZE_COLS + col]
;---------------------------------------------------
SetMazeCell PROC
    push ebp
    mov ebp, esp
    push ecx

    mov ecx, eax
    imul ecx, MAZE_COLS
    add ecx, ebx
    mov esi, OFFSET maze
    add esi, ecx

    pop ecx
    pop ebp
    ret
SetMazeCell ENDP

;---------------------------------------------------
; GetMazeCell
; Description : Read cell type at given position
;---------------------------------------------------
GetMazeCell PROC
    push ebp
    mov ebp, esp
    push ecx

    mov ecx, eax
    imul ecx, MAZE_COLS
    add ecx, ebx
    mov esi, OFFSET maze
    mov al, [esi + ecx]

    pop ecx
    pop ebp
    ret
GetMazeCell ENDP

;---------------------------------------------------
; GetRandom
; Description : Generate pseudo-random number with LCG
;---------------------------------------------------
GetRandom PROC
    push ebp
    mov ebp, esp

    call Random32

    pop ebp
    ret
GetRandom ENDP

;---------------------------------------------------
; MoveUp
;---------------------------------------------------
MoveUp PROC
    push ebp
    mov ebp, esp

    mov eax, professor.posX
    cmp eax, 0
    je MoveUpEnd
    dec eax
    mov ebx, professor.posY
    mov ecx, DIR_UP
    call CheckCell
MoveUpEnd:
    pop ebp
    ret
MoveUp ENDP

;---------------------------------------------------
; MoveDown
;---------------------------------------------------
MoveDown PROC
    push ebp
    mov ebp, esp

    mov eax, professor.posX
    cmp eax, MAZE_ROWS - 1
    je MoveDownEnd
    inc eax
    mov ebx, professor.posY
    mov ecx, DIR_DOWN
    call CheckCell
MoveDownEnd:
    pop ebp
    ret
MoveDown ENDP

;---------------------------------------------------
; MoveLeft
;---------------------------------------------------
MoveLeft PROC
    push ebp
    mov ebp, esp

    mov ebx, professor.posY
    cmp ebx, 0
    je MoveLeftEnd
    dec ebx
    mov eax, professor.posX
    mov ecx, DIR_LEFT
    call CheckCell
MoveLeftEnd:
    pop ebp
    ret
MoveLeft ENDP

;---------------------------------------------------
; MoveRight
;---------------------------------------------------
MoveRight PROC
    push ebp
    mov ebp, esp

    mov ebx, professor.posY
    cmp ebx, MAZE_COLS - 1
    je MoveRightEnd
    inc ebx
    mov eax, professor.posX
    mov ecx, DIR_RIGHT
    call CheckCell
MoveRightEnd:
    pop ebp
    ret
MoveRight ENDP

;---------------------------------------------------
; CheckCell
; Description : Core collision / pickup / termination logic
; Receives    : eax = row, ebx = col, ecx = direction
;---------------------------------------------------
CheckCell PROC
    push ebp
    mov ebp, esp
    push eax
    push ebx
    push ecx

    mov professor.lastDirX, eax
    mov professor.lastDirY, ebx

    call GetMazeCell
    mov dl, al

    mov eax, [esp + 8]
    mov ebx, [esp + 4]

    cmp dl, CELL_WALL
    je CheckCellEnd
    cmp dl, CELL_BUILDING
    je CheckCellEnd
    cmp dl, CELL_LAKE
    je CheckCellEnd

    mov professor.posX, eax
    mov professor.posY, ebx

    cmp dl, CELL_PIT
    je HitPit
    cmp dl, CELL_COIN
    je HitCoin
    cmp dl, CELL_TREASURE
    je HitTreasure
    cmp dl, CELL_TRAP
    je HitTrap
    cmp dl, CELL_DEST
    je HitDest

    jmp MarkVisited

HitPit:
    mov professor.outcome, TERM_PIT
    mov professor.gameState, STATE_OVER
    call RecordHistory
    call WriteAdventureLog
    invoke Beep, 150, 600
    invoke KillTimer, gameHwnd, ID_TIMER
    invoke SetTimer, gameHwnd, ID_MENU_TIMER, 2000, NULL
    jmp MarkVisited

HitCoin:
    inc professor.wallet
    mov eax, professor.posX
    mov ebx, professor.posY
    call SetMazeCell
    mov BYTE PTR [esi], CELL_EMPTY
    invoke Beep, 1200, 80
    jmp MarkVisited

HitTreasure:
    add professor.wallet, 5
    inc professor.treasures
    mov eax, treasureCount
    cmp eax, MAX_TREASURES
    jge SkipTreasureRecord
    mov edx, eax
    shl edx, 2
    mov esi, OFFSET treasureX
    mov eax, professor.posX
    mov [esi + edx], eax
    mov esi, OFFSET treasureY
    mov eax, professor.posY
    mov [esi + edx], eax
    inc treasureCount
SkipTreasureRecord:
    mov eax, professor.posX
    mov ebx, professor.posY
    call SetMazeCell
    mov BYTE PTR [esi], CELL_EMPTY
    invoke Beep, 800, 100
    invoke Beep, 1000, 100
    invoke Beep, 1400, 200
    jmp MarkVisited

HitTrap:
    cmp professor.hasKey, 1
    jne TrapDone
    call GetRandom
    xor edx, edx
    mov ecx, 100
    div ecx
    cmp edx, TRAP_KEY_CHANCE
    jge TrapDone
    mov professor.hasKey, 0
TrapDone:
    jmp MarkVisited

HitDest:
    cmp professor.hasKey, 1
    je DestWithKey
    mov professor.outcome, TERM_DEST_NOKEY
    jmp EndViaDest
DestWithKey:
    mov professor.outcome, TERM_DEST_KEY
EndViaDest:
    mov professor.gameState, STATE_OVER
    call RecordHistory
    call WriteAdventureLog
    invoke KillTimer, gameHwnd, ID_TIMER
    invoke SetTimer, gameHwnd, ID_MENU_TIMER, 2000, NULL
    invoke Beep, 523, 150
    invoke Beep, 659, 150
    invoke Beep, 784, 150
    invoke Beep, 1047, 400

MarkVisited:
    mov eax, professor.posX
    mov ebx, professor.posY
    imul eax, MAZE_COLS
    add eax, ebx
    mov esi, OFFSET visitedCells
    mov BYTE PTR [esi + eax], 1

CheckCellEnd:
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret
CheckCell ENDP

;---------------------------------------------------
; StumbleCheck
; Description : Random stumble chance to drop the key (disabled; traps handle key loss)
;---------------------------------------------------
StumbleCheck PROC
    push ebp
    mov ebp, esp

    cmp professor.hasKey, 1
    jne StumbleDone

    call GetRandom
    xor edx, edx
    mov ecx, 100
    div ecx
    cmp edx, STUMBLE_CHANCE
    jge StumbleDone

    mov professor.hasKey, 0
    invoke Beep, 600, 150
    invoke Beep, 400, 250

StumbleDone:
    pop ebp
    ret
StumbleCheck ENDP

;---------------------------------------------------
; RecordStep
; Description : Store current position in path arrays
;---------------------------------------------------
RecordStep PROC
    push ebp
    mov ebp, esp

    mov eax, professor.stepCount
    cmp eax, MAX_STEPS
    jge RecordStepEnd

    mov edx, eax
    shl edx, 2

    mov esi, OFFSET pathX
    mov eax, professor.posX
    mov [esi + edx], eax

    mov esi, OFFSET pathY
    mov eax, professor.posY
    mov [esi + edx], eax

    inc professor.stepCount

RecordStepEnd:
    pop ebp
    ret
RecordStep ENDP

;---------------------------------------------------
; DoRandomStep
; Description : Execute one random movement step
;---------------------------------------------------
DoRandomStep PROC
    push ebp
    mov ebp, esp

    cmp professor.gameState, STATE_PLAYING
    jne RandomStepEnd

    call GetRandom
    and eax, 3
    cmp eax, DIR_UP
    je StepUp
    cmp eax, DIR_DOWN
    je StepDown
    cmp eax, DIR_LEFT
    je StepLeft
    cmp eax, DIR_RIGHT
    je StepRight
    jmp StepDone

StepUp:
    call MoveUp
    jmp StepDone
StepDown:
    call MoveDown
    jmp StepDone
StepLeft:
    call MoveLeft
    jmp StepDone
StepRight:
    call MoveRight

StepDone:
    call StumbleCheck
    call RecordStep
    mov eax, professor.stepCount
    cmp eax, MAX_STEPS
    jb RandomStepEnd
    mov eax, TERM_STEPS
    call EndGame

RandomStepEnd:
    pop ebp
    ret
DoRandomStep ENDP

;---------------------------------------------------
; AppendText
; Description : Copy zero-terminated string from ESI to EDI
;---------------------------------------------------
AppendText PROC
CopyLoop:
    mov al, [esi]
    cmp al, 0
    je CopyDone
    mov [edi], al
    inc esi
    inc edi
    jmp CopyLoop
CopyDone:
    ret
AppendText ENDP

;---------------------------------------------------
; AppendChar
; Description : Append one character in AL to buffer at EDI
;---------------------------------------------------
AppendChar PROC
    mov [edi], al
    inc edi
    ret
AppendChar ENDP

;---------------------------------------------------
; AppendDec
; Description : Append unsigned decimal EAX to buffer at EDI
;---------------------------------------------------
AppendDec PROC
    push ebx
    push ecx
    push edx

    cmp eax, 0
    jne AppendDecConvert
    mov BYTE PTR [edi], '0'
    inc edi
    jmp AppendDecDone

AppendDecConvert:
    mov ebx, 10
    xor ecx, ecx

AppendDecLoop:
    xor edx, edx
    div ebx
    push edx
    inc ecx
    cmp eax, 0
    jne AppendDecLoop

AppendDecWrite:
    pop edx
    add dl, '0'
    mov [edi], dl
    inc edi
    loop AppendDecWrite

AppendDecDone:
    pop edx
    pop ecx
    pop ebx
    ret
AppendDec ENDP

;---------------------------------------------------
; WriteAdventureLog
; Description : Build adventure log and write it to file
;---------------------------------------------------
WriteAdventureLog PROC
    push ebp
    mov ebp, esp

    mov edi, OFFSET logBuffer

    mov esi, OFFSET msgMenuTitle
    call AppendText
    mov al, 13
    call AppendChar
    mov al, 10
    call AppendChar

    mov esi, OFFSET emptyStr
    call AppendText

    mov esi, OFFSET professor.profName
    call AppendText
    mov al, 13
    call AppendChar
    mov al, 10
    call AppendChar

    mov esi, OFFSET hudLine8
    call AppendText
    cmp professor.gameMode, MODE_RANDOM
    je LogModeRandom
    mov esi, OFFSET modeKeyboardStr
    jmp LogModeWrite
LogModeRandom:
    mov esi, OFFSET modeRandomStr
LogModeWrite:
    call AppendText
    mov al, 13
    call AppendChar
    mov al, 10
    call AppendChar

    mov esi, OFFSET stepsStr
    call AppendText
    mov al, ':'
    call AppendChar
    mov al, ' '
    call AppendChar
    mov eax, professor.stepCount
    call AppendDec
    mov al, 13
    call AppendChar
    mov al, 10
    call AppendChar

    mov esi, OFFSET walletStr
    call AppendText
    mov al, ':'
    call AppendChar
    mov al, ' '
    call AppendChar
    mov eax, professor.wallet
    call AppendDec
    mov al, 13
    call AppendChar
    mov al, 10
    call AppendChar

    mov esi, OFFSET keyStr
    call AppendText
    mov al, ':'
    call AppendChar
    mov al, ' '
    call AppendChar
    cmp professor.hasKey, 1
    je KeyKept
    mov esi, OFFSET noStr
    jmp KeyAppend
KeyKept:
    mov esi, OFFSET yesStr
KeyAppend:
    call AppendText
    mov al, 13
    call AppendChar
    mov al, 10
    call AppendChar

    mov esi, OFFSET treasureStr
    call AppendText
    mov al, ':'
    call AppendChar
    mov al, ' '
    call AppendChar
    mov eax, professor.treasures
    call AppendDec
    mov al, 13
    call AppendChar
    mov al, 10
    call AppendChar

    mov esi, OFFSET emptyStr
    call AppendText
    mov al, 13
    call AppendChar
    mov al, 10
    call AppendChar

    mov esi, OFFSET homeStr
    cmp professor.outcome, TERM_PIT
    je OutcomePit
    cmp professor.outcome, TERM_DEST_KEY
    je OutcomeKey
    cmp professor.outcome, TERM_DEST_NOKEY
    je OutcomeNoKey
    cmp professor.outcome, TERM_STEPS
    je OutcomeSteps
    jmp OutcomeWrite
OutcomePit:
    mov esi, OFFSET pitStr
    jmp OutcomeWrite
OutcomeKey:
    mov esi, OFFSET msgDestKey
    jmp OutcomeWrite
OutcomeNoKey:
    mov esi, OFFSET msgDestNoKey
    jmp OutcomeWrite
OutcomeSteps:
    mov esi, OFFSET msgStepsEnd
OutcomeWrite:
    call AppendText
    mov al, 13
    call AppendChar
    mov al, 10
    call AppendChar

    mov esi, OFFSET pathX
    mov ecx, professor.stepCount
    cmp ecx, 20
    jbe PathCountOk
    mov ecx, 20
PathCountOk:
PathHeader:
    mov al, 'P'
    call AppendChar
    mov al, 'a'
    call AppendChar
    mov al, 't'
    call AppendChar
    mov al, 'h'
    call AppendChar
    mov al, ':'
    call AppendChar
    mov al, 13
    call AppendChar
    mov al, 10
    call AppendChar

    xor ebx, ebx
PathLoop:
    cmp ebx, ecx
    jge PathDone
    mov al, '(' 
    call AppendChar
    mov eax, [pathX + ebx*4]
    call AppendDec
    mov al, ','
    call AppendChar
    mov eax, [pathY + ebx*4]
    call AppendDec
    mov al, ')'
    call AppendChar
    mov al, ' '
    call AppendChar
    inc ebx
    jmp PathLoop
PathDone:

    mov BYTE PTR [edi], 0

    mov edx, OFFSET logFileName
    call CreateOutputFile
    jc LogDone
    mov fileHandle, eax

    mov eax, edi
    sub eax, OFFSET logBuffer
    mov ecx, eax
    mov edx, OFFSET logBuffer
    mov eax, fileHandle
    call WriteToFile

    mov eax, fileHandle
    call CloseFile

LogDone:
    pop ebp
    ret
WriteAdventureLog ENDP

;---------------------------------------------------
; RecordHistory
; Description : Store latest outcome in history buffer
;---------------------------------------------------
RecordHistory PROC
    push ebp
    mov ebp, esp
    push edi
    push esi
    push eax
    push ebx

    mov eax, historyIndex
    mov ebx, HISTORY_LINE_LEN
    imul eax, ebx
    mov edi, OFFSET historyLines
    add edi, eax
    mov BYTE PTR [edi], 0

    mov esi, OFFSET professor.profName
    call AppendText
    mov al, ' '
    call AppendChar
    mov al, '-'
    call AppendChar
    mov al, ' '
    call AppendChar

    cmp professor.gameMode, MODE_RANDOM
    je HistoryModeRandom
    mov esi, OFFSET modeKeyboardStr
    jmp HistoryModeWrite
HistoryModeRandom:
    mov esi, OFFSET modeRandomStr
HistoryModeWrite:
    call AppendText
    mov al, ' '
    call AppendChar
    mov al, '-'
    call AppendChar
    mov al, ' '
    call AppendChar

    mov esi, OFFSET historyHome
    cmp professor.outcome, TERM_DEST_KEY
    je HistoryWrite
    mov esi, OFFSET historyOutside
    cmp professor.outcome, TERM_DEST_NOKEY
    je HistoryWrite
    mov esi, OFFSET historyPit
    cmp professor.outcome, TERM_PIT
    je HistoryWrite
    mov esi, OFFSET historySteps
    cmp professor.outcome, TERM_STEPS
    je HistoryWrite
    mov esi, OFFSET historySteps
HistoryWrite:
    call AppendText
    mov BYTE PTR [edi], 0

    mov eax, historyCount
    cmp eax, HISTORY_MAX
    jae HistoryIndexUpdate
    inc eax
    mov historyCount, eax
HistoryIndexUpdate:
    mov eax, historyIndex
    inc eax
    cmp eax, HISTORY_MAX
    jb HistoryIndexStore
    xor eax, eax
HistoryIndexStore:
    mov historyIndex, eax

    pop ebx
    pop eax
    pop esi
    pop edi
    pop ebp
    ret
RecordHistory ENDP

;---------------------------------------------------
; EndGame
; Description : Finalize game state and save log
;---------------------------------------------------
EndGame PROC
    push ebp
    mov ebp, esp

    mov professor.outcome, eax
    mov professor.gameState, STATE_OVER
    call RecordHistory
    invoke KillTimer, gameHwnd, ID_TIMER
    invoke SetTimer, gameHwnd, ID_MENU_TIMER, 2000, NULL
    call WriteAdventureLog

    cmp eax, TERM_PIT
    je PlayPitSound
    cmp eax, TERM_DEST_KEY
    je PlayVictorySound
    cmp eax, TERM_DEST_NOKEY
    je PlaySadSound
    cmp eax, TERM_STEPS
    je PlayStepsSound
    jmp EndGameDone

PlayPitSound:
    invoke Beep, 150, 600
    jmp EndGameDone
PlayVictorySound:
    invoke Beep, 523, 150
    invoke Beep, 659, 150
    invoke Beep, 784, 150
    invoke Beep, 1047, 400
    jmp EndGameDone
PlaySadSound:
    invoke Beep, 400, 300
    invoke Beep, 350, 300
    invoke Beep, 300, 500
    jmp EndGameDone
PlayStepsSound:
    invoke Beep, 250, 250

EndGameDone:
    pop ebp
    ret
EndGame ENDP

;---------------------------------------------------
; StrLen
; Description : Return length of zero-terminated string
;---------------------------------------------------
StrLen PROC
    push ecx
    xor eax, eax
LenLoop:
    cmp BYTE PTR [esi + eax], 0
    je LenDone
    inc eax
    jmp LenLoop
LenDone:
    pop ecx
    ret
StrLen ENDP

;---------------------------------------------------
; DrawTextLine
; Description : Draw zero-terminated text at a position
;---------------------------------------------------
DrawTextLine PROC
    push ecx
    push edx
    push eax
    push ebx
    mov edx, esi
    call StrLen
    mov ecx, eax
    pop ebx
    pop eax
    invoke TextOutA, hMemDC, eax, ebx, edx, ecx
    pop edx
    pop ecx
    ret
DrawTextLine ENDP

;---------------------------------------------------
; DrawGlowText
; Description : Draw text with a soft glow
; Receives    : eax = x, ebx = y, esi = text
;---------------------------------------------------
DrawGlowText PROC
    push edx
    push ecx
    push edi

    mov edx, eax
    mov ecx, ebx
    mov edi, esi

    push COLOR_GLOW_OUTER
    push hMemDC
    call SetTextColor@8

    mov eax, edx
    sub eax, 2
    mov ebx, ecx
    mov esi, edi
    call DrawTextLine

    mov eax, edx
    add eax, 2
    mov ebx, ecx
    mov esi, edi
    call DrawTextLine

    mov eax, edx
    mov ebx, ecx
    sub ebx, 2
    mov esi, edi
    call DrawTextLine

    mov eax, edx
    mov ebx, ecx
    add ebx, 2
    mov esi, edi
    call DrawTextLine

    mov eax, edx
    sub eax, 2
    mov ebx, ecx
    sub ebx, 2
    mov esi, edi
    call DrawTextLine

    mov eax, edx
    add eax, 2
    mov ebx, ecx
    add ebx, 2
    mov esi, edi
    call DrawTextLine

    mov eax, edx
    sub eax, 2
    mov ebx, ecx
    add ebx, 2
    mov esi, edi
    call DrawTextLine

    mov eax, edx
    add eax, 2
    mov ebx, ecx
    sub ebx, 2
    mov esi, edi
    call DrawTextLine

    push COLOR_ACCENT
    push hMemDC
    call SetTextColor@8

    mov eax, edx
    dec eax
    mov ebx, ecx
    mov esi, edi
    call DrawTextLine

    mov eax, edx
    inc eax
    mov ebx, ecx
    mov esi, edi
    call DrawTextLine

    mov eax, edx
    mov ebx, ecx
    dec ebx
    mov esi, edi
    call DrawTextLine

    mov eax, edx
    mov ebx, ecx
    inc ebx
    mov esi, edi
    call DrawTextLine

    push COLOR_TEXT
    push hMemDC
    call SetTextColor@8

    mov eax, edx
    mov ebx, ecx
    mov esi, edi
    call DrawTextLine

    pop edi
    pop ecx
    pop edx
    ret
DrawGlowText ENDP

;---------------------------------------------------
; DrawBackground
; Description : Draw a simple vertical gradient
;---------------------------------------------------
DrawBackground PROC
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov eax, professor.gameState
    cmp eax, STATE_PLAYING
    je BgUseGame
    cmp eax, STATE_OVER
    je BgUseGame
    mov ebx, COLOR_MENU_BG_TOP
    mov edi, COLOR_MENU_BG_STEP
    jmp BgStart
BgUseGame:
    mov ebx, COLOR_GAME_BG_TOP
    mov edi, COLOR_GAME_BG_STEP
BgStart:

    mov eax, winHeight
    xor edx, edx
    mov ecx, 24
    div ecx
    mov esi, eax
    cmp esi, 1
    jge BgSizeOk
    mov esi, 1
BgSizeOk:
    mov ecx, 24
    xor edx, edx
    mov eax, ebx
BgLoop:
    mov cellRect.left, 0
    mov cellRect.top, edx
    mov ebx, edx
    add ebx, esi
    mov cellRect.bottom, ebx
    mov ebx, winWidth
    mov cellRect.right, ebx

    push eax
    invoke CreateSolidBrush, eax
    mov hBrush, eax
    invoke FillRect, hMemDC, ADDR cellRect, hBrush
    invoke DeleteObject, hBrush
    pop eax

    add eax, edi
    add edx, esi
    dec ecx
    jnz BgLoop

    mov ebx, winHeight
    cmp edx, ebx
    jge BgDone

    mov cellRect.left, 0
    mov cellRect.top, edx
    mov ecx, winWidth
    mov cellRect.right, ecx
    mov cellRect.bottom, ebx

    sub eax, edi
    push eax
    invoke CreateSolidBrush, eax
    mov hBrush, eax
    invoke FillRect, hMemDC, ADDR cellRect, hBrush
    invoke DeleteObject, hBrush
    pop eax

BgDone:

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop ebp
    ret
DrawBackground ENDP

;---------------------------------------------------
; DrawLegendSwatch
; Description : Draw a small colored box at (EAX, EBX)
; Receives    : eax = x, ebx = y, ecx = color
;---------------------------------------------------
DrawLegendSwatch PROC
    push edx

    mov cellRect.left, eax
    mov edx, eax
    add edx, 12
    mov cellRect.right, edx

    mov cellRect.top, ebx
    mov edx, ebx
    add edx, 12
    mov cellRect.bottom, edx

    invoke CreateSolidBrush, ecx
    mov hBrush, eax
    invoke FillRect, hMemDC, ADDR cellRect, hBrush
    invoke DeleteObject, hBrush

    pop edx
    ret
DrawLegendSwatch ENDP

;---------------------------------------------------
; DrawPopupPanel
; Description : Draw centered popup panel background
;---------------------------------------------------
DrawPopupPanel PROC
    push ebp
    mov ebp, esp

    invoke CreateSolidBrush, COLOR_PANEL_BORDER
    mov hBrush, eax
    invoke FillRect, hMemDC, ADDR overlayRect, hBrush
    invoke DeleteObject, hBrush

    mov eax, overlayRect.left
    add eax, 6
    mov cellRect.left, eax
    mov eax, overlayRect.top
    add eax, 6
    mov cellRect.top, eax
    mov eax, overlayRect.right
    sub eax, 6
    mov cellRect.right, eax
    mov eax, overlayRect.bottom
    sub eax, 6
    mov cellRect.bottom, eax

    invoke CreateSolidBrush, COLOR_PANEL
    mov hBrush, eax
    invoke FillRect, hMemDC, ADDR cellRect, hBrush
    invoke DeleteObject, hBrush

    pop ebp
    ret
DrawPopupPanel ENDP

;---------------------------------------------------
; DrawMenuScreen
; Description : Render menu overlay on the game board
;---------------------------------------------------
DrawMenuScreen PROC
    push ebp
    mov ebp, esp

    call DrawPopupPanel
    invoke SetBkMode, hMemDC, TRANSPARENT
    invoke SetTextAlign, hMemDC, TA_CENTER

    cmp hMenuFont, 0
    je MenuFontReady
    invoke SelectObject, hMemDC, hMenuFont
    mov hOldMenuFont, eax
MenuFontReady:
    mov eax, winWidth
    shr eax, 1
    mov ebx, overlayRect.top
    add ebx, 32
    mov esi, OFFSET msgMenuTitle
    call DrawGlowText

    mov eax, overlayRect.left
    add eax, 90
    mov cellRect.left, eax
    mov eax, overlayRect.right
    sub eax, 90
    mov cellRect.right, eax
    mov eax, overlayRect.top
    add eax, 92
    mov cellRect.top, eax
    add eax, 2
    mov cellRect.bottom, eax
    invoke CreateSolidBrush, COLOR_ACCENT
    mov hBrush, eax
    invoke FillRect, hMemDC, ADDR cellRect, hBrush
    invoke DeleteObject, hBrush

    cmp hFont, 0
    je MenuSubtitleReady
    invoke SelectObject, hMemDC, hFont
    mov hOldFont, eax
MenuSubtitleReady:
    push COLOR_MENU_BODY
    push hMemDC
    call SetTextColor@8
    mov eax, winWidth
    shr eax, 1
    mov ebx, overlayRect.top
    add ebx, 110
    mov esi, OFFSET msgMenuSubtitle
    call DrawTextLine
    cmp hFont, 0
    je MenuSubtitleDone
    invoke SelectObject, hMemDC, hOldFont
MenuSubtitleDone:

    mov ebx, overlayRect.top
    add ebx, 170
    mov esi, OFFSET menuMsg1
    call DrawGlowText

    add ebx, 60
    mov esi, OFFSET menuMsg2
    call DrawGlowText

    add ebx, 60
    mov esi, OFFSET menuMsg3
    call DrawGlowText

    cmp hMenuFont, 0
    je MenuFontDone
    invoke SelectObject, hMemDC, hOldMenuFont
MenuFontDone:

    cmp hFont, 0
    je MenuPromptReady
    invoke SelectObject, hMemDC, hFont
    mov hOldFont, eax
MenuPromptReady:
    push COLOR_MENU_BODY
    push hMemDC
    call SetTextColor@8
    mov eax, winWidth
    shr eax, 1
    mov ebx, overlayRect.bottom
    sub ebx, 50
    mov esi, OFFSET msgMenuPrompt
    call DrawTextLine
    cmp hFont, 0
    je MenuPromptDone
    invoke SelectObject, hMemDC, hOldFont
MenuPromptDone:
    invoke SetTextAlign, hMemDC, TA_LEFT

    pop ebp
    ret
DrawMenuScreen ENDP

;---------------------------------------------------
; DrawNameScreen
; Description : Render name input overlay
;---------------------------------------------------
DrawNameScreen PROC
    push ebp
    mov ebp, esp

    call DrawPopupPanel
    invoke SetBkMode, hMemDC, TRANSPARENT
    invoke SetTextAlign, hMemDC, TA_CENTER

    cmp hMenuFont, 0
    je NameTitleReady
    invoke SelectObject, hMemDC, hMenuFont
    mov hOldMenuFont, eax
NameTitleReady:
    mov eax, winWidth
    shr eax, 1
    mov ebx, overlayRect.top
    add ebx, 40
    mov esi, OFFSET msgNameTitle
    call DrawGlowText

    cmp hMenuFont, 0
    je NameTitleDone
    invoke SelectObject, hMemDC, hOldMenuFont
NameTitleDone:

    cmp hFont, 0
    je NameFontReady
    invoke SelectObject, hMemDC, hFont
    mov hOldFont, eax
NameFontReady:
    push COLOR_MENU_BODY
    push hMemDC
    call SetTextColor@8
    mov edi, OFFSET lineBuf
    mov esi, OFFSET msgNameLabel
    call AppendText
    mov esi, OFFSET professor.profName
    call AppendText
    mov BYTE PTR [edi], 0

    mov eax, winWidth
    shr eax, 1
    mov ebx, overlayRect.top
    add ebx, 160
    mov esi, OFFSET lineBuf
    call DrawTextLine

    mov eax, overlayRect.left
    add eax, 120
    mov cellRect.left, eax
    mov eax, overlayRect.right
    sub eax, 120
    mov cellRect.right, eax
    mov eax, overlayRect.top
    add eax, 188
    mov cellRect.top, eax
    add eax, 2
    mov cellRect.bottom, eax
    invoke CreateSolidBrush, COLOR_ACCENT
    mov hBrush, eax
    invoke FillRect, hMemDC, ADDR cellRect, hBrush
    invoke DeleteObject, hBrush

    mov eax, winWidth
    shr eax, 1
    mov ebx, overlayRect.bottom
    sub ebx, 60
    mov esi, OFFSET msgNameHint
    call DrawTextLine

    cmp hFont, 0
    je NameDone
    invoke SelectObject, hMemDC, hOldFont
NameDone:
    invoke SetTextAlign, hMemDC, TA_LEFT

    pop ebp
    ret
DrawNameScreen ENDP

;---------------------------------------------------
; DrawModeScreen
; Description : Render mode selection overlay
;---------------------------------------------------
DrawModeScreen PROC
    push ebp
    mov ebp, esp

    call DrawPopupPanel
    invoke SetBkMode, hMemDC, TRANSPARENT
    invoke SetTextAlign, hMemDC, TA_CENTER

    cmp hMenuFont, 0
    je ModeFontReady
    invoke SelectObject, hMemDC, hMenuFont
    mov hOldMenuFont, eax
ModeFontReady:
    mov eax, winWidth
    shr eax, 1
    mov ebx, overlayRect.top
    add ebx, 40
    mov esi, OFFSET msgModeTitle
    call DrawGlowText

    add ebx, 90
    mov esi, OFFSET modeRandomStr
    call DrawGlowText

    add ebx, 60
    mov esi, OFFSET modeKeyboardStr
    call DrawGlowText

    cmp hMenuFont, 0
    je ModeFontDone
    invoke SelectObject, hMemDC, hOldMenuFont
ModeFontDone:

    cmp hFont, 0
    je ModeHintReady
    invoke SelectObject, hMemDC, hFont
    mov hOldFont, eax
ModeHintReady:
    push COLOR_MENU_BODY
    push hMemDC
    call SetTextColor@8
    mov eax, winWidth
    shr eax, 1
    mov ebx, overlayRect.bottom
    sub ebx, 60
    mov esi, OFFSET msgModeHint
    call DrawTextLine
    cmp hFont, 0
    je ModeDone
    invoke SelectObject, hMemDC, hOldFont
ModeDone:
    invoke SetTextAlign, hMemDC, TA_LEFT

    pop ebp
    ret
DrawModeScreen ENDP

;---------------------------------------------------
; DrawHistoryScreen
; Description : Render history overlay
;---------------------------------------------------
DrawHistoryScreen PROC
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    push edx
    push esi
    push edi

    call DrawPopupPanel
    invoke SetBkMode, hMemDC, TRANSPARENT
    invoke SetTextAlign, hMemDC, TA_CENTER

    cmp hMenuFont, 0
    je HistoryFontReady
    invoke SelectObject, hMemDC, hMenuFont
    mov hOldMenuFont, eax
HistoryFontReady:
    mov eax, winWidth
    shr eax, 1
    mov ebx, overlayRect.top
    add ebx, 30
    mov esi, OFFSET historyTitle
    call DrawGlowText

    cmp hMenuFont, 0
    je HistoryListStart
    invoke SelectObject, hMemDC, hOldMenuFont
HistoryListStart:
    invoke SetTextAlign, hMemDC, TA_LEFT
    cmp hFont, 0
    je HistoryListFontReady
    invoke SelectObject, hMemDC, hFont
    mov hOldFont, eax
HistoryListFontReady:
    push COLOR_MENU_BODY
    push hMemDC
    call SetTextColor@8
    mov edx, overlayRect.left
    add edx, 40
    mov eax, historyCount
    cmp eax, 0
    jne HistoryHasEntries
    mov eax, edx
    mov ebx, overlayRect.top
    add ebx, 130
    mov esi, OFFSET historyEmpty
    call DrawTextLine
    jmp HistoryDone

HistoryHasEntries:
    mov ecx, historyCount
    mov edx, historyIndex
    mov ebx, overlayRect.top
    add ebx, 130
    cmp historyCount, HISTORY_MAX
    jne HistoryStartZero
    mov edi, edx
    jmp HistoryLoopStart
HistoryStartZero:
    xor edi, edi
HistoryLoopStart:
    mov eax, edi
    mov edx, HISTORY_LINE_LEN
    imul eax, edx
    mov esi, OFFSET historyLines
    add esi, eax
    mov eax, overlayRect.left
    add eax, 40
    call DrawTextLine
    inc edi
    cmp edi, HISTORY_MAX
    jb HistoryNext
    xor edi, edi
HistoryNext:
    add ebx, 22
    loop HistoryLoopStart

HistoryDone:
    invoke SetTextAlign, hMemDC, TA_CENTER
    push COLOR_MENU_BODY
    push hMemDC
    call SetTextColor@8
    mov eax, winWidth
    shr eax, 1
    mov ebx, overlayRect.bottom
    sub ebx, 40
    mov esi, OFFSET msgHistoryHint
    call DrawTextLine

    cmp hFont, 0
    je HistoryDoneFont
    invoke SelectObject, hMemDC, hOldFont
HistoryDoneFont:
    invoke SetTextAlign, hMemDC, TA_LEFT
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop ebp
    ret
DrawHistoryScreen ENDP

;---------------------------------------------------
; DrawGameOverScreen
; Description : Render game-over overlay
;---------------------------------------------------
DrawGameOverScreen PROC
    push ebp
    mov ebp, esp

    invoke SetBkMode, hMemDC, TRANSPARENT
    push COLOR_HUD_TEXT
    push hMemDC
    call SetTextColor@8

    mov eax, 180
    mov ebx, 180
    mov esi, OFFSET overMsg1
    call DrawTextLine

    mov eax, 180
    mov ebx, 230
    mov esi, OFFSET overMsg2
    call DrawTextLine

    pop ebp
    ret
DrawGameOverScreen ENDP

;---------------------------------------------------
; DrawHUDPanel
; Description : Draw right-side HUD with live stats
;---------------------------------------------------
DrawHUDPanel PROC
    push ebp
    mov ebp, esp

    invoke CreateSolidBrush, COLOR_HUD_BG
    mov hBrush, eax
    invoke FillRect, hMemDC, ADDR hudRect, hBrush
    invoke DeleteObject, hBrush

    invoke SetBkMode, hMemDC, TRANSPARENT
    push COLOR_HUD_TEXT
    push hMemDC
    call SetTextColor@8

    cmp hFont, 0
    je HudFontReady
    invoke SelectObject, hMemDC, hFont
    mov hOldFont, eax
HudFontReady:
    mov edx, mazeWidthPx
    add edx, 20

    mov eax, edx
    mov ebx, 20
    mov esi, OFFSET hudLine1
    call DrawTextLine

    mov esi, OFFSET lineBuf
    mov edi, OFFSET lineBuf
    mov esi, OFFSET hudLine2
    call AppendText
    mov esi, OFFSET professor.profName
    call AppendText
    mov BYTE PTR [edi], 0
    mov eax, edx
    mov ebx, 60
    mov esi, OFFSET lineBuf
    call DrawTextLine

    mov edi, OFFSET lineBuf
    mov esi, OFFSET hudLine3
    call AppendText
    mov al, '('
    call AppendChar
    mov eax, professor.posX
    call AppendDec
    mov al, ','
    call AppendChar
    mov eax, professor.posY
    call AppendDec
    mov al, ')'
    call AppendChar
    mov BYTE PTR [edi], 0
    mov eax, edx
    mov ebx, 95
    mov esi, OFFSET lineBuf
    call DrawTextLine

    mov edi, OFFSET lineBuf
    mov esi, OFFSET hudLine4
    call AppendText
    mov eax, professor.wallet
    call AppendDec
    mov BYTE PTR [edi], 0
    mov eax, edx
    mov ebx, 130
    mov esi, OFFSET lineBuf
    call DrawTextLine

    mov edi, OFFSET lineBuf
    mov esi, OFFSET hudLine5
    call AppendText
    cmp professor.hasKey, 1
    je HudKeyYes
    mov esi, OFFSET noStr
    jmp HudKeyAppend
HudKeyYes:
    mov esi, OFFSET yesStr
HudKeyAppend:
    call AppendText
    mov BYTE PTR [edi], 0
    mov eax, edx
    mov ebx, 165
    mov esi, OFFSET lineBuf
    call DrawTextLine

    mov edi, OFFSET lineBuf
    mov esi, OFFSET hudLine6
    call AppendText
    mov eax, professor.stepCount
    call AppendDec
    mov BYTE PTR [edi], 0
    mov eax, edx
    mov ebx, 200
    mov esi, OFFSET lineBuf
    call DrawTextLine

    mov edi, OFFSET lineBuf
    mov esi, OFFSET hudLine7
    call AppendText
    mov eax, professor.treasures
    call AppendDec
    mov BYTE PTR [edi], 0
    mov eax, edx
    mov ebx, 235
    mov esi, OFFSET lineBuf
    call DrawTextLine

    mov edi, OFFSET lineBuf
    mov esi, OFFSET hudLine8
    call AppendText
    cmp professor.gameMode, MODE_RANDOM
    je HudModeRandom
    mov esi, OFFSET keyboardStateStr
    jmp HudModeAppend
HudModeRandom:
    mov esi, OFFSET randomStateStr
HudModeAppend:
    call AppendText
    mov BYTE PTR [edi], 0
    mov eax, edx
    mov ebx, 270
    mov esi, OFFSET lineBuf
    call DrawTextLine

    mov eax, edx
    mov ebx, 330
    mov esi, OFFSET hudLine9
    call DrawTextLine

    mov eax, edx
    mov ebx, 360
    mov esi, OFFSET legendTitle
    call DrawTextLine

    mov eax, edx
    mov ebx, 385
    mov ecx, COLOR_WALL
    call DrawLegendSwatch
    mov eax, edx
    add eax, 20
    mov ebx, 385
    mov esi, OFFSET legendWall
    call DrawTextLine

    mov eax, edx
    mov ebx, 405
    mov ecx, COLOR_BUILDING
    call DrawLegendSwatch
    mov eax, edx
    add eax, 20
    mov ebx, 405
    mov esi, OFFSET legendBuilding
    call DrawTextLine

    mov eax, edx
    mov ebx, 425
    mov ecx, COLOR_LAKE
    call DrawLegendSwatch
    mov eax, edx
    add eax, 20
    mov ebx, 425
    mov esi, OFFSET legendLake
    call DrawTextLine

    mov eax, edx
    mov ebx, 445
    mov ecx, COLOR_TRAP
    call DrawLegendSwatch
    mov eax, edx
    add eax, 20
    mov ebx, 445
    mov esi, OFFSET legendTrap
    call DrawTextLine

    mov eax, edx
    mov ebx, 465
    mov ecx, COLOR_PIT
    call DrawLegendSwatch
    mov eax, edx
    add eax, 20
    mov ebx, 465
    mov esi, OFFSET legendPit
    call DrawTextLine

    mov eax, edx
    mov ebx, 485
    mov ecx, COLOR_COIN
    call DrawLegendSwatch
    mov eax, edx
    add eax, 20
    mov ebx, 485
    mov esi, OFFSET legendCoin
    call DrawTextLine

    mov eax, edx
    mov ebx, 505
    mov ecx, COLOR_TREASURE
    call DrawLegendSwatch
    mov eax, edx
    add eax, 20
    mov ebx, 505
    mov esi, OFFSET legendTreasure
    call DrawTextLine

    mov eax, edx
    mov ebx, 525
    mov ecx, COLOR_DEST
    call DrawLegendSwatch
    mov eax, edx
    add eax, 20
    mov ebx, 525
    mov esi, OFFSET legendDest
    call DrawTextLine

    mov eax, edx
    mov ebx, 545
    mov ecx, COLOR_DEST
    call DrawLegendSwatch
    mov eax, edx
    add eax, 20
    mov ebx, 545
    mov esi, OFFSET legendStart
    call DrawTextLine

    mov eax, edx
    mov ebx, 565
    mov ecx, COLOR_VISITED
    call DrawLegendSwatch
    mov eax, edx
    add eax, 20
    mov ebx, 565
    mov esi, OFFSET legendVisited
    call DrawTextLine

    mov eax, edx
    mov ebx, 585
    mov ecx, COLOR_PROF
    call DrawLegendSwatch
    mov eax, edx
    add eax, 20
    mov ebx, 585
    mov esi, OFFSET legendProf
    call DrawTextLine

    cmp hFont, 0
    je HudFontDone
    invoke SelectObject, hMemDC, hOldFont
HudFontDone:

    pop ebp
    ret
DrawHUDPanel ENDP

;---------------------------------------------------
; DrawStatusBar
; Description : Draw bottom status bar
;---------------------------------------------------
DrawStatusBar PROC
    push ebp
    mov ebp, esp

    invoke CreateSolidBrush, COLOR_HUD_BG
    mov hBrush, eax
    invoke FillRect, hMemDC, ADDR statusRect, hBrush
    invoke DeleteObject, hBrush

    invoke SetBkMode, hMemDC, TRANSPARENT
    push COLOR_HUD_ACCENT
    push hMemDC
    call SetTextColor@8

    cmp hFont, 0
    je StatusFontReady
    invoke SelectObject, hMemDC, hFont
    mov hOldFont, eax
StatusFontReady:

    mov eax, 20
    mov ebx, mazeHeightPx
    add ebx, 20
    mov esi, OFFSET hudLine9
    call DrawTextLine

    cmp hFont, 0
    je StatusFontDone
    invoke SelectObject, hMemDC, hOldFont
StatusFontDone:

    pop ebp
    ret
DrawStatusBar ENDP

;---------------------------------------------------
; DrawMazeGrid
; Description : Draw all maze cells as colored blocks
;---------------------------------------------------
DrawMazeGrid PROC
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    xor edi, edi
RowLoop:
    cmp edi, MAZE_ROWS
    jge MazeGridDone

    xor esi, esi
ColLoop:
    cmp esi, MAZE_COLS
    jge NextRow

    mov eax, edi
    imul eax, MAZE_COLS
    add eax, esi
    mov dl, [maze + eax]

    mov eax, esi
    imul eax, cellSize
    mov cellRect.left, eax
    mov ecx, cellSize
    add eax, ecx
    mov cellRect.right, eax

    mov eax, edi
    imul eax, cellSize
    mov cellRect.top, eax
    add eax, ecx
    mov cellRect.bottom, eax

    mov ebx, COLOR_EMPTY
    cmp dl, CELL_WALL
    je CellWall
    cmp dl, CELL_BUILDING
    je CellBuilding
    cmp dl, CELL_LAKE
    je CellLake
    cmp dl, CELL_TRAP
    je CellTrap
    cmp dl, CELL_PIT
    je CellPit
    cmp dl, CELL_COIN
    je CellCoin
    cmp dl, CELL_TREASURE
    je CellTreasure
    cmp dl, CELL_DEST
    je CellDest
    cmp dl, CELL_START
    je CellStart
    jmp CheckVisited

CellWall:
    mov ebx, COLOR_WALL
    jmp DrawCell
CellBuilding:
    mov ebx, COLOR_BUILDING
    jmp DrawCell
CellLake:
    mov ebx, COLOR_LAKE
    jmp DrawCell
CellTrap:
    mov ebx, COLOR_TRAP
    jmp DrawCell
CellPit:
    mov ebx, COLOR_PIT
    jmp DrawCell
CellCoin:
    mov ebx, COLOR_COIN
    jmp DrawCell
CellTreasure:
    mov ebx, COLOR_TREASURE
    jmp DrawCell
CellDest:
    mov ebx, COLOR_DEST
    jmp DrawCell
CellStart:
    mov ebx, COLOR_DEST
    jmp DrawCell

CheckVisited:
    cmp dl, CELL_EMPTY
    jne DrawCell
    mov eax, edi
    imul eax, MAZE_COLS
    add eax, esi
    cmp BYTE PTR [visitedCells + eax], 1
    jne DrawCell
    mov ebx, COLOR_VISITED

DrawCell:
    invoke CreateSolidBrush, ebx
    mov hBrush, eax
    invoke FillRect, hMemDC, ADDR cellRect, hBrush
    invoke DeleteObject, hBrush

    inc esi
    jmp ColLoop

NextRow:
    inc edi
    jmp RowLoop

MazeGridDone:
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret
DrawMazeGrid ENDP

;---------------------------------------------------
; DrawMapFrame
; Description : Draw a thin border around the maze area
;---------------------------------------------------
DrawMapFrame PROC
    push ebp
    mov ebp, esp
    push eax
    push ebx

    mov eax, mazeWidthPx
    mov ebx, mazeHeightPx

    invoke CreateSolidBrush, COLOR_MAP_BORDER
    mov hBrush, eax

    mov cellRect.left, 0
    mov cellRect.top, 0
    mov cellRect.right, eax
    mov cellRect.bottom, 4
    invoke FillRect, hMemDC, ADDR cellRect, hBrush

    mov cellRect.left, 0
    mov eax, ebx
    sub eax, 4
    mov cellRect.top, eax
    mov eax, mazeWidthPx
    mov cellRect.right, eax
    mov cellRect.bottom, ebx
    invoke FillRect, hMemDC, ADDR cellRect, hBrush

    mov cellRect.left, 0
    mov cellRect.top, 0
    mov cellRect.right, 4
    mov cellRect.bottom, ebx
    invoke FillRect, hMemDC, ADDR cellRect, hBrush

    mov eax, mazeWidthPx
    sub eax, 4
    mov cellRect.left, eax
    mov eax, mazeWidthPx
    mov cellRect.right, eax
    mov cellRect.top, 0
    mov cellRect.bottom, ebx
    invoke FillRect, hMemDC, ADDR cellRect, hBrush

    invoke DeleteObject, hBrush

    pop ebx
    pop eax
    pop ebp
    ret
DrawMapFrame ENDP

;---------------------------------------------------
; DrawProfessor
; Description : Draw professor as a filled circle
;---------------------------------------------------
DrawProfessor PROC
    push ebp
    mov ebp, esp

    mov eax, professor.posY
    imul eax, cellSize
    add eax, 2
    mov cellRect.left, eax
    mov edx, cellSize
    sub edx, 2
    add eax, edx
    mov cellRect.right, eax

    mov ebx, professor.posX
    imul ebx, cellSize
    add ebx, 2
    mov cellRect.top, ebx
    add ebx, edx
    mov cellRect.bottom, ebx

    invoke CreateSolidBrush, COLOR_PROF
    mov hBrush, eax
    invoke SelectObject, hMemDC, hBrush
    mov hOldBrush, eax
    invoke Ellipse, hMemDC, cellRect.left, cellRect.top, cellRect.right, cellRect.bottom
    invoke SelectObject, hMemDC, hOldBrush
    invoke DeleteObject, hBrush

    pop ebp
    ret
DrawProfessor ENDP

;---------------------------------------------------
; DrawFrame
; Description : Render the entire frame to the memory DC
;---------------------------------------------------
DrawFrame PROC
    push ebp
    mov ebp, esp

    call DrawBackground

    cmp professor.gameState, STATE_MENU
    je ShowMenuOnly
    cmp professor.gameState, STATE_HISTORY
    je ShowHistoryOnly
    cmp professor.gameState, STATE_NAME
    je ShowNameOnly
    cmp professor.gameState, STATE_MODE
    je ShowModeOnly

    call DrawMazeGrid
    call DrawMapFrame
    call DrawProfessor
    call DrawHUDPanel
    call DrawStatusBar

    cmp professor.gameState, STATE_OVER
    je ShowGameOverOverlay
    jmp FrameDone

ShowHistoryOnly:
    call DrawHistoryScreen
    jmp FrameDone

ShowMenuOnly:
    call DrawMenuScreen
    jmp FrameDone

ShowNameOnly:
    call DrawNameScreen
    jmp FrameDone

ShowModeOnly:
    call DrawModeScreen
    jmp FrameDone

ShowGameOverOverlay:
    call DrawGameOverScreen

FrameDone:
    pop ebp
    ret
DrawFrame ENDP
;---------------------------------------------------
; WndProc
;---------------------------------------------------
WndProc PROC hWndParam:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

    mov eax, uMsg
    cmp eax, WM_CREATE
    je OnCreate

    cmp eax, WM_PAINT
    je OnPaint

    cmp eax, WM_TIMER
    je OnTimer

    cmp eax, WM_KEYDOWN
    je OnKeyDown

    cmp eax, WM_CHAR
    je OnChar

    cmp eax, WM_DESTROY
    je OnDestroy

    jmp OnDefault

OnCreate:
    mov eax, hWndParam
    mov hWnd, eax
    mov gameHwnd, eax

    invoke GetDC, hWndParam
    mov hDC, eax

    invoke CreateCompatibleDC, hDC
    mov hMemDC, eax
    test eax, eax
    jne MemDCOk
    invoke MessageBoxA, NULL, ADDR msgMemDcFail, ADDR windowTitle, 0
    jmp InitDone
MemDCOk:

    invoke CreateCompatibleBitmap, hDC, winWidth, winHeight
    mov hMemBmp, eax
    test eax, eax
    jne MemBmpOk
    invoke MessageBoxA, NULL, ADDR msgMemBmpFail, ADDR windowTitle, 0
    jmp InitDone
MemBmpOk:

    invoke SelectObject, hMemDC, hMemBmp
    mov hOldBmp, eax
    cmp eax, 0
    je MemSelFail
    cmp eax, -1
    je MemSelFail
    mov useMemBuffer, 1
    jmp InitDone
MemSelFail:
    invoke MessageBoxA, NULL, ADDR msgMemSelFail, ADDR windowTitle, 0

InitDone:
    call InitGameState
    call UpdateLayout
    invoke InvalidateRect, hWndParam, NULL, FALSE

    xor eax, eax
    ret
OnPaint:
    invoke BeginPaint, hWndParam, ADDR paintStruct
    cmp useMemBuffer, 1
    jne PaintDirect
    call DrawFrame
    invoke BitBlt, paintStruct.hdc, 0, 0, winWidth, winHeight, hMemDC, 0, 0, SRCCOPY
    jmp PaintDone
PaintDirect:
    push hMemDC
    mov eax, paintStruct.hdc
    mov hMemDC, eax
    call DrawFrame
    pop hMemDC
PaintDone:
    invoke EndPaint, hWndParam, ADDR paintStruct
    mov eax, 0
    ret

OnTimer:
    cmp wParam, ID_TIMER
    je OnGameTimer
    cmp wParam, ID_MENU_TIMER
    je OnMenuTimer
    jmp OnTimerEnd

OnGameTimer:
    cmp professor.gameState, STATE_PLAYING
    jne OnTimerEnd
    cmp professor.gameMode, MODE_RANDOM
    jne OnTimerEnd
    call DoRandomStep
    call DrawFrame
    invoke InvalidateRect, hWndParam, NULL, FALSE
    jmp OnTimerEnd

OnMenuTimer:
    invoke KillTimer, hWndParam, ID_MENU_TIMER
    call InitGameState
    call DrawFrame
    invoke InvalidateRect, hWndParam, NULL, FALSE
OnTimerEnd:
    mov eax, 0
    ret

OnKeyDown:
    cmp professor.gameState, STATE_MENU
    jne CheckHistoryKeys

    cmp wParam, 'P'
    je EnterNameState
    cmp wParam, 'p'
    je EnterNameState
    cmp wParam, 'H'
    je ShowHistory
    cmp wParam, 'h'
    je ShowHistory
    cmp wParam, 'Q'
    je QuitNow
    cmp wParam, 'q'
    je QuitNow
    cmp wParam, VK_ESCAPE
    je QuitNow
    jmp KeyDone

CheckHistoryKeys:
    cmp professor.gameState, STATE_HISTORY
    jne CheckNameKeys

    cmp wParam, VK_ESCAPE
    je BackToMenu
    cmp wParam, 'H'
    je BackToMenu
    cmp wParam, 'h'
    je BackToMenu
    cmp wParam, VK_RETURN
    je BackToMenu
    jmp KeyDone

CheckNameKeys:
    cmp professor.gameState, STATE_NAME
    jne CheckModeKeys

    cmp wParam, VK_ESCAPE
    je BackToMenu
    jmp KeyDone

CheckModeKeys:
    cmp professor.gameState, STATE_MODE
    jne CheckPlayingKeys

    cmp wParam, 'R'
    je StartRandomMode
    cmp wParam, 'r'
    je StartRandomMode
    cmp wParam, 'K'
    je StartKeyboardMode
    cmp wParam, 'k'
    je StartKeyboardMode
    cmp wParam, VK_ESCAPE
    je BackToMenu
    jmp KeyDone

EnterNameState:
    invoke KillTimer, hWndParam, ID_MENU_TIMER
    call ClearNameInput
    mov nameIgnoreChar, 1
    mov professor.gameState, STATE_NAME
    call DrawFrame
    invoke InvalidateRect, hWndParam, NULL, FALSE
    jmp KeyDone

ShowHistory:
    mov professor.gameState, STATE_HISTORY
    call DrawFrame
    invoke InvalidateRect, hWndParam, NULL, FALSE
    jmp KeyDone

BackToMenu:
    mov professor.gameState, STATE_MENU
    call DrawFrame
    invoke InvalidateRect, hWndParam, NULL, FALSE
    jmp KeyDone

StartRandomMode:
    cmp nameLen, 0
    jne StartRandomNameReady
    mov edi, OFFSET professor.profName
    mov esi, OFFSET defaultName
    call AppendText
    mov BYTE PTR [edi], 0
    mov esi, OFFSET defaultName
    call StrLen
    mov nameLen, eax
StartRandomNameReady:
    invoke KillTimer, hWndParam, ID_MENU_TIMER
    call InitGameState
    call InitMaze
    mov professor.gameMode, MODE_RANDOM
    mov professor.gameState, STATE_PLAYING
    invoke SetTimer, hWndParam, ID_TIMER, 200, NULL
    call DrawFrame
    invoke InvalidateRect, hWndParam, NULL, FALSE
    jmp KeyDone

StartKeyboardMode:
    cmp nameLen, 0
    jne StartKeyboardNameReady
    mov edi, OFFSET professor.profName
    mov esi, OFFSET defaultName
    call AppendText
    mov BYTE PTR [edi], 0
    mov esi, OFFSET defaultName
    call StrLen
    mov nameLen, eax
StartKeyboardNameReady:
    invoke KillTimer, hWndParam, ID_MENU_TIMER
    call InitGameState
    call InitMaze
    mov professor.gameMode, MODE_KEYBOARD
    mov professor.gameState, STATE_PLAYING
    invoke KillTimer, hWndParam, ID_TIMER
    call DrawFrame
    invoke InvalidateRect, hWndParam, NULL, FALSE
    jmp KeyDone

CheckPlayingKeys:
    cmp professor.gameState, STATE_PLAYING
    jne KeyDone

    cmp wParam, 'W'
    je DoMoveUp
    cmp wParam, 'w'
    je DoMoveUp
    cmp wParam, VK_UP
    je DoMoveUp

    cmp wParam, 'S'
    je DoMoveDown
    cmp wParam, 's'
    je DoMoveDown
    cmp wParam, VK_DOWN
    je DoMoveDown

    cmp wParam, 'A'
    je DoMoveLeft
    cmp wParam, 'a'
    je DoMoveLeft
    cmp wParam, VK_LEFT
    je DoMoveLeft

    cmp wParam, 'D'
    je DoMoveRight
    cmp wParam, 'd'
    je DoMoveRight
    cmp wParam, VK_RIGHT
    je DoMoveRight

    cmp wParam, VK_ESCAPE
    je QuitNow
    jmp KeyDone

DoMoveUp:
    call MoveUp
    jmp PostMove
DoMoveDown:
    call MoveDown
    jmp PostMove
DoMoveLeft:
    call MoveLeft
    jmp PostMove
DoMoveRight:
    call MoveRight

PostMove:
    call StumbleCheck
    call RecordStep
    mov eax, professor.stepCount
    cmp eax, MAX_STEPS
    jb PostMoveDraw
    mov eax, TERM_STEPS
    call EndGame
PostMoveDraw:
    call DrawFrame
    invoke InvalidateRect, hWndParam, NULL, FALSE
    jmp KeyDone

QuitNow:
    invoke PostQuitMessage, 0

KeyDone:
    mov eax, 0
    ret

OnChar:
    cmp professor.gameState, STATE_NAME
    jne CharDone

    cmp nameIgnoreChar, 0
    je NameCharReady
    mov nameIgnoreChar, 0
    jmp CharDone

NameCharReady:

    mov eax, wParam
    cmp eax, VK_RETURN
    je NameEnter
    cmp eax, VK_BACK
    je NameBackspace
    cmp eax, 32
    jb CharDone
    cmp eax, 126
    ja CharDone
    mov ecx, nameLen
    cmp ecx, NAME_MAX
    jae CharDone
    mov esi, OFFSET professor.profName
    add esi, ecx
    mov [esi], al
    inc ecx
    mov nameLen, ecx
    mov BYTE PTR [esi + 1], 0
    jmp CharRedraw

NameBackspace:
    mov ecx, nameLen
    cmp ecx, 0
    je CharDone
    dec ecx
    mov nameLen, ecx
    mov esi, OFFSET professor.profName
    add esi, ecx
    mov BYTE PTR [esi], 0
    jmp CharRedraw

NameEnter:
    cmp nameLen, 0
    jne NameEnterDone
    mov edi, OFFSET professor.profName
    mov esi, OFFSET defaultName
    call AppendText
    mov BYTE PTR [edi], 0
    mov esi, OFFSET defaultName
    call StrLen
    mov nameLen, eax
NameEnterDone:
    mov professor.gameState, STATE_MODE
    call DrawFrame
    invoke InvalidateRect, hWndParam, NULL, FALSE
    jmp CharDone

CharRedraw:
    call DrawFrame
    invoke InvalidateRect, hWndParam, NULL, FALSE

CharDone:
    mov eax, 0
    ret

OnDestroy:
    invoke KillTimer, hWndParam, ID_TIMER
    invoke KillTimer, hWndParam, ID_MENU_TIMER
    cmp professor.outcome, 0
    jne SkipDestroyLog
    call WriteAdventureLog
SkipDestroyLog:
    cmp useMemBuffer, 1
    jne SkipMemDcFree
    invoke SelectObject, hMemDC, hOldBmp
    invoke DeleteObject, hMemBmp
    invoke DeleteDC, hMemDC
SkipMemDcFree:
    cmp hMenuFont, 0
    je SkipMenuFontFree
    invoke DeleteObject, hMenuFont
SkipMenuFontFree:
    cmp hFont, 0
    je SkipHudFontFree
    invoke DeleteObject, hFont
SkipHudFontFree:
    cmp hDC, 0
    je SkipReleaseDC
    invoke ReleaseDC, hWndParam, hDC
SkipReleaseDC:
    invoke PostQuitMessage, 0
    mov eax, 0
    ret

OnDefault:
    invoke DefWindowProcA, hWndParam, uMsg, wParam, lParam
    ret
WndProc ENDP
;---------------------------------------------------
; WinMain
;---------------------------------------------------
WinMain PROC hInst:DWORD, hPrev:DWORD, lpCmdLine:DWORD, nCmdShow:DWORD

    LOCAL wc:WNDCLASSEXA

    mov eax, hInst
    mov hInstance, eax

    cmp eax, 0
    jne HaveInstance

    invoke GetModuleHandleA, NULL
    mov hInstance, eax

HaveInstance:

    invoke GetSystemMetrics, SM_CXSCREEN
    mov winWidth, eax
    invoke GetSystemMetrics, SM_CYSCREEN
    mov winHeight, eax

    mov DWORD PTR wc.cbSize, SIZEOF WNDCLASSEXA
    mov DWORD PTR wc.style, CS_HREDRAW or CS_VREDRAW or CS_DBLCLKS
    mov DWORD PTR wc.lpfnWndProc, OFFSET WndProc
    mov DWORD PTR wc.cbClsExtra, 0
    mov DWORD PTR wc.cbWndExtra, 0

    mov eax, hInstance
    mov DWORD PTR wc.hInstance, eax

    invoke LoadIconA, NULL, IDI_APPLICATION
    mov DWORD PTR wc.hIcon, eax
    mov DWORD PTR wc.hIconSm, eax

    invoke LoadCursorA, NULL, IDC_ARROW
    mov DWORD PTR wc.hCursor, eax

    invoke CreateSolidBrush, COLOR_BG
    mov DWORD PTR wc.hbrBackground, eax

    mov DWORD PTR wc.lpszMenuName, NULL
    mov DWORD PTR wc.lpszClassName, OFFSET className

    invoke RegisterClassExA, ADDR wc
    test eax, eax
    jne ClassOk
    invoke MessageBoxA, NULL, ADDR msgRegFail, ADDR windowTitle, 0
    mov eax, 1
    ret
ClassOk:

    invoke CreateWindowExA,\
        WS_EX_APPWINDOW,\
        ADDR className,\
        ADDR windowTitle,\
        WS_POPUP or WS_VISIBLE,\
        0,\
        0,\
        winWidth,\
        winHeight,\
        NULL,\
        NULL,\
        hInstance,\
        NULL
    test eax, eax
    jne WindowOk
    invoke MessageBoxA, NULL, ADDR msgCreateFail, ADDR windowTitle, 0
    mov eax, 2
    ret
WindowOk:
    mov hWnd, eax
    mov gameHwnd, eax

    invoke ShowWindow, hWnd, SW_SHOW
    invoke UpdateWindow, hWnd

MessageLoop:

    invoke GetMessageA, ADDR msg, NULL, 0, 0

    cmp eax, 0
    je LoopDone

    invoke TranslateMessage, ADDR msg
    invoke DispatchMessageA, ADDR msg

    jmp MessageLoop

LoopDone:
    mov eax, msg.wParam
    ret

WinMain ENDP

;---------------------------------------------------
; main
; Description : Program entry wrapper
;---------------------------------------------------
main PROC
    call Randomize
    invoke GetModuleHandleA, NULL
    invoke WinMain, eax, NULL, NULL, SW_SHOW
    invoke ExitProcess, eax
main ENDP

END main
