
# values required to draw x/o markers
lui x7, 0x1E000         # left x/o
lui x8, 0x3C            # middle x/o
addi x9, x0, 0x78       # right x/o

# win states being stored for later use
addi x24, x0, 0b000000111
addi x25, x0, 0b000111000
addi x26, x0, 0b111000000
addi x27, x0, 0b100010001
addi x28, x0, 0b001010100
addi x29, x0, 0b100100100
addi x30, x0, 0b010010010
addi x31, x0, 0b001001001
# addi x24, x0, 0b10000000
# addi x25, x0, 0b1000000
# addi x26, x0, 0b100000
# addi x27, x0, 0b10000
# addi x28, x0, 0b1000
# addi x29, x0, 0b100
# addi x30, x0, 0b10
# addi x31, x0, 0b1

# initialise gamestate registers for X and O to 0.
addi x22, x0, 0
addi x23, x0, 0

jal x1, drawArena # function to draw grid in LED array

mainLoop:
    lw x10, 0xc(x15)
    lui x11, 0b1000000000000000
    bgeu x10, x11, xOrO
    jal x0, checkDraw 
	beq x0, x0, mainLoop # loop until reset asserted

drawArena: 
    # values to write to memory to draw grid arena
    lui x5, 0x200
    addi x5, x5, 0x400      # Column data value to be stored in memory array 
    addi x6, x0, -1         # Row data value to be stored in memory array
    # store grid arena design in memory
    sw x5,  4(x2)    
    sw x5,  8(x2)    
    sw x5, 12(x2)   
    sw x5, 16(x2)   
    sw x6, 20(x2)   
    sw x5, 24(x2)   
    sw x5, 28(x2)   
    sw x5, 32(x2)   
    sw x5, 36(x2)   
    sw x6, 40(x2)   
    sw x5, 44(x2)   
    sw x5, 48(x2)   
    sw x5, 52(x2)   
    sw x5, 56(x2)  
    # store state of crucial rows in registers
    lw x12,  8(x2)     
    lw x13, 12(x2)  
    lw x14, 28(x2)    
    lw x15, 32(x2)
    lw x16, 48(x2)
    lw x17, 52(x2)
    ret              # PC -> x1 (return address)

xOrO:
    andi x23, x10, 0b100000000
    bne x23, x0, writeX
    beq x23, x0, writeO

checkWin:
    beq x18, x24, win
    beq x18, x25, win
    beq x18, x26, win
    beq x18, x27, win
    beq x18, x28, win
    beq x18, x29, win
    beq x18, x30, win
    beq x18, x31, win
    jal x0, checkDraw

# write "WIN" on screen and loop until rst asserted
win:
    sw x0, 44(x2)
    sw x0, 20(x2)
    lui x10, 0x923E
    addi x10, x10, 0x310
    sw x10, 40(x2)
    lui x10, 0x9208
    addi x10, x10, 0x290
    sw x10, 36(x2)
    lui x10, 0x5408
    addi x10, x10, 0x2D0
    sw x10, 32(x2)
    lui x10, 0x5408
    addi x10, x10, 0x250
    sw x10, 28(x2)
    lui x10, 0x383E
    addi x10, x10, 0x230
    sw x10, 24(x2)
    b: jal zero, b

checkDraw: 
    or x18, x22, x23
    addi x19, x0, 0b111111111
    bne x18, x19, mainLoop
    jal x0, draw

# write "DRAW" on screen and loop until rst asserted
draw:
    sw x0, 44(x2)
    sw x0, 20(x2)
    lui x10, 0x1C704
    addi x10, x10, 0x248
    sw x10, 40(x2)
    lui x10, 0x1248A
    addi x10, x10, 0x248
    sw x10, 36(x2)
    lui x10, 0x1270E
    addi x10, x10, 0x150
    sw x10, 32(x2)
    lui x10, 0x12511
    addi x10, x10, 0x150
    sw x10, 28(x2)
    lui x10, 0x1C491
    addi x10, x10, 0x0E0
    sw x10, 24(x2)
    c: jal zero, c

writeX:
    lh x10, 0xc(x15)
    addi x11, x0, 0b10000000
    bgeu x10, x11, xBottomRight

    addi x11, x0, 0b1000000
    bgeu x10, x11, xBottomCentre

    addi x11, x0, 0b100000
    bgeu x10, x11, xBottomLeft

    addi x11, x0, 0b10000
    bgeu x10, x11, xMiddleRight

    addi x11, x0, 0b1000
    bgeu x10, x11, xMiddleCentre

    addi x11, x0, 0b100
    bgeu x10, x11, xMiddleLeft

    addi x11, x0, 0b10
    bgeu x10, x11, xTopRight

    addi x11, x0, 0b1
    bgeu x10, x11, xTopCentre

    jal x0 xTopLeft

writeO:
    lh x10, 0xc(x15)
    addi x11, x0, 0b10000000
    bgeu x10, x11, oBottomRight

    addi x11, x0, 0b1000000
    bgeu x10, x11, oBottomCentre

    addi x11, x0, 0b100000
    bgeu x10, x11, oBottomLeft

    addi x11, x0, 0b10000
    bgeu x10, x11, oMiddleRight

    addi x11, x0, 0b1000
    bgeu x10, x11, oMiddleCentre

    addi x11, x0, 0b100
    bgeu x10, x11, oMiddleLeft

    addi x11, x0, 0b10
    bgeu x10, x11, oTopRight

    addi x11, x0, 0b1
    bgeu x10, x11, oTopCentre

    jal x0 oTopLeft

xTopLeft:
    # create new line to add x to existing drawing
    or x6, x16, x7
    #update gamestate and check if there is a winner
    addi x11, x0, 0b000000001
    or x22, x22, x11
    jal x0 xTopStoreLoad

xTopCentre:
    # create new line to add x to existing drawing
    or x6, x16, x8
    addi x11, x0, 0b000000010
    or x22, x22, x11
    jal x0 xTopStoreLoad

xTopRight:
    # create new line to add x to existing drawing
    or x6, x16, x9
    addi x11, x0, 0b000000100
    or x22, x22, x11
    jal x0 xTopStoreLoad

xTopStoreLoad:
    # store new value with x to memory
    sw x6, 48(x2)
    # load current state to registers
    lw x16, 48(x2)  
    jal x0 checkWin

xMiddleLeft:
    # create new line to add x to existing drawing
    or x6, x14, x7
    addi x11, x0, 0b000001000
    or x22, x22, x11
    jal x0 xMiddleStoreLoad

xMiddleCentre:
    # create new line to add x to existing drawing
    or x6, x14, x8
    addi x11, x0, 0b000010000
    or x22, x22, x11
    jal x0 xMiddleStoreLoad

xMiddleRight:
    # create new line to add x to existing drawing
    or x6, x14, x9
    addi x11, x0, 0b000100000
    or x22, x22, x11
    jal x0 xMiddleStoreLoad

xMiddleStoreLoad:
    # store new value with x to memory
    sw x6, 28(x2)
    # load current state to registers
    lw x14, 28(x2)  
    jal x0 checkWin

xBottomLeft:
    # create new line to add x to existing drawing
    or x6, x12, x7
    addi x11, x0,  0b001000000
    or x22, x22, x11
    jal x0 xBottomStoreLoad

xBottomCentre:
    # create new line to add x to existing drawing
    or x6, x12, x8
    addi x11, x0, 0b010000000
    or x22, x22, x11
    jal x0 xBottomStoreLoad

xBottomRight:
    # create new line to add x to existing drawing
    or x6, x12, x9
    addi x11, x0, 0b100000000
    or x22, x22, x11
    jal x0 xBottomStoreLoad

xBottomStoreLoad:
    # store new value with x to memory
    sw x6,  8(x2)
    # load current state to registers
    lw x12, 4(x2)   
    jal x0 checkWin

oTopLeft:
    # create new line to add o to existing drawing
    or x6, x16, x7
    addi x11, x0, 0b000000001
    or x23, x23, x11
    jal x0 oTopStoreLoad

oTopCentre:
    # create new line to add o to existing drawing
    or x6, x16, x8
    addi x11, x0, 0b000000010
    or x23, x23, x11
    jal x0 oTopStoreLoad

oTopRight:
    # create new line to add o to existing drawing
    or x6, x16, x9
    addi x11, x0, 0b000000100
    or x23, x23, x11
    jal x0 oTopStoreLoad
    
oTopStoreLoad:
    # store new value with o to memory
    sw x6, 48(x2)
    sw x6, 52(x2)
    # load current state to registers
    lw x16, 48(x2)  
    lw x17, 52(x2)
    jal x0 checkWin

oMiddleLeft:
    # create new line to add o to existing drawing
    or x6, x14, x7
    addi x11, x0, 0b000001000
    or x23, x23, x11
    jal x0 oMiddleStoreLoad

oMiddleCentre:
    # create new line to add o to existing drawing
    or x6, x14, x8
    addi x11, x0, 0b000010000
    or x23, x23, x11
    jal x0 oMiddleStoreLoad

oMiddleRight:
    # create new line to add o to existing drawing
    or x6, x14, x9
    addi x11, x0, 0b000100000
    or x23, x23, x11
    jal x0 oMiddleStoreLoad

oMiddleStoreLoad:
    # store new value with o to memory
    sw x6, 28(x2)
    sw x6, 32(x2)
    # load current state to registers
    lw x14, 28(x2)  
    lw x15, 32(x2)
    jal x0 checkWin

oBottomLeft:
    # create new line to add o to existing drawing
    or x6, x12, x7
    addi x11, x0, 0b001000000
    or x23, x23, x11
    jal x0 oBottomStoreLoad

oBottomCentre:
    # create new line to add o to existing drawing
    or x6, x12, x8
    addi x11, x0, 0b010000000
    or x23, x23, x11
    jal x0 oBottomStoreLoad

oBottomRight:
    # create new line to add o to existing drawing
    or x6, x12, x9
    addi x11, x0, 0b100000000
    or x23, x23, x11
    jal x0 oBottomStoreLoad

oBottomStoreLoad:
    # store new value with o to memory
    sw x6, 8(x2)
    sw x6, 12(x2)
    # load current state to registers
    lw x12, 8(x2)  
    lw x13, 12(x2)  
    jal x0 checkWin
