src_dir := src
build_dir := build

asm := nasm

qemu := qemu-system-i386
qemu_flags := -drive file=$(build_dir)/rainbowboot.img,format=raw
qemu_flags_gdb := -s -S

dosbox := dosbox

.PHONY: all run run-gdb run-dosbox attach clean

all: $(build_dir)/rainbowboot.img

run: $(build_dir)/rainbowboot.img
	$(qemu) $(qemu_flags)

run-gdb: $(build_dir)/rainbowboot.img
	$(qemu) $(qemu_flags_gdb) $(qemu_flags)

run-dosbox: $(build_dir)/rainbowboot.img
	$(dosbox) -c "BOOT $(build_dir)/rainbowboot.img"

attach: $(build_dir)/rainbowboot.elf
	gdb $(build_dir)/rainbowboot.elf \
		-ex "target remote localhost:1234" \
		-ex "set architecture i8086"

clean:
	rm -rf $(build_dir)

$(build_dir)/rainbowboot.img: $(build_dir)/rainbowboot.elf | $(build_dir)
	objcopy -O binary $(build_dir)/rainbowboot.elf $(build_dir)/rainbowboot.img

$(build_dir)/rainbowboot.elf: $(build_dir)/rainbowboot.o | $(build_dir)
	ld -Ttext=0x7c00 -melf_i386 $(build_dir)/rainbowboot.o -o $(build_dir)/rainbowboot.elf

$(build_dir)/rainbowboot.o: $(src_dir)/rainbowboot.s | $(build_dir)
	$(asm) -f elf32 -g3 -F dwarf $(src_dir)/rainbowboot.s -o $(build_dir)/rainbowboot.o

$(build_dir):
	mkdir -p $(build_dir)
