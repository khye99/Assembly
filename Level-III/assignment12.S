#include <avr/io.h>
#include "asmMacros.s"  // Include macros to print log messages or a single register
.data
globalV: .byte 0
.text

.global updateGlobal
updateGlobal:
  // TODO: void updateGlobal(byte a)
  ldi r30, lo8(globalV)   // store the low 8 bits of global reference
  ldi r31, hi8(globalV)   // store the high 8 bits of global reference
  ld r22, Z               // accessing the reference to get value, put it in r22
  add r24, r22            // add new global to old global
  sts globalV, r24        // stores new global value into global variable
//  st Z, r24
  ret
  

.global getGlobal
getGlobal:
  // TODO: uint8_t getGlobal()
  ldi r30, lo8(globalV)   // store low 8 bits of global reference
  ldi r31, hi8(globalV)   // store high 8 bits of global reference
  ld r24, Z               // accessing the reference to get value, put it in r24
//  printAReg 24  
  ret                   


.global cStringLength
cStringLength:
  // TODO: uint8_t cStringLength(const char aString[])
    mov r30, r24          // take array pointer low, puts it in r30
    mov r31, r25          // take arrya pointer high, puts it in r31
    ldi r24, 0            // loads 0 into r24
  loop1:
    ld r23, Z+            // access the value of the next char, then increment to next pointer
    cp r23, r24           // compare the char value in array to 0
    breq ending           // if they're equal, array is over, go to end
    inc r1                // r1 is the counter, we have to find length of array, increment this
    jmp loop1             // if array is not over, loop through again
  ending:
    mov r24, r1           // move the counter into r24
    clr r1                // make sure to clear r1
    ret                   // return

.global sumArrays
sumArrays:
  // TODO: void sumArrays(uint8_t *a, uint8_t *b, uint8_t *c, byte length)
  mov r30, r24            // store low bits into Z register
  mov r31, r25            // store high bits into Z register
  mov r26, r22            // store low bits into X register
  mov r27, r23            // store high bits into X register
  mov r0, r18             // store array length into temp reg. r0

  // use Y register push/pop stack

  looping:
    cp r1, r0             // compare 0 with array length(r0)
    breq endF             // if array length is zero, or if counter catches up to last index, you're done
    ld r22, X+            // load "value" of reference 2nd array into r22, then increment
    ld r18, Z+            // load "value" of reference 1st array into r18, then increment
    add r18, r22          // add the values together
                          // SUM is in r18
    mov r30, r20          // reference of empty array into r30 (Z reg)
    st Z+, r18            // store that SUM into where the Z was referencing (r20), then increment 
    inc r20               // reference of empty array ++
    inc r24               // reference of 1st array ++
    mov r30, r24          // re-move next reference into Z register, since we had to use it for something else
    inc r1                // increment r1 to count index
    jmp looping           // loop again
  endF:
    clr r0        
    clr r1
    ret

.global dot
dot:
  // TODO uint16_t dot(uint8_t *a, uint8_t *b, byte length)
  mov r26, r24        // store low reference bits into X register 1st array
  mov r27, r25        // store high reference bits into X register 1st array
  mov r30, r22        // store low reference bits into Z register 2nd array
  mov r31, r23        // store high reference bits into Z register 2nd array
                      // r20 hold the length
  ldi r18, 0          // load 0 into r18
  ldi r24, 0          // load 0 into r24
  ldi r25, 0          // load 0 into r25

  loopDot:
    cpi r20, 0        // compare array length with 0
    breq endDot       // if it's zero, or goes to 0, then it's over
    ld r18, X+        // load 1st reference "value" into r18, then increment 1st array
    ld r22, Z+        // load 2nd reference "value" into r22, then increment 2nd array
    mul r18, r22      // multiply the two values together
                      // product in r18
    add r24, r0       // add multiplied low byte value into r24
    adc r25, r1       // add multiplied high byte value into r25
    dec r20           // decrement size of array until reaches 0
//    call printRegs 
    jmp loopDot

  endDot:           
    clr r0
    clr r1
    ret

