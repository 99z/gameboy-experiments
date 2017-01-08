# gameboy-experiments
Experiments in Gameboy development.

# Development environment
Much of the documentation for Gameboy development assumes running on Windows - often an older version like 2k or XP. All my development is being done on macOS 10.12.x, and as a result it took a bit of time to figure out what tools are the most modern but also Unix-friendly.

* **Emulator**: [BGB](http://bgb.bircd.org). Windows-only binaries, but runs perfectly using [Wine](https://wiki.winehq.org/MacOSX). I recommend installing via the installer packages provided on the WineHQ website instead of via a package manager like MacPorts - I had issues doing it that way.
* **Assembling/linking**: [RGBDS](https://github.com/bentley/rgbds) - I'll also be giving [Wiz](https://github.com/Bananattack/wiz) a try.
  * Possibly [ASMotor](https://code.google.com/archive/p/asmotor/) because "ASMotor is the spiritual successor to RGBDS, which was a fairly popular development package for the Gameboy. ASMotor is written by the original RGBDS author." Manual is offline because Google Code no longer exists, but can be found in this repo in the `docs` folder.
  * [gbdk-n](https://github.com/andreasjhkarlsson/gbdk-n). I'll be writing examples using this in C at first. I intend to transition to using RGBDS and assembly primarily, but to begin C will save me a lot of headache.
* **Art**: [Gameboy Tile Designer](http://www.devrs.com/gb/hmgd/gbtd.html) for 8x8 or 8x16 sprites/tiles. [Gameboy Map Builder](http://www.devrs.com/gb/hmgd/gbmb.html) for background and game maps. Allows us to create maps up to 1024x1024 made up of tiles created by GBTD. Both of these are Windows-only but work perfectly in Wine.

# Learning resources
There's quite a bit of info for Gameboy development. Here I'll be listing resources I found particularly useful for programming using RGBDS/Wiz.

* [The Ultimate Gameboy Talk](https://www.youtube.com/watch?v=CImyDBJSTsQ) from the 33rd Chaos Communication Congress.
* The latest [Pan Doc](http://cratel.wichita.edu/cratel/ECE238Spr08/references?action=AttachFile&do=get&target=gbspec.txt) aka, "Everything you always wanted to know about Gameboy but were afraid to ask." In-depth technical specifications of the system.
* Gameboy Dev's [ASM School](http://gameboy.mongenel.com/asmschool.html). Collection of absolute beginner tutorials using RGBDS. Unfortunately, it is incomplete. Provides a good amount of background information on the system and some very initial programming.
* Wichita State University's [ECE 238](http://cratel.wichita.edu/cratel/ECE238Spr08) course page. Course in assembly taught using Gameboy programming. Surprisingly excellent resource.
  * Also, http://cratel.wichita.edu/cratel/ECE238Spr08/software from the same website has lots of example source code and tools.
* [Assembly Digest](http://assemblydigest.tumblr.com). Collection of tutorials on GB development. Haven't looked at this thoroughly yet.

# Open-source examples
## GBDK + C
* [Return to Databay](https://github.com/Momeka/Databay)
* [Flappy Bird](https://github.com/LuckyLights/flappybird-gb)
* [Novascape](http://ludumdare.com/compo/ludum-dare-34/?action=preview&uid=6823)
* [Squishy the Turtle](http://ludumdare.com/compo/ludum-dare-34/?action=preview&uid=15095)
* [Quadratino](https://github.com/avivace/quadratino) (snake clone, simple)
* [Doctor How](https://github.com/elfgames/doctorhow) Also has music, good for reference


## RGBDS + ASM
* [Hangman](http://cratel.wichita.edu/blogs/assembly08/2008/05/06/alex-esparza-and-thinh-bui-hangman-term-project/)

# Other
Listing of other tools/resources that might be helpful.

* [Link dump](http://jsfiddle.net/electronoob/rmgd3fz1/) From #gbdev on efnet.
* [Awesome Game Boy Development](https://github.com/avivace/awesome-gbdev). Basically a larger, better version of this document :)
* [GBT Player](https://github.com/AntonioND/gbt-player). Used for sound/music composition for use with RGBDS.
