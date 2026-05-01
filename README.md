# Playing-With-Copyfail

## Purpose
This repo contains some of my exploration of the Copyfail exploit. The original PoC (https://copy.fail/#exploit) allowed the attacker to spawn an interactive shell by writing a malicious ELF binary into the page cache of the `su` binary.

I thought it might be fun to recompile the malicious ELF into a one shot instead of an interactive shell. I think a root shell spawned by a python parent process is pretty suspicious for any half decent detection program. There's really nothing you can do to get around the suspicious syscalls since it's at the heart of the exploit.

So this implementation is written in assembly and just runs `cat /etc/shadow` but of course you can change it to do whatever you like as long as you format the arg table correctly.

#### Updated 05/01/2026
I've also added my own version of the interactive shell payload. Instead of spawning the root shell from the python process, it simply corrupts `su` and tells the user to quickly run it from their normal shell and manually dump `su` from page cache for stealth. This removes the suspicious python process from being a long running part of the exploit. Now your root shell is no longer tied to a python process and the 80+ open fd's are gone.

## Steps
Write your new assembly code.
Compile with:
    `nasm -f elf64 payload.asm -o ./payload.o`
    `ld -o ./payload ./payload.o`

Run compress.py to get the compressed hex.
Add the hex into exploit.py

## Changes
* I also added a call to close the `su` fd after the writing is complete.
* I added some code to fix leaking fd's caused by the larger payload.
* I added some python code at the very end to dump the page cache for the `su` binary. I did this because after the exploit is run the `su` binary in memory is corrupted for the entire machine. This stops someone else from accidentally running your exploit instead of the legitimate `su` binary.
