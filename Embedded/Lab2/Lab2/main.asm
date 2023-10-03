.include "m328Pdef.inc"
.cseg
.org 0

; Configure PB1 and PB2 as output pins.
sbi   DDRB,0      ; ser pin
sbi   DDRB,1      ; srclk pin 
sbi   DDRB,2			;clock pin

; Main loop follows.  Toggle PB1 and PB2 out of phase.
; Assuming there are LEDs and current-limiting resistors
; on these pins, they will blink out of phase.

loop:
sbi   PORTB,1     ; LED at PB1 off
cbi   PORTB,2     ; LED at PB2 on
rcall delay_long  ; Wait
cbi   PORTB,1     ; LED at PB1 on
sbi   PORTB,2     ; LED at PB2 off
rcall delay_long  ; Wait
rjmp   loop

; Generate a delay using two nested loops that do "nothing".
; With a 16 MHz clock, the values below produce a ~4,194.24 ms delay.
;--------------------------------------------------------------------

.equ count = 0x211d ; assign a 16-bit value to symbol "count"

delay_long:
	ldi r30, low(count)   ; r31:r30  <-- load a 16-bit value into counter register for outer loop
	ldi r31, high(count);
	nop
	
d1:

	ldi   r29, 0x91     ; r29 <-- load a 8-bit value into counter register for inner loop
d2:
	nop   ; no operation
	dec   r29			  ; r29 <-- r29 - 1
	brne  d2					; branch to d2 if result is not "0"
	sbiw r31:r30, 1			; r31:r30 <-- r31:r30 - 1
	brne d1					; branch to d1 if result is not "0"
	ret						; return


.exit


; display a digit 
ldi R16, 0x70 ; load pattern to display
rcall display ; call display subroutine

display: ; backup used registers on stack
push R16
push R17
in R17, SREG
push R17

ldi R17, 8 ; loop --> test all 8 bits
loop:
rol R16 ; rotate left trough Carry
BRCS set_ser_in_1 ; branch if Carry is set
sbi PORTB, 
;put code here to set SER to 0


...

rjmp end
set_ser_in_1:
;ser is pin14

; put code here to set SER to 1...

end:
;srclk is pin 11
; put code here to generate SRCLK pulse...
dec R17
brne loop
;rclk is pin 10
; put code here to generate RCLK pulse
...
; restore registers from stack
pop R17out SREG, R17
pop R17pop R16
ret  