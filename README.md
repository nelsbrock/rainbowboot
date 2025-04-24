# rainbowboot

This is a x86 boot sector demo that prints a rolling rainbow pattern to screen.

Licensed under 

## How to use

Make sure you have NASM (and QEMU, GDB and DOSBox if applicable) installed.

### Building the disk image

```sh
make
```

### Running on QEMU

```sh
make run
```

### Running on DOSBox

```sh
make run-dosbox
```

### Debugging using QEMU and GDB

Starting QEMU in debug mode:

```sh
make run-gdb
```

Attaching to the virtual machine:

```sh
make attach
```
