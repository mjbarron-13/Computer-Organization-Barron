
mov eax, [esi +0x18]
cmp eax, 0x0B
je short 0x0760000C
inc dword ptr [esi+0x18]
jmp 0x0040DD57
dec dword ptr [esi+0x18]
jmp 0x0040DD57
