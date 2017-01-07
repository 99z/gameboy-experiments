#include <gb/rand.h> // random functions
#include <gb/gb.h> // required
#include <gb/hardware.h> // hardware references

// FUNCTION DECLARATIONS
void initGame(); // INITIALISE OUR GAME
void updatePlayer(); // UPDATE OUR PLAYER
UINT8 collisionCheck(UINT8, UINT8, UINT8, UINT8, UINT8, UINT8, UINT8, UINT8); 	// SIMPLE RECT TO RECT CHECK

// VARIABLE DECLARATIONS - STORED IN RAM
UINT8 i, j;																		// GENERIC LOOPING VARIABLE

UINT8 playerX, playerY;															// PLAYER CO-ORDINATES
UINT8 eX[10], eY[10];															// ENEMY CO-ORDINATES
UINT8 lastKeys;																	// HOLDS KEYS FOR THE PREVIOUS FRAME

UINT8 randomBkgTiles[20]; // CONTAINS RANDOM DATA FOR OUR BKG

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
		NR10_REG = 0x1E;
		NR11_REG = 0x10;
		NR12_REG = 0xF3;
		NR13_REG = 0x00;
		NR14_REG = 0x87;
		updatePlayer(); // update player position
		HIDE_WIN; // Hide window layer - no windows used
		SHOW_SPRITES; // Show sprites layer
		SHOW_BKG; // Show background layer
		lastKeys = joypad(); // Update keypresses
		wait_vbl_done(); // Wait for vblank to finish - ensures a 60fps max
	}
}

void initGame(){
	
	DISPLAY_ON; // TURNS ON THE GAMEBOY LCD
	NR52_REG = 0x8F; // TURN SOUND ON
	NR51_REG = 0x11; // ENABLE SOUND CHANNELS
	NR50_REG = 0x77; // VOLUME MAX = 0x77, MIN = 0x00
	
	initrand(DIV_REG);															// SEED OUR RANDOMIZER
	
	set_sprite_data(0, 14, sprites);											// STORE OUR SPRITE DATA AT THE START OF SPRITE VRAM
	set_bkg_data(0, 4, myBkgData);												// STORE OUR BKG DATA AT THE START OF BKG VRAM - NOTE, THE WINDOW LAYER SHARED THE BKG VRAM BY DEFAULT

	playerX = 64;																// PLAYERS INITAL X POSITION
	playerY = 64;																// PLAYERS INITAL Y POSITION
	
	set_sprite_tile(0,0);														//PLAYERS SPRITE TILE - 0
	
		for (i=0; i !=10; i++){													// OUR ENEMY POSITION LOOP - NOTE, USE !=, NOT < TO SCRAPE BACK SOME CPU TIME
		
		eX[i] = 16+(rand() >> 1);												// RANDOM X POSITION 16 - 144
		eY[i] = 16+(rand() >> 1);												// RANDOM Y POSITION 16 - 144
		set_sprite_tile(i+1, 2);												// ENEMIES SRITE TILE - SET TO SPRITE 2
		move_sprite(i+1,eX[i], eY[i]);											// POSITION ENEMIES	
		
		}
		
		
		// GENERATE RANDOM BKG TILE DATA - SO STARRY!
		
		for (j=0; j != 18; j++){
		
			for (i=0; i != 20; i++){		
			randomBkgTiles[i] = rand() % 4;		
			}
		
		set_bkg_tiles(0,j,20,1,randomBkgTiles);									// SET A LINE OF BKG DATA (X, Y, W, H, DATA)
		}
	
	}

////////////////////////////////////////////////////////////////////////////////
// UPDATE PLAYER

	void updatePlayer(){
	
	// MOTION VIA DPAD - LIMITED TO A CERTAIN AREA ON SCREEN
	
	// UP
		if (joypad() & J_UP){
		playerY--;
			if (playerY == 15){
			playerY = 16;
			}
		}

	// DOWN
		if (joypad() & J_DOWN){
		playerY++;
			if (playerY == 153){
			playerY = 152;
			}
		}

	// LEFT
		if (joypad() & J_LEFT){
		playerX--;
			if (playerX == 7){
			playerX = 8;
			}
		}	
	
	// RIGHT
		if (joypad() & J_RIGHT){
		playerX++;
			if (playerX == 161){
			playerX = 160;
			}
		}	
	
	// END MOTION VIA DPAD
	
	// TAP A - PLAYS A RANDOM BEEP THROUGH SOUND CHANNEL 1 - SQUARE WAVE CHANNEL
	
		if (joypad() & J_A){
		
		NR11_REG = 0x7f; 													// SQUARE WAVE DUTY
		NR12_REG = 0x7f; 													// VOLUME 0 = quietest, 255 = loudest
		NR13_REG = DIV_REG;													// LOWER BITS OF SOUND FREQ
		NR14_REG = 0x80 + (DIV_REG % 8); 									// LARGER SOUND FREQ - MINIMUM OF 128 - TOP 3 BYTES - ANY LESS = SOUND CHANNEL SWITCHES OFF
		} else {
		NR11_REG = 0x00;													// NO A BUTTON - NO SOUND
		NR12_REG = 0x00;
		NR13_REG = 0x00;
		NR14_REG = 0x00;
		}


	//MOVE OUR SPRITE
	move_sprite(0,playerX,playerY);												// POSITION OUR SPRITE ON THE SCREEN	
	
	j=0;																		// RE-USE J AS A FLAG TO SEE IF WE HAVE COLLIDED WITH AN ENEMY
	
		for (i=0; i != 10; i++){												// LOOP THROUGH OUR 10 ENEMIES
		
			if (collisionCheck(playerX, playerY, 8, 8, eX[i], eY[i], 8, 8) == 1){
			j= 1;																// IF WE COLLIDED, SET OUR FLAG VARIABLE, J TO 1
			}
			
		}
		
		// ADJUST OUR PLAYER SPRITES FRAME IF THEY HIT SOMETHING
		switch (j){
		// NO HIT
		case 0:
		set_sprite_tile(0,0);
		break;
		
		// HIT ENEMY
		default:
		set_sprite_tile(0,1);
		break;		
		}
	
	}

////////////////////////////////////////////////////////////////////////////////
// COLLISION CHECKER - SIMPLE RECTANGLE COLLISION CHECKING
// RETURNS 1 IF OVERLAPPING

	UINT8 collisionCheck(UINT8 x1, UINT8 y1, UINT8 w1, UINT8 h1, UINT8 x2, UINT8 y2, UINT8 w2, UINT8 h2){

		if ((x1 < (x2+w2)) && ((x1+w1) > x2) && (y1 < (h2+y2)) && ((y1+h1) > y2)){
		return 1;
		} else {
		return 0;
		}

	}
