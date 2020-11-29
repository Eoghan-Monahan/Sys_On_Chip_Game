#Win states being stored for later use
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

#initialise gamestate registers for X and O to 0.
addi x16, x0, 0
addi x17, x0, 0

mainLoop:
    lw x10, 0xc(x15)
    lui x11, 0b1000000000000000
    bgeu x10, x11, xOrO
    jal x0, checkDraw 

xOrO:
    addi x11, x0, 0b100000000
    and x12, x10, x11
    bne x12, x0, writeX
    beq x12, x0, writeO

checkDraw: 
    or x18, x16, x17
    addi x19, x0, 0b111111111
    bne x18, x19, mainLoop
    jal x0, draw

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

    jal x0 xTopLeft

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

win:
#TODO: print WIN then stay here

draw:
#TODO: print DRAW then stay here
