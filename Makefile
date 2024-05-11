# Default target is our custom kernel.
all: os-image

run: all
	qemu-system-x86_64 -drive file=os-image,format=raw

# The binary of our kernel that we will cat with boot sector code.
kernel/kernel.bin: kernel/kernel_entry.o kernel/kernel.o
	ld -no-pie -melf_i386 -o kernel/kernel.bin -Ttext 0x1000 kernel/kernel_entry.o kernel/kernel.o --oformat binary

# The main kernel code.
kernel/kernel.o : kernel/kernel.c
	gcc -m32 -ffreestanding -c kernel/kernel.c -fno-pic -o kernel/kernel.o

# The kernel entry code that ensures we get to our main in kernel.c.
kernel/kernel_entry.o : kernel/kernel_entry.asm
	nasm kernel/kernel_entry.asm -f elf -o kernel/kernel_entry.o

# Our custom boot sector code for bootstrapping our kernel.
boot/boot_sect.o : boot/boot_sect.asm
	nasm boot/boot_sect.asm -f bin -o boot/boot_sect.bin

# The main custom kernel that we can then run with Qemu or burn on a boot disk.
os-image: boot/boot_sect.o kernel/kernel.bin kernel/kernel_entry.o
	cat boot/boot_sect.bin kernel/kernel.bin > os-image
	dd if=/dev/zero bs=512 count=60 >> os-image

# Clean all the binary and object files.
clean:
	rm kernel/*.bin kernel/*.o boot/*.bin os-image
