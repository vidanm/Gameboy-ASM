INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]

EntryPoint:
	di ; Desactive les interruptions
	jp Start

REPT $150 - $104
	db 0 ; Je crois que c'est pour réserver de la place entre l'adresse $150 et $104
ENDR

SECTION "Game code", ROM0

Start:
	;Turn off the LCD
.waitVBlank
	ld a, [rLY] ; rLY = LCD Y coordinate 
	cp 144 ; Check if the LCD is past VBlank ( L'ecran fait 144 px de hauteur )
	jr c, .waitVBlank ; si on est au dessus du VBlank on retourne au debut de cette fonction
	
	; On a passé le VBlank
	xor a ; on reset a à 0 
	ld [rLCDC], a ; reset lCDC à 0 c'est le controle du LCD, pour definir ce qui doit etre affiché

	ld hl, $9000 ; Tile data dans hl
	ld de, FontTiles
	ld bc, FontTilesEnd - FontTiles ; Compteur de tiles

.copyFont
	ld a, [de] ; Recupere 1 tile
	ld [hli], a ; On le place dans la destination et on incremente hl
	inc de ; On passe a la prochaine tile
	dec bc ; et on decremente le compteur de tiles
	ld a, b ; On regarde si le compteur est à 0 puisque dec n'update pas les flags
	or c ; si a ou c update les flags
	jr nz, .copyFont ;si le flag Z n'est pas set alors on recommence la fonction

	ld c, 18;offset
	ld hl, $9800 ; print la chaine en haut a gauche
	ld de, Str

.copyString
	ld a, [de]
	ld [hli], a ; 32 tiles par ligne
	inc de

	and a ; Tout à été copié ?
	jr nz, .copyString ; sinon on continue

	ld a, e  
	sub 18
	ld e, a
	jr nc, .no_carry
	dec d

.no_carry
	xor a ; Reset parce que probleme d'adresse ??
	dec c
	or c
	jr nz, .copyString
	

	;Initialise les registres d'affichages
	; ld a, %11100100 ; La palette
	ld a, %00011011 ; Test inversion de palette ; marche totalement
	ld [rBGP], a ; On stocke la palette

	xor a
	ld [rSCY], a ; Définit la valeur haut visible a l'ecran
	ld [rSCX], a ; Définit la valeur gauche visible a l'ecran

	ld [rNR52], a ; On desactive le son

	ld a, %10000001 ; 7e bit a 1 -> LCD and PPU enable
	ld [rLCDC], a ; 1er bit à 1 -> BG and Window enable priority


.lockup
 jr .lockup

SECTION "Font", ROM0

FontTiles:
INCBIN "font.chr" ; Function RGBDS
FontTilesEnd:

SECTION "Hello World string", ROM0
Str:
	db "Trop fort le gars", 0
