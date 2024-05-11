;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; A simple boot sector that loads a kernel, kernel.c, into memory
; at the physical memory address 0x1000.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Start the boot sector by the traditional offset so our code knows
; where it is located.
[org 0x7c00]

; The kernel offset, where it will be loaded, is the physical
; memory address 0x1000. When our boot loader finishes it will
; call the instructions at physical memory address 0x1000 and
; that is where our kernel.c instructions will be waiting.
   KERNEL_OFFSET equ 0x1000

; Save the boot drive to the location of BOOT_DRIVE.
   mov [BOOT_DRIVE], dl

; Move the base of the stack to somewhere safe. Then
; copy the stack pointer to start at the base pointer.
   mov bp, 0x9000
   mov sp, bp

; Load the kernel into memory at address 0x1000.
   call load_kernel

; Switch over to 32-bit user mode.
   call switch_to_pm

; Hang, we are done!
   jmp $


; Include some important functions.
   %include "boot/disk/disk_load.asm"
   %include "boot/pm/gdt.asm"
   %include "boot/pm/switch_to_pm.asm"

; Load the kernel using 16-bit real mode.
[bits 16]

; Load our kernel from the disk. The kernel
; starts at sector 2 since we did a cat to 
; combine the boot_sect.bin and kernel.bin
; into a file called os-image. The boot_sect.bin
; is one sector in size because we pad it down at 
; the bottom to be 512 bytes.
load_kernel:
; Load the instructions, from sector 2, to memory
; at KERNEL_OFFSET, which is 0x1000, in physical
; memory.
   mov bX, KERNEL_OFFSET
   mov dh, 15
   mov dl, [BOOT_DRIVE]
   call disk_load

   ret

[bits 32]

; We are in 32-bit land, call our kernel code.
BEGIN_PM:
; Call our kernel code which starts at KERNEL_OFFSET which we
; set to physical memory address 0x1000
   call KERNEL_OFFSET

; Hang and enjoy the X that we see on the screen and revel in 
; our success. Drink some coffee. Enjoy the song of a bird and
; know that we just did something that 99.999 percent of the
; world population could never do.
   jmp $

; Some variables, store our boot drive and also some messages
; to print out so we know what is happening as we bootstrap
; our kernel.
BOOT_DRIVE: db 0

; Pad the end of the first sector with 0 so we have exactly
; 510 bytes and then 511 and 512 are the magic number so that
; the BIOS knows to boot it. We end with a complete first 
; sector which is 512 bytes.
times 510-($-$$) db 0
dw 0xaa55
