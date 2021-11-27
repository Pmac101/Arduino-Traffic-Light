;
; TrafficLight.asm
;
; Created: 11/20/2021 10:18:29 AM
; Author : Patrick McCormick
; Purpose: main TrafficLight file
; this program controls two sets of traffic lights. does not have interrupt capabilities

MAIN:
     ldi  r16, high(RAMEND)
     out  SPH, r16
     ldi  r16, low(RAMEND)
     out  SPL, r16
     ;--------------Traffic Light 1 labeled as: TL1---------------------
     SBI  DDRB, 5                  ; set PB5 to output (TL1: red LED)
     SBI  DDRB, 4                  ; set PB4 to output (TL1: yellow LED)
     SBI  DDRB, 3                  ; set PB3 to output (TL1: green LED)

     ;--------------Traffic Light 2 labeled as: TL2---------------------
     SBI  DDRB, 2                  ; set PB5 to output (TL2: red LED)
     SBI  DDRB, 1                  ; set PB4 to output (TL2: yellow LED)
     SBI  DDRB, 0                  ; set PB3 to output (TL2: green LED)


;--------------------Blink Function--------------------------------------
BLINK:
     SBI  PORTB, 5                 ; turns on TL1: red
     SBI  PORTB, 0                 ; turns on TL2: green
     RCALL TIMER1_DELAY            
     CBI  PORTB, 5                 ; turns off TL1: red
     CBI  PORTB, 0                 ; turns off TL2: green
     SBI  PORTB, 4                 ; turns on TL1: yellow
     SBI  PORTB, 1                 ; turns on TL2: yellow
     RCALL TIMER1_DELAY
     CBI  PORTB, 4                 ; turns off TL1: yellow
     CBI  PORTB, 1                 ; turns off TL2: yellow
     SBI  PORTB, 3                 ; turns on TL1: green
     SBI  PORTB, 2                 ; turns on TL2: red
     RCALL TIMER1_DELAY
     CBI  PORTB, 3                 ; turns off TL1: green
     CBI  PORTB, 2                 ; turns off TL2: red
                 
     RJMP BLINK
;--------------------------------------------------------------

END_MAIN:
     RJMP MAIN

;--------------------Timer 1 Delay--------------------------
TIMER1_DELAY:
     LDI  R20, 0x0B                ; load timer1 HIGH byte
     STS  TCNT1H, R20              ; TCNT1H = 0x0B
     LDI  R20, 0xDC                ; load timer1 LOW byte
     STS  TCNT1L, R20              ; TCNT1L = 0xDC
     LDI  R20, 0x00
     STS  TCCR1A, R20              ; Normal Mode
     LDI  R20, 0x04
     STS  TCCR1B, R20              ; sets 256 prescaler
;------------------------------------------------------------------

;--------------------Repeat Timer1 Function-------------------------
AGAIN:
     SBIS TIFR1, TOV1              ; IF: TOV1 is set skip next instruction
     RJMP AGAIN
     LDI  R20, 0x00                ; ELSE: do the following instructions
     STS  TCCR1B, R20              ; stop Timer1
     LDI  R20, (1<<TOV1)
     OUT  TIFR1, R20               ; clears TOV1 flag
     RET
;-----------------------------------------------------------------------------
