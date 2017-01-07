;****************************************************************************************************************************************************
;*	HELLO.ASM - Hello World Source Code
;*
;****************************************************************************************************************************************************
;*
;*
;****************************************************************************************************************************************************

;****************************************************************************************************************************************************
;*	Includes
;****************************************************************************************************************************************************
	; system includes
	INCLUDE	"Hardware.inc"

	; project includes

	
;****************************************************************************************************************************************************
;*	user data (constants)
;****************************************************************************************************************************************************


;****************************************************************************************************************************************************
;*	equates
;****************************************************************************************************************************************************


;****************************************************************************************************************************************************
;*	cartridge header
;****************************************************************************************************************************************************

	SECTION	"Org $00",HOME[$00]
RST_00:	
	jp	$100

	SECTION	"Org $08",HOME[$08]
RST_08:	
	jp	$100

	SECTION	"Org $10",HOME[$10]
RST_10:
	jp	$100

	SECTION	"Org $18",HOME[$18]
RST_18:
	jp	$100

	SECTION	"Org $20",HOME[$20]
RST_20:
	jp	$100

	SECTION	"Org $28",HOME[$28]
RST_28:
	jp	$100

	SECTION	"Org $30",HOME[$30]
RST_30:
	jp	$100

	SECTION	"Org $38",HOME[$38]
RST_38:
	jp	$100

	SECTION	"V-Blank IRQ Vector",HOME[$40]
VBL_VECT:
	reti
	
	SECTION	"LCD IRQ Vector",HOME[$48]
LCD_VECT:
	reti

	SECTION	"Timer IRQ Vector",HOME[$50]
TIMER_VECT:
	reti

	SECTION	"Serial IRQ Vector",HOME[$58]
SERIAL_VECT:
	reti

	SECTION	"Joypad IRQ Vector",HOME[$60]
JOYPAD_VECT:
	reti
	
	SECTION	"Start",HOME[$100]
	nop
	jp	Start

	; $0104-$0133 (Nintendo logo - do _not_ modify the logo data here or the GB will not run the program)
	DB	$CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
	DB	$00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
	DB	$BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E

	; $0134-$013E (Game title - up to 11 upper case ASCII characters; pad with $00)
	DB	"HELLO WORLD"
		;0123456789A

	; $013F-$0142 (Product code - 4 ASCII characters, assigned by Nintendo, just leave blank)
	DB	"    "
		;0123

	; $0143 (Color GameBoy compatibility code)
	DB	$00	; $00 - DMG 
			; $80 - DMG/GBC
			; $C0 - GBC Only cartridge

	; $0144 (High-nibble of license code - normally $00 if $014B != $33)
	DB	$00

	; $0145 (Low-nibble of license code - normally $00 if $014B != $33)
	DB	$00

	; $0146 (GameBoy/Super GameBoy indicator)
	DB	$00	; $00 - GameBoy

	; $0147 (Cartridge type - all Color GameBoy cartridges are at least $19)
	DB	$00	; $00 - ROM Only

	; $0148 (ROM size)
	DB	$00	; $00 - 256Kbit = 32Kbyte = 2 banks

	; $0149 (RAM size)
	DB	$00	; $00 - None

	; $014A (Destination code)
	DB	$00	; $01 - All others
			; $00 - Japan

	; $014B (Licensee code - this _must_ be $33)
	DB	$33	; $33 - Check $0144/$0145 for Licensee code.

	; $014C (Mask ROM version - handled by RGBFIX)
	DB	$00

	; $014D (Complement check - handled by RGBFIX)
	DB	$00

	; $014E-$014F (Cartridge checksum - handled by RGBFIX)
	DW	$00


;****************************************************************************************************************************************************
;*	Program Start
;****************************************************************************************************************************************************

	SECTION "Program Start",HOME[$0150]
Start::
	di			;disable interrupts
	ld	sp,$FFFE	;set the stack to $FFFE
	call WAIT_VBLANK	;wait for v-blank

	ld	a,0		;
	ldh	[rLCDC],a	;turn off LCD 

	call CLEAR_MAP	;clear the BG map
	call LOAD_TILES	;load up our tiles
	call LOAD_MAP	;load up our map

	ld	a,%11100100	;load a normal palette up 11 10 01 00 - dark->light
	ldh	[rBGP],a	;load the palette
	
	ld	a,%10010001		;  =$91 
	ldh	[rLCDC],a	;turn on the LCD, BG, etc

Loop::
	halt
	nop
	jp Loop

;***************************************************************
;* Subroutines
;***************************************************************

	SECTION "Support Routines",HOME

WAIT_VBLANK::
	ldh	a,[rLY]		;get current scanline
	cp	$91			;Are we in v-blank yet?
	jr	nz,WAIT_VBLANK	;if A-91 != 0 then loop
	ret				;done
	
CLEAR_MAP::
	ld	hl,_SCRN0		;loads the address of the bg map ($9800) into HL
	ld	bc,32*32		;since we have 32x32 tiles, we'll need a counter so we can clear all of them
	ld	a,0			;load 0 into A (since our tile 0 is blank)
CLEAR_MAP_LOOP::
	ld	[hl+],a		;load A into HL, then increment HL (the HL+)
	dec	bc			;decrement our counter
	ld	a,b			;load B into A
	or	c			;if B or C != 0
	jr	nz,CLEAR_MAP_LOOP	;then loop
	ret				;done
	

LOAD_TILES::
	ld	hl,HELLO_TILES
	ld	de,VRAM
	ld	bc,9*16	;we have 9 tiles and each tile takes 16 bytes
LOAD_TILES_LOOP::
	ld	a,[hl+]	;get a byte from our tiles, and increment.
	ld	[de],a	;put that byte in VRAM and
	inc	de		;increment.
	dec	bc		;bc=bc-1.
	ld	a,b		;if b or c != 0,
	or	c		;
	jr	nz,LOAD_TILES_LOOP	;then loop.
	ret			;done


LOAD_MAP::
	ld	hl,HELLO_MAP	;our little map
	ld	de,_SCRN0	;where our map goes
	ld	c,12		;since we are only loading 12 tiles
LOAD_MAP_LOOP::
	ld	a,[hl+]	;get a byte of the map and inc hl
	ld	[de],a	;put the byte at de
	inc	de		;duh...
	dec	c		;decrement our counter
	jr	nz,LOAD_MAP_LOOP	;and of the counter != 0 then loop
	ret			;done

;********************************************************************
; This section was generated by GBTD v2.2

 SECTION "Tiles", HOME

; Start of tile array.
HELLO_TILES::
DB $00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00
DB $C6,$C6,$C6,$C6,$C6,$C6,$FE,$FE
DB $FE,$FE,$C6,$C6,$C6,$C6,$C6,$C6
DB $FE,$FE,$FE,$FE,$80,$80,$F8,$F8
DB $F8,$F8,$80,$80,$FE,$FE,$FE,$FE
DB $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
DB $C0,$C0,$C0,$C0,$FE,$FE,$FE,$FE
DB $7C,$7C,$FE,$FE,$C6,$C6,$C6,$C6
DB $C6,$C6,$C6,$C6,$FE,$FE,$7C,$7C
DB $C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6
DB $D6,$D6,$D6,$D6,$FE,$FE,$6C,$6C
DB $FC,$FC,$FE,$FE,$C6,$C6,$FC,$FC
DB $FC,$FC,$C6,$C6,$C6,$C6,$C6,$C6
DB $FC,$FC,$FE,$FE,$C6,$C6,$C6,$C6
DB $C6,$C6,$C6,$C6,$FE,$FE,$FC,$FC
DB $6C,$6C,$6C,$6C,$6C,$6C,$6C,$6C
DB $6C,$6C,$6C,$6C,$00,$00,$6C,$6C

;************************************************************
;* tile map

SECTION "Map",HOME

HELLO_MAP::
DB $01,$02,$03,$03,$04,$00,$05,$04,$06,$03,$07,$08


;*** End Of File ***