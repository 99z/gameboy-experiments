;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.0 #9615 (Mac OS X x86_64)
;--------------------------------------------------------
	.module shooting
	.optsdcc -mgbz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _move_sprite
	.globl _set_sprite_tile
	.globl _set_sprite_data
	.globl _set_bkg_tiles
	.globl _set_bkg_data
	.globl _wait_vbl_done
	.globl _joypad
	.globl _initrand
	.globl _bullets
	.globl _shooting
	.globl _bulletDir
	.globl _bulletLive
	.globl _bulletY
	.globl _bulletX
	.globl _randomBkgTiles
	.globl _lastKeys
	.globl _eY
	.globl _eX
	.globl _playerDir
	.globl _playerY
	.globl _playerX
	.globl _j
	.globl _i
	.globl _myBkgData
	.globl _sprites
	.globl _initGame
	.globl _updatePlayer
	.globl _collisionCheck
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_i::
	.ds 1
_j::
	.ds 1
_playerX::
	.ds 1
_playerY::
	.ds 1
_playerDir::
	.ds 1
_eX::
	.ds 10
_eY::
	.ds 10
_lastKeys::
	.ds 1
_randomBkgTiles::
	.ds 20
_bulletX::
	.ds 1
_bulletY::
	.ds 1
_bulletLive::
	.ds 1
_bulletDir::
	.ds 1
_shooting::
	.ds 1
_bullets::
	.ds 4
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;shooting.c:32: void main() {
;	---------------------------------
; Function main
; ---------------------------------
_main::
;shooting.c:34: initGame();
	call	_initGame
;shooting.c:36: while(1) {
00102$:
;shooting.c:37: updatePlayer(); // update player position
	call	_updatePlayer
;shooting.c:38: HIDE_WIN; // Hide window layer - no windows used
	ld	de,#0xff40
	ld	a,(de)
	ld	c,a
	ld	b,#0x00
	res	5, c
	ld	b,#0x00
	ld	hl,#0xff40
	ld	(hl),c
;shooting.c:39: SHOW_SPRITES; // Show sprites layer
	ld	de,#0xff40
	ld	a,(de)
	ld	c,a
	ld	b,#0x00
	ld	a,c
	set	1, a
	ld	c,a
	ld	l, #0x40
	ld	(hl),c
;shooting.c:40: SHOW_BKG; // Show background layer
	ld	de,#0xff40
	ld	a,(de)
	ld	c,a
	ld	b,#0x00
	ld	a,c
	set	0, a
	ld	c,a
	ld	l, #0x40
	ld	(hl),c
;shooting.c:41: lastKeys = joypad(); // Update keypresses
	call	_joypad
	ld	hl,#_lastKeys
	ld	(hl),e
;shooting.c:42: wait_vbl_done(); // Wait for vblank to finish - ensures a 60fps max
	call	_wait_vbl_done
	jp	00102$
	ret
_sprites:
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0xa5	; 165
	.db #0xa5	; 165
	.db #0xa5	; 165
	.db #0xa5	; 165
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x99	; 153
	.db #0x99	; 153
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0xed	; 237
	.db #0xed	; 237
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x91	; 145
	.db #0x91	; 145
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x99	; 153
	.db #0x81	; 129
	.db #0x42	; 66	'B'
	.db #0x5a	; 90	'Z'
	.db #0x24	; 36
	.db #0x3c	; 60
	.db #0x99	; 153
	.db #0x7e	; 126
	.db #0x99	; 153
	.db #0x7e	; 126
	.db #0x24	; 36
	.db #0x3c	; 60
	.db #0x42	; 66	'B'
	.db #0x5a	; 90	'Z'
	.db #0x99	; 153
	.db #0x81	; 129
	.db #0x38	; 56	'8'
	.db #0x04	; 4
	.db #0x7c	; 124
	.db #0x02	; 2
	.db #0x5c	; 92
	.db #0x22	; 34
	.db #0x5c	; 92
	.db #0x22	; 34
	.db #0x5c	; 92
	.db #0x22	; 34
	.db #0x5c	; 92
	.db #0x22	; 34
	.db #0x7c	; 124
	.db #0x02	; 2
	.db #0x38	; 56	'8'
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0x1c	; 28
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x6c	; 108	'l'
	.db #0x6c	; 108	'l'
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x1e	; 30
	.db #0x1e	; 30
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x43	; 67	'C'
	.db #0x43	; 67	'C'
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x6c	; 108	'l'
	.db #0x6c	; 108	'l'
	.db #0x6c	; 108	'l'
	.db #0x6c	; 108	'l'
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x0c	; 12
	.db #0x0c	; 12
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x63	; 99	'c'
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
_myBkgData:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x36	; 54	'6'
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x0e	; 14
	.db #0x00	; 0
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
;shooting.c:46: void initGame(){
;	---------------------------------
; Function initGame
; ---------------------------------
_initGame::
	dec	sp
;shooting.c:47: DISPLAY_ON; // turns on gameboy lcd
	ld	de,#0xff40
	ld	a,(de)
	ld	c,a
	ld	b,#0x00
	ld	a,c
	set	7, a
	ld	c,a
	ld	hl,#0xff40
	ld	(hl),c
;shooting.c:48: NR52_REG = 0x8F; // sound on
	ld	l, #0x26
	ld	(hl),#0x8f
;shooting.c:49: NR51_REG = 0x11; // both sound channels
	ld	l, #0x25
	ld	(hl),#0x11
;shooting.c:50: NR50_REG = 0x77; // volume level, max = 0x77, min = 0x00
	ld	l, #0x24
	ld	(hl),#0x77
;shooting.c:52: initrand(DIV_REG); // part of gb/rand.h, want to use DIV_REG as per the documentation
	ld	de,#0xff04
	ld	a,(de)
	ld	c,a
	ld	b,#0x00
	push	bc
	call	_initrand
	add	sp, #2
;shooting.c:53: set_sprite_data(0, 14, sprites); // storing sprite data
	ld	hl,#_sprites
	push	hl
	ld	hl,#0x0e00
	push	hl
	call	_set_sprite_data
	add	sp, #4
;shooting.c:54: set_bkg_data(0, 4, myBkgData); // storing background data - window layer shares this
	ld	hl,#_myBkgData
	push	hl
	ld	hl,#0x0400
	push	hl
	call	_set_bkg_data
	add	sp, #4
;shooting.c:56: playerX = 64; // initial x position for player
	ld	hl,#_playerX
	ld	(hl),#0x40
;shooting.c:57: playerY = 64; // initial y position for player
	ld	hl,#_playerY
	ld	(hl),#0x40
;shooting.c:59: set_sprite_tile(0,0); // sprite tile representing the player - is first sprite, so 0th index
	ld	hl,#0x0000
	push	hl
	call	_set_sprite_tile
	add	sp, #2
;shooting.c:62: for (i=0; i !=10; i++) {
	ld	hl,#_i
	ld	(hl),#0x00
00105$:
;shooting.c:63: eX[i] = 16+(rand()); // random x position between 16 and 144
	ld	a,#<(_eX)
	ld	hl,#_i
	add	a, (hl)
	ld	c,a
	ld	a,#>(_eX)
	adc	a, #0x00
	ld	b,a
	push	bc
	call	_rand
	pop	bc
	ld	a,e
	add	a, #0x10
	ld	(bc),a
;shooting.c:64: eY[i] = 16+(rand()); // random y position between 16 and 144
	ld	a,#<(_eY)
	ld	hl,#_i
	add	a, (hl)
	ld	c,a
	ld	a,#>(_eY)
	adc	a, #0x00
	ld	b,a
	push	bc
	call	_rand
	pop	bc
	ld	a,e
	add	a, #0x10
	ld	(bc),a
;shooting.c:65: set_sprite_tile(i+1, 2); // enemy sprite tile set to 2
	ld	hl,#_i
	ld	b,(hl)
	inc	b
	ld	a,#0x02
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_sprite_tile
	add	sp, #2
;shooting.c:66: move_sprite(i+1,eX[i], eY[i]); // place enemies
	ld	a,#<(_eY)
	ld	hl,#_i
	add	a, (hl)
	ld	c,a
	ld	a,#>(_eY)
	adc	a, #0x00
	ld	b,a
	ld	a,(bc)
	ldhl	sp,#0
	ld	(hl),a
	ld	a,#<(_eX)
	ld	hl,#_i
	add	a, (hl)
	ld	c,a
	ld	a,#>(_eX)
	adc	a, #0x00
	ld	b,a
	ld	a,(bc)
	ld	d,a
	ld	b,(hl)
	inc	b
	ldhl	sp,#0
	ld	a,(hl)
	push	af
	inc	sp
	push	de
	inc	sp
	push	bc
	inc	sp
	call	_move_sprite
	add	sp, #3
;shooting.c:62: for (i=0; i !=10; i++) {
	ld	hl,#_i
	inc	(hl)
	ld	a,(hl)
	sub	a, #0x0a
	jp	NZ,00105$
;shooting.c:70: shooting = 0;
	ld	hl,#_shooting
	ld	(hl),#0x00
;shooting.c:71: set_sprite_tile(12, 3); // sets sprite tile 03 to index 12
	ld	hl,#0x030c
	push	hl
	call	_set_sprite_tile
	add	sp, #2
;shooting.c:73: for (i = 0; i != 1; i++) {
	ld	hl,#_i
	ld	(hl),#0x00
00107$:
;shooting.c:74: bullets[i].x = 0;
	ld	hl,#_i
	ld	c,(hl)
	ld	b,#0x00
	sla	c
	rl	b
	sla	c
	rl	b
	ld	hl,#_bullets
	add	hl,bc
	ld	c,l
	ld	b,h
	xor	a, a
	ld	(bc),a
;shooting.c:75: bullets[i].y = 0;
	ld	hl,#_i
	ld	c,(hl)
	ld	b,#0x00
	sla	c
	rl	b
	sla	c
	rl	b
	ld	hl,#_bullets
	add	hl,bc
	ld	c,l
	ld	b,h
	inc	bc
	xor	a, a
	ld	(bc),a
;shooting.c:76: bullets[i].alive = 0;
	ld	hl,#_i
	ld	c,(hl)
	ld	b,#0x00
	sla	c
	rl	b
	sla	c
	rl	b
	ld	hl,#_bullets
	add	hl,bc
	ld	c,l
	ld	b,h
	inc	bc
	inc	bc
	xor	a, a
	ld	(bc),a
;shooting.c:77: bullets[i].direction = 0;
	ld	hl,#_i
	ld	c,(hl)
	ld	b,#0x00
	sla	c
	rl	b
	sla	c
	rl	b
	ld	hl,#_bullets
	add	hl,bc
	ld	c,l
	ld	b,h
	inc	bc
	inc	bc
	inc	bc
	xor	a, a
	ld	(bc),a
;shooting.c:73: for (i = 0; i != 1; i++) {
	ld	hl,#_i
	inc	(hl)
	ld	a,(hl)
	dec	a
	jp	NZ,00107$
;shooting.c:81: for (j=0; j != 18; j++) {
	ld	hl,#_j
	ld	(hl),#0x00
00111$:
;shooting.c:82: for (i=0; i != 20; i++) {
	ld	hl,#_i
	ld	(hl),#0x00
00109$:
;shooting.c:83: randomBkgTiles[i] = rand() % 4;
	ld	a,#<(_randomBkgTiles)
	ld	hl,#_i
	add	a, (hl)
	ld	c,a
	ld	a,#>(_randomBkgTiles)
	adc	a, #0x00
	ld	b,a
	push	bc
	call	_rand
	pop	bc
	push	bc
	ld	hl,#0x0004
	push	hl
	push	de
	call	__modsint
	add	sp, #4
	pop	bc
	ld	a,e
	ld	(bc),a
;shooting.c:82: for (i=0; i != 20; i++) {
	ld	hl,#_i
	inc	(hl)
	ld	a,(hl)
	sub	a, #0x14
	jr	NZ,00109$
;shooting.c:85: set_bkg_tiles(0,j,20,1,randomBkgTiles); // x, y, width, height, background tiles
	ld	hl,#_randomBkgTiles
	push	hl
	ld	hl,#0x0114
	push	hl
	ld	hl,#_j
	ld	a,(hl)
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
;shooting.c:81: for (j=0; j != 18; j++) {
	ld	hl,#_j
	inc	(hl)
	ld	a,(hl)
	sub	a, #0x12
	jp	NZ,00111$
	inc	sp
	ret
;shooting.c:90: void updatePlayer() {
;	---------------------------------
; Function updatePlayer
; ---------------------------------
_updatePlayer::
	add	sp, #-2
;shooting.c:94: if (joypad() & J_UP) {
	call	_joypad
	ld	c,#0x00
	bit	2, e
	jp	Z,00112$
;shooting.c:96: shooting = 1;
	ld	hl,#_shooting
	ld	(hl),#0x01
;shooting.c:97: playerDir = 0;
	ld	hl,#_playerDir
	ld	(hl),#0x00
;shooting.c:99: if (bullets[0].alive == 0) {
	ld	a, (#(_bullets + 0x0002) + 0)
	or	a, a
	jp	NZ,00108$
;shooting.c:100: bullets[0].alive = 1;
	ld	hl,#(_bullets + 0x0002)
	ld	(hl),#0x01
;shooting.c:101: playerY += 2;
	ld	hl,#_playerY
	inc	(hl)
	inc	(hl)
;shooting.c:103: if (joypad() & J_LEFT) {
	call	_joypad
	ld	c,e
	ld	b,#0x00
;shooting.c:104: bullets[0].direction = 4;
;shooting.c:103: if (joypad() & J_LEFT) {
	bit	1, c
	jr	Z,00105$
;shooting.c:104: bullets[0].direction = 4;
	ld	hl,#(_bullets + 0x0003)
	ld	(hl),#0x04
	jr	00106$
00105$:
;shooting.c:105: } else if (joypad() & J_RIGHT) {
	call	_joypad
	ld	c,#0x00
	bit	0, e
	jr	Z,00102$
;shooting.c:106: bullets[0].direction = 5;
	ld	hl,#(_bullets + 0x0003)
	ld	(hl),#0x05
	jr	00106$
00102$:
;shooting.c:108: bullets[0].direction = 0;
	ld	hl,#(_bullets + 0x0003)
	ld	(hl),#0x00
00106$:
;shooting.c:111: bullets[0].x = playerX;
	ld	de,#_bullets
	ld	hl,#_playerX
	ld	a,(hl)
	ld	(de),a
;shooting.c:112: bullets[0].y = playerY;
	ld	de,#(_bullets + 0x0001)
	ld	hl,#_playerY
	ld	a,(hl)
	ld	(de),a
;shooting.c:113: move_sprite(12, bullets[0].x, bullets[0].y); // places sprite on screen
	ld	a,(hl)
	push	af
	inc	sp
	ld	hl,#_playerX
	ld	a,(hl)
	push	af
	inc	sp
	ld	a,#0x0c
	push	af
	inc	sp
	call	_move_sprite
	add	sp, #3
00108$:
;shooting.c:115: if (playerY == 15) {
	ld	hl,#_playerY
	ld	a,(hl)
	sub	a, #0x0f
	jr	NZ,00112$
;shooting.c:116: playerY = 16;
	ld	hl,#_playerY
	ld	(hl),#0x10
00112$:
;shooting.c:120: if (joypad() & J_DOWN){
	call	_joypad
	ld	c,#0x00
	bit	3, e
	jp	Z,00124$
;shooting.c:122: shooting = 1;
	ld	hl,#_shooting
	ld	(hl),#0x01
;shooting.c:123: playerDir = 2;
	ld	hl,#_playerDir
	ld	(hl),#0x02
;shooting.c:125: if (bullets[0].alive == 0) {
	ld	bc,#_bullets + 2
	ld	a,(bc)
	or	a, a
	jp	NZ,00120$
;shooting.c:126: bullets[0].alive = 1;
	ld	a,#0x01
	ld	(bc),a
;shooting.c:127: playerY -= 2;
	ld	hl,#_playerY
	dec	(hl)
	dec	(hl)
;shooting.c:129: if (joypad() & J_LEFT) {
	call	_joypad
	ld	c,e
	ld	b,#0x00
;shooting.c:130: bullets[0].direction = 7;
;shooting.c:129: if (joypad() & J_LEFT) {
	bit	1, c
	jr	Z,00117$
;shooting.c:130: bullets[0].direction = 7;
	ld	hl,#(_bullets + 0x0003)
	ld	(hl),#0x07
	jr	00118$
00117$:
;shooting.c:131: } else if (joypad() & J_RIGHT) {
	call	_joypad
	ld	c,#0x00
	bit	0, e
	jr	Z,00114$
;shooting.c:132: bullets[0].direction = 6;
	ld	hl,#(_bullets + 0x0003)
	ld	(hl),#0x06
	jr	00118$
00114$:
;shooting.c:134: bullets[0].direction = 2;
	ld	hl,#(_bullets + 0x0003)
	ld	(hl),#0x02
00118$:
;shooting.c:137: bullets[0].x = playerX;
	ld	de,#_bullets
	ld	hl,#_playerX
	ld	a,(hl)
	ld	(de),a
;shooting.c:138: bullets[0].y = playerY;
	ld	de,#(_bullets + 0x0001)
	ld	hl,#_playerY
	ld	a,(hl)
	ld	(de),a
;shooting.c:139: move_sprite(12, bullets[0].x, bullets[0].y); // places sprite on screen
	ld	a,(hl)
	push	af
	inc	sp
	ld	hl,#_playerX
	ld	a,(hl)
	push	af
	inc	sp
	ld	a,#0x0c
	push	af
	inc	sp
	call	_move_sprite
	add	sp, #3
00120$:
;shooting.c:141: if (playerY == 153){
	ld	hl,#_playerY
	ld	a,(hl)
	sub	a, #0x99
	jr	NZ,00124$
;shooting.c:142: playerY = 152;
	ld	hl,#_playerY
	ld	(hl),#0x98
00124$:
;shooting.c:146: if (joypad() & J_LEFT){
	call	_joypad
	ld	c,#0x00
	bit	1, e
	jp	Z,00130$
;shooting.c:148: shooting = 1;
	ld	hl,#_shooting
	ld	(hl),#0x01
;shooting.c:149: playerDir = 3;
	ld	hl,#_playerDir
	ld	(hl),#0x03
;shooting.c:151: if (bullets[0].alive == 0) {
	ld	bc,#_bullets + 2
	ld	a,(bc)
	or	a, a
	jr	NZ,00126$
;shooting.c:152: bullets[0].alive = 1;
	ld	a,#0x01
	ld	(bc),a
;shooting.c:153: playerX += 2;
	ld	hl,#_playerX
	inc	(hl)
	inc	(hl)
;shooting.c:154: bullets[0].direction = 3;
	ld	hl,#(_bullets + 0x0003)
	ld	(hl),#0x03
;shooting.c:155: bullets[0].x = playerX;
	ld	de,#_bullets
	ld	hl,#_playerX
	ld	a,(hl)
	ld	(de),a
;shooting.c:156: bullets[0].y = playerY;
	ld	de,#(_bullets + 0x0001)
	ld	hl,#_playerY
	ld	a,(hl)
	ld	(de),a
;shooting.c:157: move_sprite(12, bullets[0].x, bullets[0].y); // places sprite on screen
	ld	a,(hl)
	push	af
	inc	sp
	ld	hl,#_playerX
	ld	a,(hl)
	push	af
	inc	sp
	ld	a,#0x0c
	push	af
	inc	sp
	call	_move_sprite
	add	sp, #3
00126$:
;shooting.c:159: if (playerX == 7){
	ld	hl,#_playerX
	ld	a,(hl)
	sub	a, #0x07
	jr	NZ,00130$
;shooting.c:160: playerX = 8;
	ld	hl,#_playerX
	ld	(hl),#0x08
00130$:
;shooting.c:164: if (joypad() & J_RIGHT){
	call	_joypad
	ld	c,#0x00
	bit	0, e
	jp	Z,00136$
;shooting.c:166: shooting = 1;
	ld	hl,#_shooting
	ld	(hl),#0x01
;shooting.c:167: playerDir = 1;
	ld	hl,#_playerDir
	ld	(hl),#0x01
;shooting.c:169: if (bullets[0].alive == 0) {
	ld	bc,#_bullets + 2
	ld	a,(bc)
	or	a, a
	jr	NZ,00132$
;shooting.c:170: bullets[0].alive = 1;
	ld	a,#0x01
	ld	(bc),a
;shooting.c:171: playerX -= 2;
	ld	hl,#_playerX
	dec	(hl)
	dec	(hl)
;shooting.c:172: bullets[0].direction = 1;
	ld	hl,#(_bullets + 0x0003)
	ld	(hl),#0x01
;shooting.c:173: bullets[0].x = playerX;
	ld	de,#_bullets
	ld	hl,#_playerX
	ld	a,(hl)
	ld	(de),a
;shooting.c:174: bullets[0].y = playerY;
	ld	de,#(_bullets + 0x0001)
	ld	hl,#_playerY
	ld	a,(hl)
	ld	(de),a
;shooting.c:175: move_sprite(12, bullets[0].x, bullets[0].y); // places sprite on screen
	ld	a,(hl)
	push	af
	inc	sp
	ld	hl,#_playerX
	ld	a,(hl)
	push	af
	inc	sp
	ld	a,#0x0c
	push	af
	inc	sp
	call	_move_sprite
	add	sp, #3
00132$:
;shooting.c:177: if (playerX == 161){
	ld	hl,#_playerX
	ld	a,(hl)
	sub	a, #0xa1
	jr	NZ,00136$
;shooting.c:178: playerX = 160;
	ld	hl,#_playerX
	ld	(hl),#0xa0
00136$:
;shooting.c:183: if (joypad() & J_A) {
	call	_joypad
	ld	c,#0x00
	bit	4, e
	jr	Z,00141$
;shooting.c:184: NR11_REG = 0x7f; // audio channel #1, wave pattern duty
	ld	hl,#0xff11
	ld	(hl),#0x7f
;shooting.c:185: NR12_REG = 0x7f; // volume for 11
	ld	l, #0x12
	ld	(hl),#0x7f
;shooting.c:186: NR13_REG = DIV_REG; // sound frequency least significant bit
	ld	de,#0xff04
	ld	a,(de)
	ld	de,#0xff13
	ld	(de),a
;shooting.c:187: NR14_REG = 0x80 + (DIV_REG % 8); // sound frequency significant 3 bits
	ld	de,#0xff04
	ld	a,(de)
	and	a, #0x07
	add	a, #0x80
	ld	de,#0xff14
	ld	(de),a
	jr	00142$
00141$:
;shooting.c:188: } else if (joypad() & J_B) {
	call	_joypad
	ld	c,#0x00
	bit	5, e
	jr	NZ,00142$
;shooting.c:192: NR11_REG = 0x00;
	ld	hl,#0xff11
	ld	(hl),#0x00
;shooting.c:193: NR12_REG = 0x00;
	ld	l, #0x12
	ld	(hl),#0x00
;shooting.c:194: NR13_REG = 0x00;
	ld	l, #0x13
	ld	(hl),#0x00
;shooting.c:195: NR14_REG = 0x00;
	ld	l, #0x14
	ld	(hl),#0x00
;shooting.c:197: shooting = 0;
	ld	hl,#_shooting
	ld	(hl),#0x00
00142$:
;shooting.c:200: move_sprite(0,playerX,playerY); // position player sprite on screen
	ld	hl,#_playerY
	ld	a,(hl)
	push	af
	inc	sp
	ld	hl,#_playerX
	ld	a,(hl)
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_move_sprite
	add	sp, #3
;shooting.c:202: if (bullets[0].x > 160 || bullets[0].x == 0 || bullets[0].y > 152 || bullets[0].y == 0) {
	ld	de, #_bullets + 0
	ld	a,(de)
	ld	c,a
	ld	a,#0xa0
	sub	a, c
	jr	C,00160$
	ld	a,c
	or	a, a
	jr	Z,00160$
	ld	bc,#_bullets + 1
	ld	a,(bc)
	ldhl	sp,#1
	ld	(hl),a
	ld	a,#0x98
	sub	a, (hl)
	jr	C,00160$
	ld	a,(hl)
	or	a, a
	jp	NZ,00161$
00160$:
;shooting.c:203: if (shooting == 1) {
	ld	hl,#_shooting
	ld	a,(hl)
	dec	a
	jp	NZ,00149$
;shooting.c:204: bullets[0].alive = 1;
	ld	de,#_bullets+0
	ld	c,e
	ld	b,d
	ld	hl,#(_bullets + 0x0002)
	ld	(hl),#0x01
;shooting.c:205: switch (playerDir) {
	ld	a,#0x03
	ld	hl,#_playerDir
	sub	a, (hl)
	jp	C,00162$
;shooting.c:208: bullets[0].y = playerY - 8;
;shooting.c:211: bullets[0].x = playerX + 8;
	ld	hl,#_playerX
	ld	a,(hl)
	add	a, #0x08
	ld	e,a
;shooting.c:205: switch (playerDir) {
	ld	hl,#_playerDir
	ld	e,(hl)
	ld	d,#0x00
	ld	hl,#00309$
	add	hl,de
	add	hl,de
;shooting.c:206: case 0:
	jp	(hl)
00309$:
	jr	00143$
	jr	00144$
	jr	00145$
	jr	00146$
00143$:
;shooting.c:207: bullets[0].x = playerX;
	ld	hl,#_playerX
	ld	a,(hl)
	ld	(bc),a
;shooting.c:208: bullets[0].y = playerY - 8;
	ld	hl,#_playerY
	ld	a,(hl)
	add	a,#0xf8
	ld	de,#(_bullets + 0x0001)
	ld	(de),a
;shooting.c:209: break;
	jp	00162$
;shooting.c:210: case 1:
00144$:
;shooting.c:211: bullets[0].x = playerX + 8;
	ld	a,e
	ld	(bc),a
;shooting.c:212: bullets[0].y = playerY;
	ld	de,#(_bullets + 0x0001)
	ld	hl,#_playerY
	ld	a,(hl)
	ld	(de),a
;shooting.c:213: break;
	jp	00162$
;shooting.c:214: case 2:
00145$:
;shooting.c:215: bullets[0].x = playerX;
	ld	hl,#_playerX
	ld	a,(hl)
	ld	(bc),a
;shooting.c:216: bullets[0].y = playerY - 8;
	ld	hl,#_playerY
	ld	a,(hl)
	add	a,#0xf8
	ld	de,#(_bullets + 0x0001)
	ld	(de),a
;shooting.c:217: break;
	jp	00162$
;shooting.c:218: case 3:
00146$:
;shooting.c:219: bullets[0].x = playerX + 8;
	ld	a,e
	ld	(bc),a
;shooting.c:220: bullets[0].y = playerY;
	ld	de,#(_bullets + 0x0001)
	ld	hl,#_playerY
	ld	a,(hl)
	ld	(de),a
;shooting.c:222: }
	jp	00162$
00149$:
;shooting.c:224: bullets[0].alive = 0;
	ld	hl,#(_bullets + 0x0002)
	ld	(hl),#0x00
;shooting.c:225: bullets[0].x = 0;
	ld	hl,#_bullets
	ld	(hl),#0x00
;shooting.c:226: bullets[0].y = 0;
	ld	hl,#(_bullets + 0x0001)
	ld	(hl),#0x00
	jp	00162$
00161$:
;shooting.c:229: switch (bullets[0].direction) {
	ld	de, #(_bullets + 0x0003) + 0
	ld	a,(de)
	ldhl	sp,#0
	ld	(hl),a
	ld	a,#0x07
	sub	a, (hl)
	jp	C,00162$
	ld	e,(hl)
	ld	d,#0x00
	ld	hl,#00310$
	add	hl,de
	add	hl,de
	add	hl,de
	jp	(hl)
00310$:
	jp	00151$
	jp	00152$
	jp	00153$
	jp	00154$
	jp	00155$
	jp	00156$
	jp	00157$
	jp	00158$
;shooting.c:230: case 0:
00151$:
;shooting.c:231: bullets[0].y -= 5;
	ldhl	sp,#1
	ld	a,(hl)
	add	a,#0xfb
	ld	(bc),a
;shooting.c:232: break;
	jp	00162$
;shooting.c:233: case 1:
00152$:
;shooting.c:234: bullets[0].x += 5;
	ld	a, (#_bullets + 0)
	add	a, #0x05
	ld	de,#_bullets
	ld	(de),a
;shooting.c:235: break;
	jp	00162$
;shooting.c:236: case 2:
00153$:
;shooting.c:237: bullets[0].y += 5;
	ldhl	sp,#1
	ld	a,(hl)
	add	a, #0x05
	ld	(bc),a
;shooting.c:238: break;
	jp	00162$
;shooting.c:239: case 3:
00154$:
;shooting.c:240: bullets[0].x -= 5;
	ld	a, (#_bullets + 0)
	add	a,#0xfb
	ld	de,#_bullets
	ld	(de),a
;shooting.c:241: break;
	jp	00162$
;shooting.c:242: case 4:
00155$:
;shooting.c:243: bullets[0].x -= 5;
	ld	a, (#_bullets + 0)
	add	a,#0xfb
	ld	de,#_bullets
	ld	(de),a
;shooting.c:244: bullets[0].y -= 5;
	ld	a,(bc)
	add	a,#0xfb
	ld	(bc),a
;shooting.c:245: break;
	jr	00162$
;shooting.c:246: case 5:
00156$:
;shooting.c:247: bullets[0].x += 5;
	ld	a, (#_bullets + 0)
	add	a, #0x05
	ld	de,#_bullets
	ld	(de),a
;shooting.c:248: bullets[0].y -= 5;
	ld	a,(bc)
	add	a,#0xfb
	ld	(bc),a
;shooting.c:249: break;
	jr	00162$
;shooting.c:250: case 6:
00157$:
;shooting.c:251: bullets[0].x += 5;
	ld	a, (#_bullets + 0)
	add	a, #0x05
	ld	de,#_bullets
	ld	(de),a
;shooting.c:252: bullets[0].y += 5;
	ld	a,(bc)
	add	a, #0x05
	ld	(bc),a
;shooting.c:253: break;
	jr	00162$
;shooting.c:254: case 7:
00158$:
;shooting.c:255: bullets[0].x -= 5;
	ld	a, (#_bullets + 0)
	add	a,#0xfb
	ld	de,#_bullets
	ld	(de),a
;shooting.c:256: bullets[0].y += 5;
	ld	a,(bc)
	add	a, #0x05
	ld	(bc),a
;shooting.c:258: }
00162$:
;shooting.c:261: move_sprite(12, bullets[0].x, bullets[0].y);
	ld	de, #(_bullets + 0x0001) + 0
	ld	a,(de)
	ld	b,a
	ld	a, (#_bullets + 0)
	push	bc
	inc	sp
	push	af
	inc	sp
	ld	a,#0x0c
	push	af
	inc	sp
	call	_move_sprite
	add	sp, #3
;shooting.c:263: j = 0; // re use j for collision - saves space
	ld	hl,#_j
	ld	(hl),#0x00
;shooting.c:265: for (i=0; i != 10; i++) {
	ld	hl,#_i
	ld	(hl),#0x00
00172$:
;shooting.c:266: if (collisionCheck(playerX, playerY, 8, 8, eX[i], eY[i], 8, 8) == 1){
	ld	a,#<(_eY)
	ld	hl,#_i
	add	a, (hl)
	ld	c,a
	ld	a,#>(_eY)
	adc	a, #0x00
	ld	b,a
	ld	a,(bc)
	ldhl	sp,#0
	ld	(hl),a
	ld	a,#<(_eX)
	ld	hl,#_i
	add	a, (hl)
	ld	c,a
	ld	a,#>(_eX)
	adc	a, #0x00
	ld	b,a
	ld	a,(bc)
	ld	b,a
	ld	hl,#0x0808
	push	hl
	ldhl	sp,#2
	ld	a,(hl)
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	hl,#0x0808
	push	hl
	ld	hl,#_playerY
	ld	a,(hl)
	push	af
	inc	sp
	ld	hl,#_playerX
	ld	a,(hl)
	push	af
	inc	sp
	call	_collisionCheck
	add	sp, #8
	dec	e
	jr	NZ,00173$
;shooting.c:267: j= 1; // if a collision happens
	ld	hl,#_j
	ld	(hl),#0x01
00173$:
;shooting.c:265: for (i=0; i != 10; i++) {
	ld	hl,#_i
	inc	(hl)
	ld	a,(hl)
	sub	a, #0x0a
	jp	NZ,00172$
;shooting.c:272: switch (j) {
	ld	hl,#_j
	ld	a,(hl)
	or	a, a
	jr	NZ,00170$
;shooting.c:275: set_sprite_tile(0,0);
	ld	hl,#0x0000
	push	hl
	call	_set_sprite_tile
	add	sp, #2
;shooting.c:276: break;
	jr	00174$
;shooting.c:279: default:
00170$:
;shooting.c:280: set_sprite_tile(0,1);
	ld	hl,#0x0100
	push	hl
	call	_set_sprite_tile
	add	sp, #2
;shooting.c:282: }
00174$:
	add	sp, #2
	ret
;shooting.c:287: UINT8 collisionCheck(UINT8 x1, UINT8 y1, UINT8 w1, UINT8 h1, UINT8 x2, UINT8 y2, UINT8 w2, UINT8 h2){
;	---------------------------------
; Function collisionCheck
; ---------------------------------
_collisionCheck::
	add	sp, #-4
;shooting.c:288: if ((x1 < (x2+w2)) && ((x1+w1) > x2) && (y1 < (h2+y2)) && ((y1+h1) > y2)){
	ldhl	sp,#10
	ld	a,(hl)
	ldhl	sp,#2
	ld	(hl+),a
	ld	(hl),#0x00
	ldhl	sp,#12
	ld	c,(hl)
	ld	b,#0x00
	ldhl	sp,#2
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	add	hl,bc
	ld	c,l
	ld	b,h
	ldhl	sp,#6
	ld	a,(hl)
	ldhl	sp,#0
	ld	(hl+),a
	ld	(hl),#0x00
	dec	hl
	ld	a, (hl)
	sub	a, c
	inc	hl
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a,b
	ld	e, a
	bit	7, e
	jr	Z,00125$
	bit	7, d
	jr	NZ,00126$
	cp	a, a
	jr	00126$
00125$:
	bit	7, d
	jr	Z,00126$
	scf
00126$:
	jp	NC,00102$
	ldhl	sp,#8
	ld	c,(hl)
	ld	b,#0x00
	pop	hl
	push	hl
	add	hl,bc
	ld	c,l
	ld	b,h
	ldhl	sp,#2
	ld	a, (hl)
	sub	a, c
	inc	hl
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a,b
	ld	e, a
	bit	7, e
	jr	Z,00127$
	bit	7, d
	jr	NZ,00128$
	cp	a, a
	jr	00128$
00127$:
	bit	7, d
	jr	Z,00128$
	scf
00128$:
	jp	NC,00102$
	ldhl	sp,#13
	ld	c,(hl)
	ld	b,#0x00
	dec	hl
	dec	hl
	ld	a,(hl)
	ldhl	sp,#0
	ld	(hl+),a
	ld	(hl),#0x00
	pop	hl
	push	hl
	add	hl,bc
	ld	c,l
	ld	b,h
	ldhl	sp,#7
	ld	a,(hl)
	ldhl	sp,#2
	ld	(hl+),a
	ld	(hl),#0x00
	dec	hl
	ld	a, (hl)
	sub	a, c
	inc	hl
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a,b
	ld	e, a
	bit	7, e
	jr	Z,00129$
	bit	7, d
	jr	NZ,00130$
	cp	a, a
	jr	00130$
00129$:
	bit	7, d
	jr	Z,00130$
	scf
00130$:
	jp	NC,00102$
	ldhl	sp,#9
	ld	c,(hl)
	ld	b,#0x00
	ldhl	sp,#2
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	add	hl,bc
	ld	c,l
	ld	b,h
	ldhl	sp,#0
	ld	a, (hl)
	sub	a, c
	inc	hl
	ld	a, (hl)
	sbc	a, b
	ld	d, (hl)
	ld	a,b
	ld	e, a
	bit	7, e
	jr	Z,00131$
	bit	7, d
	jr	NZ,00132$
	cp	a, a
	jr	00132$
00131$:
	bit	7, d
	jr	Z,00132$
	scf
00132$:
	jr	NC,00102$
;shooting.c:289: return 1;
	ld	e,#0x01
	jr	00107$
00102$:
;shooting.c:291: return 0;
	ld	e,#0x00
00107$:
	add	sp, #4
	ret
	.area _CODE
	.area _CABS (ABS)
