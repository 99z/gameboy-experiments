# Emulator plan
1. Implement [CPU opcodes](http://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html)
	* Early [Coffee-GB](https://github.com/trekawek/coffee-gb/tree/e6230db0b34521b2d2b33b2dac0773f0476a32a2) commit shows this step
2. Implement memory
	* Probably modelled using an array
3. Test CPU + memory, get GB bootrom to load
4. Implement GPU - [Ultimate Gameboy Talk](https://www.youtube.com/watch?v=HyzD8pNlpwI&t=29m12s) goes over GPU details
5. Implement subsystems:
	* D-Pad
	* Timer
	* Direct Memory Access (DMA)
		* DMA info: https://exez.in/gameboy-dma
	* Sprites
	* Interrupts
	* Memory bank switching (not needed for games under 32kb
	* Sound
		* [CPU Manual](http://marc.rawer.de/Gameboy/Docs/GBCPUman.pdf)
		* [GB Sound Hardware wiki](http://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware)
