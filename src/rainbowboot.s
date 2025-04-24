%define	CHAR	'#'		; printed ASCII character
%define	DELAY	40000		; time delay between lines in microseconds
%define	CCOUNT	7		; amount of colors
;; colors (see https://en.wikipedia.org/wiki/BIOS_color_attributes):
%define	COLORS	0x04, 0x0C, 0x0E, 0x0A, 0x0B, 0x09, 0x05

%define	DELAY_L	(DELAY & 0xFFFF)
%define	DELAY_H	(DELAY >> 16)

bits 16

section .text
	global _start

_start:
	cli			; disable hardware interrupts
	xor	bh, bh		; set page number to 0
	mov	ax, 0x0003	; set video mode
	int	0x10		; --- interrupt
	mov	ah, 0x01	; hide cursor
	mov	ch, 0x3F	; --- ...
	int	0x10		; --- interrupt
	mov	ah, 0x02	; move cursor to bottom
	mov	dh, 24		; --- row 24
	xor	dl, dl		; --- column 0
	int	0x10		; --- interrupt
	xor	si, si		; set color index to 0
.loop	mov	ah, 0x09	; print 80 colored characters
	mov	cx, 80		; --- set count to 80
	mov	al, CHAR	; --- set character
	mov	bl, [colors+si]	; --- set attribute (color)
	int	0x10		; --- interrupt
	mov	ah, 0x86	; sleep
	mov	cx, DELAY_H	; --- set microseconds (cx:dx)
	mov	dx, DELAY_L	; --- ...
	int	0x15		; --- interrupt
	mov	ah, 0x0E	; print line feed
	mov	al, 0x0A	; --- set character to line feed
	int	0x10		; --- interrupt
	inc	si		; increment color index
	cmp	si, CCOUNT	; --- if color index is inside bounds
	jl	.loop		; --- -> repeat loop
	xor	si, si		; --- else, set color index to 0
	jmp	.loop		; repeat loop

colors:	db	COLORS

	times	510 - ($ - $$) db 0
	dw	0xAA55
