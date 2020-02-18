;Timer 1 500 ms delay interrupt service routine   
    
; TODO INSERT CONFIG HERE
  #include "p16f887.inc"
; CONFIG1
; __config 0x20F4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
;*******************************************************************************
; Reset Vector
;*******************************************************************************

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program
    
; TODO INSERT ISR HERE   
    INT_VECT  CODE   0x0004	    ; interrupt vector
    BTFSS PIR1,TMR1IF	            ; Check for Timer1 Flag
    RETFIE			    ;If the Flag is not set return to program 
    GOTO T1_ISR
;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************
MAIN_PROG CODE                      ; let linker place main program
    
START
 ;Switching back to Bank1
 ERRORLEVEL -302    ;Remove "not in bank 0" message
 BSF   STATUS,RP0   ;Moving to Bank 1 for the Initilisation of PORTA,PORTB,PORTC
 MOVLW 0x60
 MOVWF OSCCON	    ;Setting INTRENAL Oscillator to 4MHz
 CLRF  TRISB        ;Setting PORTB as Output
 CLRF  TRISC	    ;Setting PORTC as Output
;Switching back to Bank0
 BCF   STATUS,RP0  ; 
 CLRF  PORTB	   ;Clearing PORTB 
 CLRF  PORTC	   ;Clearing PORTC 
 BSF   INTCON,GIE
 BSF   INTCON,PEIE
 BSF   PIR1,TMR1IF
 MOVLW 0x30
 MOVWF T1CON
 MOVLW 0x0B
 MOVWF TMR1H
 MOVLW 0xDC
 MOVWF TMR1L
 ;Switching back to Bank1
 BSF   STATUS,RP0  ;Moving to Bank 1 for the Initilisation of PORTA,PORTB,PORTC
 BSF   PIE1,TMR1IE
 ;Switching back to Bank0
 BCF   STATUS,RP1  ;Moving to Bank 0 for the Initilisation of PORTA,PORTB,PORTC
 BCF   STATUS,RP0  ; 
 BSF   T1CON,TMR1ON
 AGAIN
    MOVLW 0xFF
    MOVWF PORTC
    GOTO  AGAIN
    
 T1_ISR  
    ORG 60H
    BCF   STATUS,RP0  ;Ensure the bank 0 configuration
    MOVLW 0x0B
    MOVWF TMR1H
    MOVLW 0xDC
    MOVWF TMR1L
    BCF   PIR1,TMR1IF
    RETFIE 
END