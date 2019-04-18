#include <avr/io.h>
#include "asmMacros.s"  // Include macros to print log messages or a single register
.text


.global slowDivisionUint8
slowDivisionUint8:
  // TODO: uint8_t slowDivisionUint8(uint8_t a, uint8_t b) divd/divs
  cp r24, r22     // compare the dividend with the divisor
  brlo end8       // unsigned, branch if r24(dividend) is smaller than r22(divisor) 
  loop8:  
    inc r1        // r1 is the counter of how many times number can be divided
    sub r24, r22  // subtract divisor from dividend
    cp r24, r22   // compare dividend with divisor
    brlo end8     // branch if dividend is finally smaller than divisor
    jmp loop8     // if not smaller, than loop back and do it again
  end8:           // if the dividend is finally smaller than the divisor
    mov r24, r1   // it divides 0 times so move 0 into r24 or r1 is also the counter
    clr r1        // clear r1 since it was the counter
  ret


.global greaterThanOrEqualUInt16
greaterThanOrEqualUInt16:
  // TODO: bool greaterThanOrEqualUInt16(uint16_t a, uint16_t b)
  cp r25, r23     // compare high byte of each value a and b
  brsh checkEqual // unsigned, branch if a is > or = b
  ldi r24, 0      // if a is not >= b, then function return 0, or false
  ret
  
  checkEqual:     // check to see if high bytes are equal specifically
    cp r25, r23   // compare high bytes of a and b
    breq checkLow   // branch if they are equal to checkLower
    jmp isTrue    // if they're not equal, then it must be a is > b, jump to isTrue
    
  checkLow:     // if high bytes are equal, start checking lower bytes
    cp r24, r22   // compare lower bytes to each other
    brsh isTrue   // if a is > or = b, jump to return true 
    ldi r24, 0    // if a is < b, load 0 into r24
    ret           // return r24
    
  isTrue:         // a is > b
    ldi r24, 1    // load 1(true) into r24
  ret             // return r24


.global slowDivisionUint16
slowDivisionUint16:
  // TODO: uint16_t slowDivisionUint16(uint16_t a, uint16_t b)
  ldi r21, 0
  ldi r20, 0
  ldi r19, 0
  ldi r18, 1
  cp r24, r22     // compare low bytes, they are subtracting
  cpc r25, r23    // compare high bytes
  brlo end16      // unsigned, branch if r24r25(dividend) is smaller than r22r23(divisor)
  loop16:         // if dividened is not smaller than divisor
    add r20, r18  // add 1 to r20     add 1 to the counter
    adc r21, r19  // add 0 to r21     keep adding 0 until overflow, which will become 1
    sub r24, r22  // subtract a's low byte from b's low byte
    sbc r25, r23  // subtract a's high byte from b's high byte
    cp r24, r22   // compare low bytes
    cpc r25, r23  // compare high bytes
    brlo end16    // branch if dividend r24r25 is finally smaller than divisor r22r23
    jmp loop16    // if not, do the loop again
  end16:          
    mov r24, r20  // low byte, mov r20, which is 0 or the counter #, into r24
    mov r25, r21  // high byte, mov r21, which is 0 or the counter #, into r25
  ret             // return 0, it divided into 0 times

.global slowModulusUint8
slowModulusUint8:
  // TODO: uint16_t slowModulusUint8(uint8_t a, uint8_t b)
  mov r18, r24            // moves the a value from r24 into r18
  call slowDivisionUint8  // how many times b go into a, that value goes into r24
  mul r24, r22            // unsigned, multiply back the divided # with b(divisor)
  mov r24, r18            // move a value back into r24
  sub r18, r0             // a value minus the divided value, which is stored in r0 for no good reason
  mov r24, r18            // a value minus the divided value is the modulus
  clr r0                  // clear r0
  clr r1                  // clear r1
  ret                     // return r24 the modulus

.global sumOddsUint8
sumOddsUint8:
  // TODO uint16_t sumOddsUint8(uint8_t a, uint8_t b)
  push r24        // push a value onto the stack
  mov r24, r22    // move b value into r24 (copy)
  push r22        // move b value oto the stack
  ldi r22, 2      // load 2 into r22
  call slowModulusUint8   // call the modulus, see if there is remainder (upper bound)
  cpi r24, 1      // r24 with a constant 1
  breq loopFirst  // if remainder of 1, (upper bound odd #) branch to loopFirst
  jmp loopSecond  // if remainder of 0, (upper bound even #) branch to loopSecond
  
  loopFirst:
    pop r22       // pop b back into r22
    pop r24       // pop a back into r24
    ldi r20, 0    // load 0 into r20, placeholder
    jmp loopThird
    
  loopSecond: //since upper bound is even,start here, make it odd then go to loopThird
    pop r22       // pop b back into r22
    pop r24       // pop a back into r 24
    ldi r20, 0    // load 0 into r20, placeholder
    subi r22, 1   // made even upper bound odd
    jmp loopThird // do the math in loopThird
    
  loopThird:      // upper bound is already odd
    cp r22, r24   // compare b with a (subtraction comparison)
    brlo ending      // if b(upper bound) is smaller than a(lower bound), branch to end
    add r20, r22  // if not, add b(r22) to r20, summed up value will be stored in r20
    subi r22, 2   // subtract constant 2 (going to next sml odd #) from r22
    jmp loopThird // loop again
    
  ending:
    mov r24, r20  // r20, is zero, or the summed up value, mov it to r24 to be returned
    ret           // return 0 or summed up value

