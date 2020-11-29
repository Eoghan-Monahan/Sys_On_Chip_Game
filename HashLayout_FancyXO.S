main:
	#addi x2,  x0, 0xA0   # memory array start address
    lui x14, 0x200
    addi x14, x14, 0x400    # Column data value to be stored in memory array 
	addi x15, x0, -1        # Row data value to be stored in memory array
    lui x13, 0x61800          # X tips left
    lui x12, 0x1E000          # X centre left
    lui x11, 0xC3            # X tips middle
    lui x10, 0x3C             # X centre middle
    addi x9, x0, 0x186           # X tips right
    addi x8, x0, 0x78             # X centre right
    
	mainLoop:
		jal x1, store    # call function to initial memory array. 
						 # PC -> instruction byte address of function store. Return address x1 = PC+4
		jal x1, load     # call function to mirror memory array to register. 
						 # PC -> instruction byte address of function store. Return address x1 = PC+4
        # jal x1, oTopRight
        # jal x1, xMiddleLeft
        # jal x1, oBottomCentre
        # b: jal zero, b
		beq x0, x0, main # loop until reset asserted


# store x15 to 16x32-bit memory array, starting at x2, i.e, byte addresses x2, x2+4, ... x2+0x60  
# increment data to be stored on each function execution  
store: 
    sw x14,  4(x2)    
    sw x14,  8(x2)    
    sw x14, 12(x2)   
    sw x14, 16(x2)   
    sw x15, 20(x2)   
    sw x14, 24(x2)   
    sw x14, 28(x2)   
    sw x14, 32(x2)   
    sw x14, 36(x2)   
    sw x15, 40(x2)   
    sw x14, 44(x2)   
    sw x14, 48(x2)   
    sw x14, 52(x2)   
    sw x14, 56(x2)   
    ret              # PC -> x1 (return address)


#   load registers x31 to x16 from the memory array, i.e, registers x(31-n) = memory( n*4(x2) ) 
#   register(i.e. 0xA0 = register x31)
load: 
    lw x30,  4(x2)   
    lw x29,  8(x2)     
    lw x25, 24(x2)  
    lw x24, 28(x2)    
    lw x20, 44(x2)  
    lw x19, 48(x2)    
    ret              # PC -> x1 (return address)

xTopLeft:
    # create new line to add x to existing drawing
    or x7, x20, x13
    or x6, x19, x12
    # store new value with x to memory
    sw x7, 44(x2)
    sw x6, 48(x2)
    sw x6, 52(x2)
    sw x7, 56(x2)
    # load current state to registers
    lw x20, 44(x2)   
    lw x19, 48(x2)  
    ret

oTopLeft:
    # create new line to add o to existing drawing
    or x6, x19, x12
    # store new value with o to memory
    sw x6, 48(x2)
    sw x6, 52(x2)
    # load current state to registers
    lw x19, 48(x2)  
    ret

xTopCentre:
    # create new line to add x to existing drawing
    or x7, x20, x11
    or x6, x19, x10
    # store new value with x to memory
    sw x7, 44(x2)
    sw x6, 48(x2)
    sw x6, 52(x2)
    sw x7, 56(x2)
    # load current state to registers
    lw x20, 44(x2)   
    lw x19, 48(x2)  
    ret

oTopCentre:
    # create new line to add o to existing drawing
    or x6, x19, x10
    # store new value with o to memory
    sw x6, 48(x2)
    sw x6, 52(x2)
    # load current state to registers
    lw x19, 48(x2)  
    ret

xTopRight:
    # create new line to add x to existing drawing
    or x7, x20, x9
    or x6, x19, x8
    # store new value with x to memory
    sw x7, 44(x2)
    sw x6, 48(x2)
    sw x6, 52(x2)
    sw x7, 56(x2)
    # load current state to registers
    lw x20, 44(x2)   
    lw x19, 48(x2)  
    ret

oTopRight:
    # create new line to add o to existing drawing
    or x6, x19, x8
    # store new value with o to memory
    sw x6, 48(x2)
    sw x6, 52(x2)
    # load current state to registers
    lw x19, 48(x2)  
    ret

xMiddleLeft:
    # create new line to add x to existing drawing
    or x7, x25, x13
    or x6, x24, x12
    # store new value with x to memory
    sw x7, 24(x2)
    sw x6, 28(x2)
    sw x6, 32(x2)
    sw x7, 36(x2)
    # load current state to registers
    lw x25, 24(x2)   
    lw x24, 28(x2)  
    ret

oMiddleLeft:
    # create new line to add o to existing drawing
    or x6, x24, x12
    # store new value with o to memory
    sw x6, 28(x2)
    sw x6, 32(x2)
    # load current state to registers
    lw x24, 28(x2)  
    ret

xMiddleCentre:
    # create new line to add x to existing drawing
    or x7, x25, x11
    or x6, x24, x10
    # store new value with x to memory
    sw x7, 24(x2)
    sw x6, 28(x2)
    sw x6, 32(x2)
    sw x7, 36(x2)
    # load current state to registers
    lw x25, 24(x2)   
    lw x24, 28(x2)  
    ret

oMiddleCentre:
    # create new line to add o to existing drawing
    or x6, x24, x10
    # store new value with o to memory
    sw x6, 28(x2)
    sw x6, 32(x2)
    # load current state to registers
    lw x24, 28(x2)  
    ret

xMiddleRight:
    # create new line to add x to existing drawing
    or x7, x25, x9
    or x6, x24, x8
    # store new value with x to memory
    sw x7, 24(x2)
    sw x6, 28(x2)
    sw x6, 32(x2)
    sw x7, 36(x2)
    # load current state to registers
    lw x25, 24(x2)   
    lw x24, 28(x2)  
    ret

oMiddleRight:
    # create new line to add o to existing drawing
    or x6, x24, x8
    # store new value with o to memory
    sw x6, 28(x2)
    sw x6, 32(x2)
    # load current state to registers
    lw x24, 28(x2)  
    ret

xBottomLeft:
    # create new line to add x to existing drawing
    or x7, x30, x13
    or x6, x29, x12
    # store new value with x to memory
    sw x7,  4(x2)
    sw x6,  8(x2)
    sw x6, 12(x2)
    sw x7, 16(x2)
    # load current state to registers
    lw x30, 4(x2)   
    lw x29, 8(x2)  
    ret

oBottomLeft:
    # create new line to add o to existing drawing
    or x6, x29, x12
    # store new value with o to memory
    sw x6, 8(x2)
    sw x6, 12(x2)
    # load current state to registers
    lw x29, 8(x2)  
    ret

xBottomCentre:
    # create new line to add x to existing drawing
    or x7, x30, x11
    or x6, x29, x10
    # store new value with x to memory
    sw x7,  4(x2)
    sw x6,  8(x2)
    sw x6, 12(x2)
    sw x7, 16(x2)
    # load current state to registers
    lw x30, 4(x2)   
    lw x29, 8(x2)  
    ret

oBottomCentre:
    # create new line to add o to existing drawing
    or x6, x29, x10
    # store new value with o to memory
    sw x6, 8(x2)
    sw x6, 12(x2)
    # load current state to registers
    lw x29, 8(x2)  
    ret

xBottomRight:
    # create new line to add x to existing drawing
    or x7, x30, x9
    or x6, x29, x8
    # store new value with x to memory
    sw x7,  4(x2)
    sw x6,  8(x2)
    sw x6, 12(x2)
    sw x7, 16(x2)
    # load current state to registers
    lw x30, 4(x2)   
    lw x29, 8(x2)  
    ret

oBottomRight:
    # create new line to add o to existing drawing
    or x6, x29, x8
    # store new value with o to memory
    sw x6, 8(x2)
    sw x6, 12(x2)
    # load current state to registers
    lw x29, 8(x2)  
    ret