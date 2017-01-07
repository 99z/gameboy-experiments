# gameboy-experiments
Experiments in Gameboy development.

# Development environment
Much of the documentation for Gameboy development assumes running on Windows - often an older version like 2k or XP. All my development is being done on macOS 10.12.x, and as a result it took a bit of time to figure out what tools are the most modern but also Unix-friendly.

* **Emulator**: [BGB](http://bgb.bircd.org). Windows-only binaries, but runs perfectly using [Wine](https://wiki.winehq.org/MacOSX). I recommend installing via the installer packages provided on the WineHQ website instead of via a package manager like MacPorts - I had issues doing it that way.
* **Assembling/linking**: [RGBDS](https://github.com/bentley/rgbds) - I'll also be giving [Wiz](https://github.com/Bananattack/wiz) a try. Initially I intended to use [gbdk-n](https://github.com/andreasjhkarlsson/gbdk-n) and write all code in C, but most tutorials and GB programming resources use assembly. Certain things like sound are actually easier in assembly, and it's just the way the GB was meant to be programmed :)
  * Possibly [ASMotor](https://code.google.com/archive/p/asmotor/) because "ASMotor is the spiritual successor to RGBDS, which was a fairly popular development package for the Gameboy. ASMotor is written by the original RGBDS author." Manual is offline because Google Code no longer exists, but can be found in this repo in the `docs` folder.
* **Art**: [Gameboy Tile Designer](http://www.devrs.com/gb/hmgd/gbtd.html) for 8x8 or 8x16 sprites/tiles. [Gameboy Map Builder](http://www.devrs.com/gb/hmgd/gbmb.html) for background and game maps. Allows us to create maps up to 1024x1024 made up of tiles created by GBTD. Both of these are Windows-only but work perfectly in Wine.

# Learning resources
There's quite a bit of info for Gameboy development. Here I'll be listing resources I found particularly useful for programming using RGBDS/Wiz.

* [The Ultimate Gameboy Talk](https://www.youtube.com/watch?v=CImyDBJSTsQ) from the 33rd Chaos Communication Congress.
* The latest [Pan Doc](http://cratel.wichita.edu/cratel/ECE238Spr08/references?action=AttachFile&do=get&target=gbspec.txt) aka, "Everything you always wanted to know about Gameboy but were afraid to ask." In-depth technical specifications of the system.
* Gameboy Dev's [ASM School](http://gameboy.mongenel.com/asmschool.html). Collection of absolute beginner tutorials using RGBDS. Unfortunately, it is incomplete. Provides a good amount of background information on the system and some very initial programming.
* Wichita State University's [ECE 238](http://cratel.wichita.edu/cratel/ECE238Spr08) course page. Course in assembly taught using Gameboy programming. Surprisingly excellent resource.
  * Also, http://cratel.wichita.edu/cratel/ECE238Spr08/software from the same website has lots of example source code and tools.
* [Assembly Digest](http://assemblydigest.tumblr.com). Collection of tutorials on GB development. Haven't looked at this thoroughly yet.

# Other
Listing of other tools/resources that might be helpful.

* [GBT Player](https://github.com/AntonioND/gbt-player). Used for sound/music composition for use with RGBDS.
