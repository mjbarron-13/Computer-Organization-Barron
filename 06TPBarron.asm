section .data
    prompt db "Enter a decimal number (0 to exit): ", 0
    binary_msg db "Binary: ", 0
    newline db 10, 0
    zero db "0", 0

section .bss
    input resb 32       ; Buffer for user input
    binary resb 33      ; Buffer for binary representation (32 bits + null)

section .text
    global _start

_start:
    ; Main program loop
    .main_loop:
        ; Display prompt
        mov eax, prompt
        call print_string
        
        ; Read user input
        mov eax, input
        mov ebx, 32     ; Maximum length
        call read_string
        
        ; Check if input is "0"
        mov eax, input
        mov ebx, zero
        call compare_string
        cmp eax, 0
        je .exit_program
        
        ; Convert string to integer
        mov eax, input
        call string_to_int
        
        ; Convert integer to binary string
        mov ebx, binary
        call int_to_binary
        
        ; Display binary message
        mov eax, binary_msg
        call print_string
        
        ; Display binary result
        mov eax, binary
        call print_string
        
        ; New line
        mov eax, newline
        call print_string
        
        jmp .main_loop
    
    .exit_program:
        ; Exit program
        mov eax, 1      ; sys_exit
        xor ebx, ebx    ; exit code 0
        int 0x80

; Function to print a null-terminated string
; Input: EAX = string address
print_string:
    push ebx
    push ecx
    push edx
    
    mov ecx, eax        ; String address
    mov edx, 0         ; Calculate length
    
    .length_loop:
        cmp byte [eax+edx], 0
        je .print
        inc edx
        jmp .length_loop
    
    .print:
        mov eax, 4      ; sys_write
        mov ebx, 1      ; stdout
        int 0x80
    
    pop edx
    pop ecx
    pop ebx
    ret

; Function to read a string from stdin
; Input: EAX = buffer address, EBX = max length
read_string:
    push ebx
    push ecx
    push edx
    
    mov ecx, eax        ; Buffer address
    mov edx, ebx        ; Maximum length
    
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    int 0x80
    
    ; Null-terminate the string
    mov byte [ecx+eax-1], 0
    
    pop edx
    pop ecx
    pop ebx
    ret

; Function to compare two strings
; Input: EAX = string1, EBX = string2
; Output: EAX = 0 if equal, non-zero otherwise
compare_string:
    push ebx
    push ecx
    
    .compare_loop:
        mov cl, [eax]
        mov ch, [ebx]
        cmp cl, ch
        jne .not_equal
        test cl, cl
        jz .equal
        inc eax
        inc ebx
        jmp .compare_loop
    
    .equal:
        xor eax, eax
        jmp .done
    
    .not_equal:
        sub eax, ebx
    
    .done:
        pop ecx
        pop ebx
        ret

; Function to convert string to integer (supports negative numbers)
; Input: EAX = string address
; Output: EAX = integer value
string_to_int:
    push ebx
    push ecx
    push edx
    push esi
    
    mov esi, eax        ; String address
    xor eax, eax        ; Result
    xor ecx, ecx        ; Current character
    xor ebx, ebx        ; Sign flag (0 = positive, 1 = negative)
    
    ; Check for sign
    mov cl, [esi]
    cmp cl, '-'
    jne .positive
    mov ebx, 1
    inc esi
    
    .positive:
        mov cl, [esi]
        test cl, cl
        jz .done
        
        ; Check if digit
        cmp cl, '0'
        jb .invalid
        cmp cl, '9'
        ja .invalid
        
        ; Multiply current result by 10
        mov edx, 10
        mul edx
        
        ; Add current digit
        sub cl, '0'
        add eax, ecx
        
        inc esi
        jmp .positive
    
    .invalid:
        ; Handle invalid input (simple implementation)
        ; In a real program, you'd want better error handling
    
    .done:
        ; Apply sign if necessary
        test ebx, ebx
        jz .positive_result
        neg eax
    
    .positive_result:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret

; Function to convert integer to binary string
; Input: EAX = integer value, EBX = buffer address
int_to_binary:
    push eax
    push ebx
    push ecx
    push edx
    
    mov ecx, 32         ; 32 bits to process
    mov edx, ebx        ; Buffer address
    
    ; Handle zero case
    test eax, eax
    jnz .convert
    mov byte [edx], '0'
    mov byte [edx+1], 0
    jmp .done
    
    .convert:
        ; Start from the highest bit
        mov ecx, 31
        xor ebx, ebx    ; Flag for leading zeros
        
        .bit_loop:
            bt eax, ecx
            jc .set_bit
            ; Zero bit
            test ebx, ebx
            jz .next_bit  ; Skip leading zeros
            mov byte [edx], '0'
            inc edx
            jmp .next_bit
            
            .set_bit:
                mov ebx, 1    ; Found first 1
                mov byte [edx], '1'
                inc edx
            
            .next_bit:
                dec ecx
                jns .bit_loop
        
        ; Null-terminate the string
        mov byte [edx], 0
    
    .done:
        pop edx
        pop ecx
        pop ebx
        pop eax
        ret
