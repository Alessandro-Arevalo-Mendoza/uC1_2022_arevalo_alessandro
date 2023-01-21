;--------------------------------------------------------------
; @file:		Corrimiento_Leds.s
; @brief:		Estas son instrucciones que me permiten hacer corrimientos de leds concectados al puerto C. Consiste que en el número
;                       de corrimientos pares tendrán un retardo de 500ms y en el número de corrimientos impares tendrán un retardo de 
;                       500ms.El corrimiento inicia una vez pulsado el boton de la placa y se detiene cuando se vuelve a presionar de nuevo.
; @date:		15/01/2023
; @author:		Arevalo Mendoza Alessandro Miguel
; @Version and program:	MPLAB X IDE v6.00
;------------------------------------------------------------------
    
PROCESSOR 18F57Q84
    
#include "Config.inc" /*config statements should precede project file includes.*/
#include "retardos_p.inc"
#include <xc.inc>

PSECT resetVect,class=CODE, reloc=2
resetVect:
    goto Main
PSECT CODE
Main:
    CALL    Config_OSC				;llamar configuracion de puertos en libreria
    CALL    Config_Port				;llamar configuracion de puertos en libreria
    NOP


verifica:					; comprobar si el boton està pulsado.
    BANKSEL PORTA				;Pseudo instruccion -> Genera codigo necesario para ubicarme en el banco donde está el registro 
    BTFSC   PORTA,3,1				; està en 0? button press? si-> salta a la otra instruccion / no -> siguiente intruccion
    GOTO    verifica				; instruccion siguiente
    Led_Stop2:   
	CALL    Delay_250ms			
	BTFSS   PORTA,3,1			; està en 1? button no press? no -> siguiente instruccion / si -> salta a la otra instruccion
	GOTO    verifica			; Button no press, verifica de nuevo el estado del pulsador
	  
    Corrimiento_general:
    ;impar -> retardo de 250ms
    Corrimiento_impar:
	BANKSEL PORTE		    ;Pseudo instruccion -> Genera codigo necesario para ubicarme en el banco donde está el registro 
	BSF	PORTE,0,1	    ; bit -> 1 , led impar on
	BANKSEL PORTC		    
	CLRF	PORTC,1		    ;Borra el contenido del registro especificado 'f'.
	BSF	PORTC,0,1	    ;bit -> 1ª led on
	CALL	Delay_250ms,1	   
	BTFSS PORTA,3,1		    ; button press? no -> salta a otra instuccion / si -> siguiente insreuccion, lo detiene.
	CALL	Led_Stop	    ;press -> salta a Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda -> 2ª led on
	CALL Delay_250ms,1	    
	BTFSS PORTA,3,1		    ;condicion
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda -> 3ª led on
 	CALL Delay_250ms,1
	BTFSS PORTA,3,1		    ;condicion
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda -> 4ª led on
	CALL Delay_250ms,1
	BTFSS PORTA,3,1		    ;condicion
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda -> 5ª led on
	CALL Delay_250ms,1
	BTFSS PORTA,3,1		    ;condicion
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda -> 6ª led on
	CALL Delay_250ms,1
	BTFSS PORTA,3,1		    ;condicion
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda -> 7ª led on
	CALL Delay_250ms,1
	BTFSS PORTA,3,1		    ;condicion
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_250ms,1
	BCF	PORTE,0,1	    ;bit -> 0 , led impar off
	BTFSS PORTA,3,1		    ;condicion
	CALL	Led_Stop
    ;corrimiento par tiene un retardo de 500ms
    Corrimiento_par:
	BANKSEL PORTE		    ;Pseudo instruccion
	BSF	PORTE,1,1	    ;bit -> 1 , led par on
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda -> 1ª led on
	CALL Delay_500ms,1	    
	BTFSS PORTA,3,1		    ;condicion
	CALL	Led_Stop	    ;stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda -> 2ª led on
	CALL Delay_500ms,1	    
	BTFSS PORTA,3,1		    ;condicion
	CALL	Led_Stop	    ;stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda -> 3ª led on
	CALL Delay_500ms,1
	BTFSS PORTA,3,1		    ;condicion
	CALL	Led_Stop	    ;stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda -> 4ª led on
	CALL Delay_500ms,1
	BTFSS PORTA,3,1		    ;condicion
	CALL	Led_Stop	    ;stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda -> 5ª led on
	CALL Delay_500ms,1
	BTFSS PORTA,3,1		    ;condicion
	CALL	Led_Stop	    ;stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda -> 6ª led on
	CALL Delay_500ms,1
	BTFSS PORTA,3,1		    ;condicion
	CALL	Led_Stop	    ;stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda -> 7ª led on
	CALL Delay_500ms,1
	BTFSS PORTA,3,1		    ;condicion
	CALL	Led_Stop	    ;stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda -> 8ª led on
	CALL Delay_500ms,1
	BCF PORTE,1,1		     ;bit -> 0 , led par oFF  
	BTFSS PORTA,3,1		     ;condicion
	CALL	Led_Stop	     ;stop 
	GOTO Corrimiento_impar
   
Led_Stop:   
    CALL    Delay_1s				; Salta si es 0
    BTFSC   PORTA,3,1				; està en 1? button no press? no -> salta instruccion / si -> siguiente intruccion
    GOTO    verifica2				; salta si es 1
verifica2:
    BANKSEL PORTA
    BTFSC   PORTA,3,1				; està en 0? button press? si-> salta instruccion / no -> siguiente intruccion
    GOTO    verifica2				; instruccion siguiente	 
    RETURN    
	
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
    ;Config Port E
    BANKSEL PORTE
    CLRF    PORTE,1	;PORTE<7,0> = 0
    CLRF    ANSELE,1	;PORTE DIGITAL
    BCF	    TRISE,0,1	;PORTE<0> COMO SALIDA
    BCF	    TRISE,1,1	;PORTE<1> COMO SALIDA
    ;Config Port C
    BANKSEL PORTC
    CLRF    PORTC,1	;PORTC<7,0>=0
    CLRF    ANSELC,1	;PORTC DIGITAL
    CLRF    TRISC,1	;PORTC COMO SALIDA
    RETURN

END resetVect


