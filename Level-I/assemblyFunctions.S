#include <avr/io.h>

// r24 is the register that the input value gets stored into

.global hasAOne
hasAOne:
  ldi r22, 0    // load value of 0 in r22
  cpse r24, r22 // cpse performs a compare between two registers Rd and Rr, and skips the next instruction if Rd = Rr
  ldi r24, 1    // if r24 is not equal to zero, then fuction returns true
  ret           // return value


.global byteToAscii
byteToAscii:
  adiw r24, 48  // since the # zero starts at 0x48, add 48 to the current Ascii value, e.g. 9 in hex is 0x57, 9+48=57.
  ret           // return the ascii value as its char equivalent



.global int8ToInt // takes 8bit, converts to 16bit
int8ToInt:
  ldi r25, 0    // store value of 0 in r25, this is the low byte
  sbrc r24, 7   // skip if bit 7 in r24 is cleared (0)
  ldi r25, 255  // store 255 in r25 to make it two bytes (16 bits)
  ret



.global addInt8ToInt // takes 8bit, adds to 16bit
addInt8ToInt:
  call int8ToInt    // converts 8bit into 16bit first
  add r24, r22      // adds 16bit to 16bit, this is adding low bytes together
  adc r25, r23      // this is adding high bytes together
  ret               // added with carry high byte bc you just added the low byte



.global add4Int8  // adds four 8bit values together, returns 16bit sum
add4Int8:
  push r24        // push val-1 onto stack          
  mov r24, r22    // mov val-2 into r24
  call int8ToInt  // converts 8bit into 16bit
  movw r22, r24   // copy r24 into r22 16bit
  pop r24         // restore r24
  call addInt8ToInt // add 8bit r24 to 16bit r22, stored in r24
  movw r22, r24   // copy r24 into r22
  mov r24, r20    // mov val-3 into r24
  call addInt8ToInt // add 8bit r24 to 16bit r22, stored in r24
  movw r22, r24   // copy r24 into r22
  mov r24, r18    // mov val-4 into r24
  call addInt8ToInt // add 8bit r24 to 16bit r22, stored in r24
  ret             // reutrn value in r24



.global average   // add two numbers and average them (divide by 2)
average:
  add r24, r22    // add the two values together
  ror r24         // shift them right once because shifting bits right once is the same thing as dividing by two
  ret




