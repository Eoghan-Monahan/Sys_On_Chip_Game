
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

jal x1, drawArena # function to draw grid in LED array

lui x20, 0x0010 #store address for inport read

#read inport, call xOrO if MSB of inport asserted. 
#Check for a draw otherwise
mainLoop:
    lw x10, 0xc(x20)
    lui x11, 0b1000
    bgeu x10, x11, xOrO
    jal x0, checkDraw 

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
    #store state of crucial rows in registers
    lw x12,  8(x2)     
    lw x13, 12(x2)  
    lw x14, 28(x2)    
    lw x15, 32(x2)
    lw x16, 48(x2)
    lw x17, 52(x2)
    ret              # PC -> x1 (return address)

#check if the 9th bit is asserted. If it is, draw O. If not, draw X
xOrO:
    andi x11, x10, 0b100000000
    bne x11, x0, writeO
    beq x11, x0, writeX

#Compare current board state to each win state
checkWin:
    and x19, x18, x24
    beq x19, x24, win

    and x19, x18, x25
    beq x19, x25, win

    and x19, x18, x26
    beq x19, x26, win

    and x19, x18, x27
    beq x19, x27, win

    and x19, x18, x28
    beq x19, x28, win

    and x19, x18, x29
    beq x19, x29, win

    and x19, x18, x30
    beq x19, x30, win

    and x19, x18, x31
    beq x19, x31, win

    jal x0, checkDraw

# write "WIN" on screen and loop until rst asserted
win:
    lui x10, 0b00010101011111011001
    sw x10, 40(x2)
    lui x10, 0b00010101000100011101
    sw x10, 36(x2)
    lui x10, 0b00010101000100010101
    sw x10, 32(x2)
    lui x10, 0b00010101000100010111
    sw x10, 28(x2)
    lui x10, 0b00001110011111010011
    sw x10, 24(x2)
    jal x1, clearBoard

#OR together the 2 game state registers.
#If 9 bits asserted, game board is full and it is a draw.
#x22 contains the current locations of Xs, x23 for Os.
checkDraw: 
    or x10, x22, x23
    addi x19, x0, 0b111111111
    bne x10, x19, mainLoop
    jal x0, draw

# write "DRAW" on screen and loop until rst asserted
draw:
    lui x10, 0b00011001100010010101
    sw x10, 40(x2)
    lui x10, 0b00010101010101010101
    sw x10, 36(x2)
    lui x10, 0b00010101100111010101
    sw x10, 32(x2)
    lui x10, 0b00010101100101010101
    sw x10, 28(x2)
    lui x10, 0b00011001010101001110
    sw x10, 24(x2)
    jal x1, clearBoard

clearBoard:
    #sw x0, 60(x2)
    sw x0, 56(x2)
    sw x0, 52(x2)
    sw x0, 48(x2)
    sw x0, 44(x2)
    sw x0, 20(x2)
    sw x0, 16(x2)
    sw x0, 12(x2)
    sw x0,  8(x2)
    sw x0,  4(x2)
    #sw x0,  0(x2)
    a: jal zero, a

#Read in byte and check as to which bit is asserted.
#Use this information to select which zone to write to.
writeX:
    lb x10, 0xc(x20)
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
    lb x10, 0xc(x20)
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

#adds X to top left zone of board. Updates game state.
xTopLeft:
    # create new line to add x to existing drawing
    or x6, x16, x7
    #update gamestate
    addi x11, x0, 0b000000001
    or x22, x22, x11
    jal x0 xTopStoreLoad

xTopCentre:
    or x6, x16, x8
    addi x11, x0, 0b000000010
    or x22, x22, x11
    jal x0 xTopStoreLoad

xTopRight:
    or x6, x16, x9
    addi x11, x0, 0b000000100
    or x22, x22, x11
    jal x0 xTopStoreLoad

#writes X to top row.
#Adds gamestate for X to register x18 to be checked by the checkwin function 
xTopStoreLoad:
    # store new value with x to memory
    sw x6, 48(x2)
    # load current state to registers
    lw x16, 48(x2)  
    addi x18, x22, 0
    jal x0 checkWin

xMiddleLeft:
    or x6, x14, x7
    addi x11, x0, 0b000001000
    or x22, x22, x11
    jal x0 xMiddleStoreLoad

xMiddleCentre:
    or x6, x14, x8
    addi x11, x0, 0b000010000
    or x22, x22, x11
    jal x0 xMiddleStoreLoad

xMiddleRight:
    or x6, x14, x9
    addi x11, x0, 0b000100000
    or x22, x22, x11
    jal x0 xMiddleStoreLoad

xMiddleStoreLoad:
    sw x6, 28(x2)
    lw x14, 28(x2)  
    addi x18, x22, 0
    jal x0 checkWin

xBottomLeft:
    or x6, x12, x7
    addi x11, x0,  0b001000000
    or x22, x22, x11
    jal x0 xBottomStoreLoad

xBottomCentre:
    or x6, x12, x8
    addi x11, x0, 0b010000000
    or x22, x22, x11
    jal x0 xBottomStoreLoad

xBottomRight:
    or x6, x12, x9
    addi x11, x0, 0b100000000
    or x22, x22, x11
    jal x0 xBottomStoreLoad

xBottomStoreLoad:
    # store new value with x to memory
    sw x6,  8(x2)
    # load current state to registers
    lw x12, 8(x2)   
    addi x18, x22, 0
    jal x0 checkWin

#adds O to top left zone of board. Updates game state.
oTopLeft:
    # create new line to add o to existing drawing
    or x5, x17, x7
    or x6, x16, x7
    #update current game state
    addi x11, x0, 0b000000001
    or x23, x23, x11
    jal x0 oTopStoreLoad

oTopCentre: 
    or x5, x17, x8
    or x6, x16, x8
    addi x11, x0, 0b000000010
    or x23, x23, x11
    jal x0 oTopStoreLoad

oTopRight:
    or x5, x17, x9
    or x6, x16, x9
    addi x11, x0, 0b000000100
    or x23, x23, x11
    jal x0 oTopStoreLoad
    
#writes O to top row.
#Adds gamestate for O to register x18 to be checked by the checkwin function
oTopStoreLoad:
    # store new value with o to memory
    sw x6, 48(x2)
    sw x5, 52(x2)
    # load current state to registers
    lw x16, 48(x2)  
    lw x17, 52(x2)
    #Add gamestate for X to register x18 to be checked by the checkwin function
    addi x18, x23, 0
    jal x0 checkWin

oMiddleLeft:
    or x5, x15, x7
    or x6, x14, x7
    addi x11, x0, 0b000001000
    or x23, x23, x11
    jal x0 oMiddleStoreLoad

oMiddleCentre:
    or x5, x15, x8
    or x6, x14, x8
    addi x11, x0, 0b000010000
    or x23, x23, x11
    jal x0 oMiddleStoreLoad

oMiddleRight:
    or x5, x15, x9
    or x6, x14, x9
    addi x11, x0, 0b000100000
    or x23, x23, x11
    jal x0 oMiddleStoreLoad

oMiddleStoreLoad:
    # store new value with o to memory
    sw x6, 28(x2)
    sw x5, 32(x2)
    # load current state to registers
    lw x14, 28(x2)  
    lw x15, 32(x2)
    addi x18, x23, 0
    jal x0 checkWin

oBottomLeft:
    or x5, x13, x7
    or x6, x12, x7
    addi x11, x0, 0b001000000
    or x23, x23, x11
    jal x0 oBottomStoreLoad

oBottomCentre:
    or x5, x13, x8
    or x6, x12, x8
    addi x11, x0, 0b010000000
    or x23, x23, x11
    jal x0 oBottomStoreLoad

oBottomRight:
    or x5, x13, x9
    or x6, x12, x9
    addi x11, x0, 0b100000000
    or x23, x23, x11
    jal x0 oBottomStoreLoad

oBottomStoreLoad:
    # store new value with o to memory
    sw x6, 8(x2)
    sw x5, 12(x2)
    # load current state to registers
    lw x12, 8(x2)  
    lw x13, 12(x2)  
    addi x18, x23, 0
    jal x0 checkWin
