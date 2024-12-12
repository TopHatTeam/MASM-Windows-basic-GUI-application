; -------------------------------------------------------------------------
; Hello World Windows GUI application - ANDREW CONNER SKATZES (c) 2024
; -------------------------------------------------------------------------

; WARNING: THIS PROGRAM IS OPENSOURCE AND NOT FOR RESALE. 

; you will need MASM32 for this to be compiled correctly
; I suppose you could assembly it manually, if you know what to do
; any other compiler other than MASM32 will require for you to modify this code for that compiler 
; Other than that I don't much to say enjoy ;)

.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc             ; Windows API 
include \masm32\include\user32.inc              ; Windows user component
include \masm32\include\kernel32.inc            ; Windows kernel
include \masm32\include\gdi32.inc               ; Windows graphic interface

includelib \masm32\lib\user32.lib               ; Windows user component library
includelib \masm32\lib\kernel32.lib             ; Windows kernel library
includelib \masm32\lib\gdi32.lib                ; Windows graphic inteface library

.data
    className db "MyWindowClass", 0             ; Don't know why microsoft has this but it's necessary, you could call it anything do as you please
    windowTitle db "Hello, World!", 0           ; the window's title that's all
    messageText db "Hello world! I am alive", 0 ; the message that'll be displayed to the screen!

.data?
    hInstance HINSTANCE ?
    hwndMain HWND ?

.code
start:

WinMain proc
    LOCAL wc:WNDCLASSEX     ; sets this as a local variable 
    LOCAL msg:MSG           ; sets this as a local variable

    ; Get the instance handle
    invoke GetModuleHandle, NULL
    mov hInstance, eax

    ; Initialize WNDCLASSEX structure
    mov wc.cbSize, SIZEOF WNDCLASSEX
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, offset WndProc
    mov wc.cbClsExtra, 0
    mov wc.cbWndExtra, 0
    mov wc.hInstance, eax
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov wc.hIcon, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov wc.hCursor, eax
    mov wc.hbrBackground, COLOR_WINDOW+1
    mov wc.lpszMenuName, NULL
    lea eax, className
    mov wc.lpszClassName, eax
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov wc.hIconSm, eax

    ; Register the window class
    lea eax, wc
    invoke RegisterClassEx, eax

    ; Create the main window
    invoke CreateWindowEx, 0, addr className, addr windowTitle, \
                           WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, \
                           500, 300, NULL, NULL, hInstance, NULL
    mov hwndMain, eax

    ; Show the window
    invoke ShowWindow, hwndMain, SW_SHOWNORMAL
    invoke UpdateWindow, hwndMain

MessageLoop:
    ; Main message loop
    lea eax, msg
    invoke GetMessage, eax, NULL, 0, 0
    test eax, eax
    jz ExitApp
    lea eax, msg
    invoke TranslateMessage, eax
    lea eax, msg
    invoke DispatchMessage, eax
    jmp MessageLoop

ExitApp:
    ; Exit the application
    invoke ExitProcess, 0

WinMain endp

; Window Procedure
WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    LOCAL hdc:HDC
    LOCAL ps:PAINTSTRUCT

    .if uMsg == WM_PAINT
        ; Begin painting
        invoke BeginPaint, hWnd, addr ps
        mov hdc, eax

        ; Draw text on the window
        invoke TextOutA, hdc, 50, 50, addr messageText, SIZEOF messageText - 1

        ; End painting
        invoke EndPaint, hWnd, addr ps
    .elseif uMsg == WM_DESTROY
        invoke PostQuitMessage, 0
    .else
        invoke DefWindowProc, hWnd, uMsg, wParam, lParam
        ret
    .endif
    xor eax, eax
    ret
WndProc endp

end start
