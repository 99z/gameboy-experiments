# Registers
* A, F, B, C, D, E, H, L
	* `A` register used as source and destination for 
all 8-bit arithmetic and logical instructions except INC and 
DEC.
	* `F` register = `Flags`, can only be read from. 
However, `Four of the bits in this register indicate the 
outcome of generally the last operation performed. One bit 
indicates whether the last operation produced a zero or not, 
another bit indicates whether or not the last instruction 
generated a carry, yet another indicates whether or not the 
last instruction performed a subtract, and a half-carry flag 
in case a carry is generated between nybbles in a byte.`
	* `B` and `C` used as counters.
	* `D` and `E` used together as 16-bit register for 
holding a destination address.
	* `H` and `L` used together for indirect addressing.
	* `SP` = stack pointer, `PC` = program counter. No 
different than in MIPS except initial values.

# Loading/storing
Remember, 8-bit general purpose registers are all except F.
* `LD A, reg` = reg -> A and vice-versa
* `LD reg, (HL)` = load reg w/ value at address in HL. 
Vice-versa is storing.

## Direct loading
* `LD A, ($3FFF)` = load A from memory location $3FFF
* `LD SP, ($4050) = load sp from memory location $4050 and 
$4051. Stack operations then performed from that new 
address.

## Immediate loading
* `LD C, 3` = same as MIPS, but we don't need a specific 
load immediate instruction
* `LD DE, $FF80` = load DE with $FF80, equivalent to loading 
D with $FF and E with $80

## Indirect loading
* `LD D, (HL)` = loads D with byte at address in HL
* `LD A, (BC)` = loads A with memory address in BC. Can only 
do this with BC and DE

# Instructions
## How to read crib sheet
![](https://files.catbox.moe/1m61fq.png)

* Op-codes grouped by instruction, listed for each possible variation
* Dest and source are self-explanatory
* ZNHC lists results of the 4 bits in the F register from performing the instruction
	* Crib sheet lists what each of these represent

## 8-bit arithmetic and logical instructions
* `ADD` = simple add, can use immediate, register, or byte in memory 
addressed by `HL`
* `ADC` = add with contents of carry flag added to result. Used for large 
integer addition
* `SUB` = simple subtraction, but does not take destination. Single operand 
is instead subtracted from `A` and put in `A`
* `SBC` = subtract with carry
* `AND/OR/XOR` = standard
* `CP` = ComPares operand with contents of accumulator by subtracting. Same 
as SUB but the contents of A aren't changed, just the flags

# 16-bit arithmetic
**Note**: GB is, of course, 8-bit cpu so these aren't used much.
* `ADD HL, rr` = adds contents of register pair `rr` to pair `HL`. `rr` can 
be `BC/DE/HL/SP`
* `INC rr` = increment pair by one
* `DEC rr` = decrement pair by one
