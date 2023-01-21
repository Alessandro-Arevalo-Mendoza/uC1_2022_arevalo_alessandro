;--------------------------------------------------------------
; @file:		display_7SEG.s
; @brief:		Esta instruccion permite mostrar valores alfanuméricos (0-9 y A-F) en un display de 7 segmentos
;                       ánodo común,conectados al puerto D[7:0] y se mostrará cada valor con un retardo de 1 segundo entre transición.
;                       La siguiente condicion para que salga tanto numeros o letras sera la siguietne: la primera condición es que
;                       si el pulsador de la placa no está presionado entonces se muestran los valores numéricos del l 0 al 9.    
;                       y como segunda condición tiene que cumplirse que al mantener presionado el pulsador de la placa, se muestran
;                       los valores de A hasta F.   
; @date:		15/01/2023
; @author:		Arevalo Mendoza Alessandro Miguel
; @Version and program:	MPLAB X IDE v6.00
;------------------------------------------------------------------
    
PROCESSOR 18F57Q84
    
#include "Config.inc" /*config statements should precede project file includes.*/
#include "1s.inc"
#include <xc.inc>

PSECT resetVect,class=CODE, reloc=2
resetVect:
    goto Main
PSECT CODE
Main:
    CALL    Config_OSC
    CALL    Config_Port
    NOP
    
Cambio:  
    BTFSC   PORTA,3,0	;PORTA<3> = 0? - Button press? no -> salta a la otra instruccion / si -> siguiente instruccion
    goto    Led_Off	;button no press
Led_On:
    goto    letras	
Led_Off:		;button no press
    goto    Numeros	    			
	
    Numeros:
  
	BANKSEL PORTD
	MOVLW	1000000B	;numero 0
	MOVWF	PORTD,1		; (W) -> PORTD
	Call	Delay_1s
	BTFSS PORTA,3,1		;condicion, sabiendo que button: RA3	
	CALL	Cambio		;button press
	
	MOVLW	1111001B	;numero 1
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSS PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button press
	
	MOVLW	0100100B	;numero 2
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSS PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button press
	
	MOVLW	0110000B	;numero 3
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSS PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button press
	
	MOVLW	0011001B	;numero 4
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSS PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button press
	
	MOVLW	0010010B	;numero 5
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSS PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button press
	
	MOVLW	0000010B	;numero 6
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSS PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button press
	
	MOVLW	1111000B	;numero 7
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSS PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button press
	
	MOVLW	0000000B	;numero 8
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSS PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button press
	
	MOVLW	0010000B	;numero 9
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSS PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button press
    GOTO Numeros
	
    letras:
	BANKSEL PORTD
	MOVLW	0001000B	; letra A
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSC PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button no press
	
	MOVLW	0000000B	; letra B
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSC PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button no press
	
	MOVLW	1000110B	; letra C
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSC PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button no press
	
	MOVLW	1000000B	; letra D
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSC PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button no press
	
	MOVLW	0000110B	; letra E
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSC PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button no press
	
	MOVLW	0001110B	; letra F
	MOVWF	PORTD,1
	Call	Delay_1s
	BTFSC PORTA,3,1		;condicion, sabiendo que button: RA3
	CALL	Cambio		;button no press
	
    GOTO letras
	
Config_OSC:
    ;configuración del Oscilador interno a una frecuencia de 4Mhz
    BANKSEL OSCCON1
    MOVLW 0x60	;seleccionamos el bloque del oscilador interno con un div:1
    MOVWF OSCCON1
    MOVLW 0X02	;seleccionamos a una frecuencia de 4Mhz
    MOVWF OSCFRQ
    RETURN
 
Config_Port:	;PORT-LAT-ANSEL-TRIS LED:RF3,  BUTTON:RA3
    ;Config Button
    BANKSEL PORTA
    CLRF    PORTA,1	;PORTA<7,0> = 0
    CLRF    ANSELA,1	;PORTA DIGITAL
    BSF	    TRISA,3,1	;RA3 COMO ENTRADA
    BSF	    WPUA,3,1	;ACTIVAMOS LA RESISTENCIA PULLUP DEL PIN RA3
    
    ;Config Port D
    BANKSEL PORTD
    CLRF    PORTD,1	;PORTC<7,0>=0
    CLRF    ANSELD,1	;PORTC DIGITAL
    CLRF    TRISD,1	;PORTC COMO SALIDA
    RETURN

END resetVect



