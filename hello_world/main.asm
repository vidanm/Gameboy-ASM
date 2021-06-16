INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]

EntryPoint:
	di ; desactive les interruptions int
	jp Start

REPT $150 - $104
	db 0
ENDR

SECTION "Game code", ROM0

Start:
	; Turn off the LCD
.waitVBlank
	ld a, [rLY]
	cp 144 ; Check it the LCD is past VBlank
	jr c, .waitVBlank

	xor a ; ld a, 0 ; reset a to 0
	ld [rLCDC], a ; reset rLCDC to 0

	ld hl, $9000
	ld de, FontTiles
	ld bc, FontTilesEnd - FontTiles

.copyFont
	ld a, [de] ; Grab 1 byte from the source
	ld [hli], a ; Place it at the destination, increment hl
	inc de ; Move to the next byte
	dec bc ; Decrement count
	ld a, b ; Check if count is 0 since dec bc doesn't update flags
	or c ; or a, c 
	jr nz, .copyFont
	
	ld hl, $9800 ; This will print the string at the top left corner of the screen
	ld de, HelloWorldStr

.copyString
	ld a, [de]
	ld [hli], a
	inc de
	and a ; Check if the byte is 0
	jr nz, .copyString ; Continue if it's not

	; Init display registers
	ld a, %11100100
	ld [rBGP], a

	xor a ; ld a, 0
	ld [rSCY], a ; Définit la valeur haut visible a l'ecran ( a tester )
	ld [rSCX], a ; Définit la valeur gauche visible a l'ecran ( a tester )
	
	; Shut sound down
	ld [rNR52], a

	; Turn screen on, display background
	ld a, %10000001
	ld [rLCDC], a

	; Lock up
.lockup
	jr .lockup

SECTION "Font", ROM0

FontTiles:
INCBIN "font.chr" ; Makes RGBDS copy the file's contents directly into the produced ROM
FontTilesEnd:

SECTION "Hello World string", ROM0
HelloWorldStr:
	db "Bonjour le monde!", 0
