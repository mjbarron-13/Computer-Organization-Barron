section .data
    ; Prompt and result messages
    msg1        db 0xA, 0xD, "Enter a digit (0-9):", 0
    msg1_len    equ $ - msg1

    below_msg   db 0xA, 0xD, "Input is below 5.", 0
    below_len   equ $ - below_msg

    equal_msg   db 0xA, 0xD, "Input is equal to 5.", 0
    equal_len   equ $ - equal_msg

    above_msg   db 0xA, 0xD, "Input is above 5.", 0
    above_len   equ $ - above_msg

section .bss
    input resb 1    ; Reserve 1 byte for input from user

section .text
    global _start

_start:
    ; Prompt the user to enter a digit 
    mov eax, 4          
    mov ebx, 1         
    mov ecx, msg1       
    mov edx, msg1_len   
    int 0x80           

    ; Read one byte from the user 
    mov eax, 3          
    mov ebx, 0          
    mov ecx, input      
    mov edx, 1          
    int 0x80            

    ; Convert ASCII digit to number 
    movzx eax, byte [input] 
    sub eax, '0'            

    ; Compare the input with 5 
    cmp eax, 5
    jl below
    je equal
    jg above


below:
    ; Set message and length for "below" case
    mov ecx, below_msg     ; pointer to "Input is below 5." string
    mov edx, below_len     ; length of the message

    ; Call print procedure
    call print_msg

    ; Exit program
    jmp exit


equal:
    ; Set message and length for "equal" case
    mov ecx, equal_msg     ; pointer to "Input is equal to 5." string
    mov edx, equal_len     ; length of the message

    ; Call print procedure
    call print_msg

    ; Exit program
    jmp exit



above:
    ; Set message and length for "above" case
    mov ecx, above_msg     ; pointer to "Input is above 5." string
    mov edx, above_len     ; length of the message

    ; Call print procedure
    call print_msg

    ; Exit program
    jmp exit


; Procedure to print message
print_msg:
    mov eax, 4          ; sys_write syscall
    mov ebx, 1          ; file descriptor: STDOUT
    int 0x80            ; make the syscall
    ret                 ; return to caller


; Program exit
exit:
    mov eax, 1          ; sys_exit syscall
    xor ebx, ebx        ; exit code 0
    int 0x80            ; make the syscall
