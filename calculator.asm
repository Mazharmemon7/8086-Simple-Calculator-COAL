; ============================================================
;  Simple Calculator - 8086 Assembly Language
;  Author  : Mazhar Ali
;  Subject : Computer Organization & Assembly Language (COAL)
;  Tool    : EMU8086
;  Desc    : Performs Addition, Subtraction, Multiplication,
;            and Division on two single-digit numbers
; ============================================================

.model small
.stack 100h

.data
    ; ── Messages ──────────────────────────────────────────
    banner   db '============================', 13, 10
             db '   Simple Calculator 8086   ', 13, 10
             db '============================', 13, 10, '$'

    msg1     db 13, 10, 'Enter First Number  (0-9): $'
    msg2     db 13, 10, 'Enter Second Number (0-9): $'

    menuMsg  db 13, 10, '----------------------------', 13, 10
             db 'Select Operation:', 13, 10
             db '  1. Addition      (+)', 13, 10
             db '  2. Subtraction   (-)', 13, 10
             db '  3. Multiplication(*)', 13, 10
             db '  4. Division      (/)', 13, 10
             db '----------------------------', 13, 10
             db 'Your choice: $'

    resMsg   db 13, 10, 'Result = $'
    errDiv   db 13, 10, 'Error: Division by zero!$'
    errInv   db 13, 10, 'Invalid choice! Try again.$'
    newline  db 13, 10, '$'

    ; ── Variables ─────────────────────────────────────────
    num1     db ?       ; first operand  (numeric)
    num2     db ?       ; second operand (numeric)
    choice   db ?       ; menu selection

; ============================================================
.code

; ── Print string (DS:DX) via INT 21H AH=09H ──────────────
print_str macro msg
    lea  dx, msg
    mov  ah, 09h
    int  21h
endm

; ── Read single digit, store numeric value in AL ──────────
read_digit macro
    mov  ah, 01h
    int  21h          ; AL = ASCII character
    sub  al, 48       ; ASCII → numeric  ('0'=48, '1'=49 …)
endm

; ── Print single digit in AL ──────────────────────────────
print_digit macro
    add  al, 48       ; numeric → ASCII
    mov  dl, al
    mov  ah, 02h
    int  21h
endm

; ============================================================
main proc
    ; ── Set up data segment ───────────────────────────────
    mov  ax, @data
    mov  ds, ax

    ; ── Display banner ────────────────────────────────────
    print_str banner

    ; ── Get first number ──────────────────────────────────
    print_str msg1
    read_digit
    mov  num1, al

    ; ── Get second number ─────────────────────────────────
    print_str msg2
    read_digit
    mov  num2, al

    ; ── Display menu ──────────────────────────────────────
    print_str menuMsg
    mov  ah, 01h
    int  21h           ; read menu choice character
    sub  al, 48        ; ASCII → number
    mov  choice, al

    ; ── Branch to selected operation ──────────────────────
    cmp  choice, 1
    je   do_add

    cmp  choice, 2
    je   do_sub

    cmp  choice, 3
    je   do_mul

    cmp  choice, 4
    je   do_div

    ; ── Invalid choice ────────────────────────────────────
    print_str errInv
    jmp  exit_prog

; ── Addition ──────────────────────────────────────────────
do_add:
    mov  al, num1
    add  al, num2       ; AL = num1 + num2
    print_str resMsg
    print_digit
    jmp  exit_prog

; ── Subtraction ───────────────────────────────────────────
do_sub:
    mov  al, num1
    sub  al, num2       ; AL = num1 - num2
    ; Handle negative result
    jns  sub_pos
    neg  al             ; make positive
    mov  dl, '-'        ; print minus sign
    mov  ah, 02h
    int  21h
sub_pos:
    print_str resMsg
    print_digit
    jmp  exit_prog

; ── Multiplication ────────────────────────────────────────
do_mul:
    mov  al, num1
    mov  bl, num2
    mul  bl             ; AX = AL * BL
    ; Result may be 2 digits (e.g. 9*9=81)
    print_str resMsg
    cmp  ax, 9
    jle  mul_single     ; single digit result
    ; Two-digit result: tens in AH-ish, split AX
    mov  bl, 10
    div  bl             ; AL = tens, AH = units
    add  al, 48
    mov  dl, al
    mov  ah, 02h
    int  21h
    mov  al, ah         ; units digit
    print_digit
    jmp  exit_prog
mul_single:
    print_digit
    jmp  exit_prog

; ── Division ──────────────────────────────────────────────
do_div:
    cmp  num2, 0
    je   div_zero       ; guard: no divide by zero
    mov  al, num1
    mov  ah, 0          ; clear AH before DIV
    mov  bl, num2
    div  bl             ; AL = quotient, AH = remainder
    print_str resMsg
    print_digit         ; quotient
    jmp  exit_prog

div_zero:
    print_str errDiv
    jmp  exit_prog

; ── Exit ──────────────────────────────────────────────────
exit_prog:
    print_str newline
    mov  ah, 4ch
    int  21h

main endp
end main
