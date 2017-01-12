#include <gb/rand.h> // random functions
#include <gb/gb.h> // required
#include <gb/hardware.h> // hardware references

void initGame();
void updatePlayer();
UINT8 collisionCheck(UINT8, UINT8, UINT8, UINT8, UINT8, UINT8, UINT8, UINT8);
UINT8 i, j;
UINT8 playerX, playerY, playerDir;
UINT8 eX[10], eY[10];
UINT8 lastKeys; // stores keys for previous frame
UINT8 randomBkgTiles[20]; // background tile data
UINT8 bulletX, bulletY, bulletLive, bulletDir, shooting; // bullet data

typedef struct {
    UBYTE x;
    UBYTE y;
    UBYTE alive;
    UBYTE direction;
} Bullet;

Bullet bullets[1];
// sprite data - 14 sprites here, 16 bits each (8x8)
// stored as an array of bits
const unsigned char sprites[] = {0xFF,0xFF,0x81,0x81,0xA5,0xA5,0xA5,0xA5,0x81,0x81,0x99,0x99,0x81,0x81,0xFF,0xFF,0x3C,0x3C,0x42,0x42,0x81,0x81,0xED,0xED,0x81,0x81,0x91,0x91,0x42,0x42,0x3C,0x3C,0x99,0x81,0x42,0x5A,0x24,0x3C,0x99,0x7E,0x99,0x7E,0x24,0x3C,0x42,0x5A,0x99,0x81,0x38,0x04,0x7C,0x02,0x5C,0x22,0x5C,0x22,0x5C,0x22,0x5C,0x22,0x7C,0x02,0x38,0x04,0x00,0x00,0x3E,0x3E,0x63,0x63,0x63,0x63,0x63,0x63,0x63,0x63,0x3E,0x3E,0x00,0x00,0x00,0x00,0x1C,0x1C,0x3C,0x3C,0x6C,0x6C,0x0C,0x0C,0x0C,0x0C,0x7F,0x7F,0x00,0x00,0x00,0x00,0x3E,0x3E,0x63,0x63,0x03,0x03,0x1E,0x1E,0x70,0x70,0x7F,0x7F,0x00,0x00,0x00,0x00,0x7F,0x7F,0x03,0x03,0x3E,0x3E,0x07,0x07,0x43,0x43,0x3E,0x3E,0x00,0x00,0x00,0x00,0x60,0x60,0x6C,0x6C,0x6C,0x6C,0x7F,0x7F,0x0C,0x0C,0x0C,0x0C,0x00,0x00,0x00,0x00,0x7F,0x7F,0x60,0x60,0x7E,0x7E,0x03,0x03,0x63,0x63,0x3E,0x3E,0x00,0x00,0x00,0x00,0x3F,0x3F,0x60,0x60,0x7E,0x7E,0x63,0x63,0x63,0x63,0x3E,0x3E,0x00,0x00,0x00,0x00,0x7F,0x7F,0x03,0x03,0x06,0x06,0x0C,0x0C,0x18,0x18,0x30,0x30,0x00,0x00,0x00,0x00,0x3E,0x3E,0x63,0x63,0x63,0x63,0x3E,0x3E,0x63,0x63,0x3E,0x3E,0x00,0x00,0x00,0x00,0x3E,0x3E,0x63,0x63,0x63,0x63,0x3F,0x3F,0x03,0x03,0x7E,0x7E,0x00,0x00};

// background data - 4 sprites here, 16 bits each (8x8)
// stored as an array of bits
const unsigned char myBkgData[] = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x08,0x00,0x08,0x00,0x36,0x00,0x08,0x00,0x08,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x20,0x00,0x50,0x00,0x20,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x04,0x00,0x0E,0x00,0x04,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x50,0x00,0x20,0x00,0x50,0x00,0x00,0x00};

// Primary game loop
void main() {

	initGame();

	while(1) {
		updatePlayer(); // update player position
		HIDE_WIN; // Hide window layer - no windows used
		SHOW_SPRITES; // Show sprites layer
		SHOW_BKG; // Show background layer
		lastKeys = joypad(); // Update keypresses
		wait_vbl_done(); // Wait for vblank to finish - ensures a 60fps max
	}
}

void initGame(){
	DISPLAY_ON; // turns on gameboy lcd
	NR52_REG = 0x8F; // sound on
	NR51_REG = 0x11; // both sound channels
	NR50_REG = 0x77; // volume level, max = 0x77, min = 0x00

	initrand(DIV_REG); // part of gb/rand.h, want to use DIV_REG as per the documentation
	set_sprite_data(0, 14, sprites); // storing sprite data
	set_bkg_data(0, 4, myBkgData); // storing background data - window layer shares this

	playerX = 64; // initial x position for player
	playerY = 64; // initial y position for player

	set_sprite_tile(0,0); // sprite tile representing the player - is first sprite, so 0th index

	// use != in for loops to save cpu time
	for (i=0; i !=10; i++) {
		eX[i] = 16+(rand()); // random x position between 16 and 144
		eY[i] = 16+(rand()); // random y position between 16 and 144
		set_sprite_tile(i+1, 2); // enemy sprite tile set to 2
		move_sprite(i+1,eX[i], eY[i]); // place enemies
	}

	// bulletLive = 0;
	shooting = 0;
	set_sprite_tile(12, 3); // sets sprite tile 03 to index 12
	
	for (i = 0; i != 1; i++) {
		bullets[i].x = 0;
		bullets[i].y = 0;
		bullets[i].alive = 0;
		bullets[i].direction = 0;
	}

	// generate random background tile data
	for (j=0; j != 18; j++) {
		for (i=0; i != 20; i++) {
			randomBkgTiles[i] = rand() % 4;
		}
		set_bkg_tiles(0,j,20,1,randomBkgTiles); // x, y, width, height, background tiles
	}

}

void updatePlayer() {

	// handling movement via dpad

	if (joypad() & J_UP) {

		shooting = 1;
		playerDir = 0;
		
		if (bullets[0].alive == 0) {
			bullets[0].alive = 1;
			playerY += 2;

			if (joypad() & J_LEFT) {
				bullets[0].direction = 4;
			} else if (joypad() & J_RIGHT) {
				bullets[0].direction = 5;
			} else {
				bullets[0].direction = 0;
			}

			bullets[0].x = playerX;
			bullets[0].y = playerY;
			move_sprite(12, bullets[0].x, bullets[0].y); // places sprite on screen
		}
		if (playerY == 15) {
			playerY = 16;
		}
	}

	if (joypad() & J_DOWN){

		shooting = 1;
		playerDir = 2;
		
		if (bullets[0].alive == 0) {
			bullets[0].alive = 1;
			playerY -= 2;
			
			if (joypad() & J_LEFT) {
				bullets[0].direction = 7;
			} else if (joypad() & J_RIGHT) {
				bullets[0].direction = 6;
			} else {
				bullets[0].direction = 2;
			}

			bullets[0].x = playerX;
			bullets[0].y = playerY;
			move_sprite(12, bullets[0].x, bullets[0].y); // places sprite on screen
		}
		if (playerY == 153){
			playerY = 152;
		}
	}

	if (joypad() & J_LEFT){
		
		shooting = 1;
		playerDir = 3;

		if (bullets[0].alive == 0) {
			bullets[0].alive = 1;
			playerX += 2;
			bullets[0].direction = 3;
			bullets[0].x = playerX;
			bullets[0].y = playerY;
			move_sprite(12, bullets[0].x, bullets[0].y); // places sprite on screen
		}
		if (playerX == 7){
			playerX = 8;
		}
	}

	if (joypad() & J_RIGHT){
		
		shooting = 1;
		playerDir = 1;

		if (bullets[0].alive == 0) {
			bullets[0].alive = 1;
			playerX -= 2;
			bullets[0].direction = 1;
			bullets[0].x = playerX;
			bullets[0].y = playerY;
			move_sprite(12, bullets[0].x, bullets[0].y); // places sprite on screen
		}
		if (playerX == 161){
			playerX = 160;
		}
	}

	// hitting A plays a random sound via channel #1
	if (joypad() & J_A) {
		NR11_REG = 0x7f; // audio channel #1, wave pattern duty
		NR12_REG = 0x7f; // volume for 11
		NR13_REG = DIV_REG; // sound frequency least significant bit
		NR14_REG = 0x80 + (DIV_REG % 8); // sound frequency significant 3 bits
	} else if (joypad() & J_B) {
		// bomb code
	} else {
		// making sure no sound plays if the A button is NOT being pressed
		NR11_REG = 0x00;
		NR12_REG = 0x00;
		NR13_REG = 0x00;
		NR14_REG = 0x00;

		shooting = 0;
	}

	move_sprite(0,playerX,playerY); // position player sprite on screen

	if (bullets[0].x > 160 || bullets[0].x == 0 || bullets[0].y > 152 || bullets[0].y == 0) {
		if (shooting == 1) {
			bullets[0].alive = 1;
			switch (playerDir) {
				case 0:
					bullets[0].x = playerX;
					bullets[0].y = playerY - 8;
					break;
				case 1:
					bullets[0].x = playerX + 8;
					bullets[0].y = playerY;
					break;
				case 2:
					bullets[0].x = playerX;
					bullets[0].y = playerY - 8;
					break;
				case 3:
					bullets[0].x = playerX + 8;
					bullets[0].y = playerY;
					break;
			}
		} else {
			bullets[0].alive = 0;
			bullets[0].x = 0;
			bullets[0].y = 0;
		}
	} else {
		switch (bullets[0].direction) {
			case 0:
				bullets[0].y -= 5;
				break;
			case 1:
				bullets[0].x += 5;
				break;
			case 2:
				bullets[0].y += 5;
				break;
			case 3:
				bullets[0].x -= 5;
				break;
			case 4:
				bullets[0].x -= 5;
				bullets[0].y -= 5;
				break;
			case 5:
				bullets[0].x += 5;
				bullets[0].y -= 5;
				break;
			case 6:
				bullets[0].x += 5;
				bullets[0].y += 5;
				break;
			case 7:
				bullets[0].x -= 5;
				bullets[0].y += 5;
				break;
		}
	}

	move_sprite(12, bullets[0].x, bullets[0].y);

	j = 0; // re use j for collision - saves space

	for (i=0; i != 10; i++) {
		if (collisionCheck(playerX, playerY, 8, 8, eX[i], eY[i], 8, 8) == 1){
			j= 1; // if a collision happens
		}
	}

	// changes player sprite if we hit an enemy
	switch (j) {
	// didn't hit
	case 0:
		set_sprite_tile(0,0);
		break;

	// hit
	default:
		set_sprite_tile(0,1);
		break;
	}

}

// simple collision checking, returns 1 for collision
UINT8 collisionCheck(UINT8 x1, UINT8 y1, UINT8 w1, UINT8 h1, UINT8 x2, UINT8 y2, UINT8 w2, UINT8 h2){
	if ((x1 < (x2+w2)) && ((x1+w1) > x2) && (y1 < (h2+y2)) && ((y1+h1) > y2)){
		return 1;
	} else {
		return 0;
	}

}
