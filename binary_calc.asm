section .data
    msg1 db 'Enter first number: ', 0
    msg2 db 'Enter second number: ', 0
    res_msg db 'Result: ', 0
    newline db 10, 0
    fmt db '%d', 0

section .bss
    num1 resb 4
    num2 resb 4
    result resb 4

section .text
    global main
    extern printf, scanf

main:
    ; Prompt for first number
    push msg1
    call printf
    add esp, 4
    
    ; Read first number
    push num1
    push fmt
    call scanf
    add esp, 8
    
    ; Prompt for second number
    push msg2
    call printf
    add esp, 4
    
    ; Read second number
    push num2
    push fmt
    call scanf
    add esp, 8
    
    ; Load numbers into registers
    mov eax, dword [num1]
    mov ebx, dword [num2]
    
    ; Perform Addition
    add eax, ebx
    mov [result], eax
    push res_msg
    call printf
    add esp, 4
    push dword [result]
    push fmt
    call printf
    add esp, 8
    push newline
    call printf
    add esp, 4
    
    ; Perform Subtraction
    mov eax, dword [num1]
    sub eax, dword [num2]
    mov [result], eax
    push res_msg
    call printf
    add esp, 4
    push dword [result]
    push fmt
    call printf
    add esp, 8
    push newline
    call printf
    add esp, 4
    
    ; Perform AND operation
    mov eax, dword [num1]
    and eax, dword [num2]
    mov [result], eax
    push res_msg
    call printf
    add esp, 4
    push dword [result]
    push fmt
    call printf
    add esp, 8
    push newline
    call printf
    add esp, 4
    
    ; Perform OR operation
    mov eax, dword [num1]
    or eax, dword [num2]
    mov [result], eax
    push res_msg
    call printf
    add esp, 4
    push dword [result]
    push fmt
    call printf
    add esp, 8
    push newline
    call printf
    add esp, 4
    
    ; Perform XOR operation
    mov eax, dword [num1]
    xor eax, dword [num2]
    mov [result], eax
    push res_msg
    call printf
    add esp, 4
    push dword [result]
    push fmt
    call printf
    add esp, 8
    push newline
    call printf
    add esp, 4
    
    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
