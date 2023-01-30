;FILE:		   Parcial2_Ejercicio2 
	      
;DESCRIPCION:	   El contenido de este proyecto presenta instrucciones que se basan 3 interrupciones, por lo 
		   ;cual, en base a ello, se ha utilizado instrucciones a acorde a lo que se está pidiendo, por ende, 
		   ;el propósito del proyecto recalca interrupciones de inicio de secuencia, detenimiento de 
		   ;secuencia y de reinicio de secuencia, todo con respecto al programa principal que es el toggle. 
		   ;Se ha trabajado con pulsadores las cuales me dan la interrupción.
		   
		   ;RA3 me inicia la secuencia y cuando se termina me devuelve al toggle  
		   ;RB4 me detiene la secuencia y una vez detenido me lleva al toggle
		   ;RF2 me reinicia la secuencia tanto la de los leds como la de los leds detenidos y me lleva al toggle
		   
		   ;Una vez configuradas se ha comenzado a utilizar las instrucciones explicadas por el docente en las respectivas clases.
		 		   
;DATE:		    30/01/2023
	      
;AUTOR:		    Alessandro Arevalo	

    
PROCESSOR 18F57Q84
#include "Bit_Config.inc"   /*config statements should precede project file includes.*/
#include <xc.inc>
    
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT ISRVectLowPriority,class=CODE,reloc=2
ISRVectLowPriority:
    BTFSS   PIR1,0,0			; ¿Se ha producido la INT0? no->next intrucc. / si->jump instrucc.
    GOTO    Exit0	
Leds_on:
    BCF	    PIR1,0,0			; limpiamos el flag de INT0 para no tener reingresos
    GOTO    secuenciade5		; Inicia secuencia de los leds
Exit0:
    RETFIE

PSECT ISRVectHighPriority,class=CODE,reloc=2
ISRVectHighPriority:
    BTFSS   PIR6,0,0			; ¿Se ha producido la INT1?
    GOTO    Interrupcion3		; No
Leds:					; Si
    BCF	    PIR6,0,0			; limpiamos el flag de INT1 para no tener reingresos
    GOTO    toggle			; Se va el proyecto principal
Exit:
    RETFIE

PSECT udata_acs				
contador1:  DS 1	    
contador2:  DS 1
contador3:  DS 1
offset:	    DS 1
offset1:    DS 1
counter:    DS 1
counter1:   DS 1 
    
PSECT CODE    
Main:
    CALL    Config_OSC,1
    CALL    Config_Port,1
    CALL    Config_PPS,1
    CALL    Config_INT0_INT1,1
    GOTO    toggle
      
toggle:
   BTFSC   PIR10,0,0			  ; ¿Se ha producido la INT0?
   GOTO	   ISRVectHighPriority		  
   BTG	   LATF,3,0
   CALL    Delay_500ms,1
   goto	   toggle

Loop:
    BSF	    LATF,3,0			   ;toggle off
    BANKSEL PCLATU			   
    MOVLW   low highword(Table)		   
    MOVWF   PCLATU,1			   ;Escribir el byte superior en PCLATU
    MOVLW   high(Table)
    MOVWF   PCLATH,1			   ;Escribir el byte alto en PCLATH
    RLNCF   offset,0,0			   ;Definimos el valor del offset 
    CALL    Table
    MOVWF   LATC,0
    CALL    Delay_250ms,1
    DECFSZ  counter,1,0			   ; Decrementa hasta llegar a 0 en el contador (10 secuencias)
    GOTO    Seq_10			   ; ? 0 -> subrutina Next_Seq 
    
 Comprobacion:				   ; = 0
    DECFSZ  counter1,1,0		   ; Decrementa hasta llegar a 0 en el contador 1 (5 secuencias)
    GOTO    Secuenciade10		   ; ? 0 -> Reinicia secuencia de 10
    Goto    Exit0			   ; = 0 -> Finaliza secuencia
    
Seq_10:			    
    INCF    offset,1,0		    
    GOTO    Loop		    
    
secuenciade5:
    MOVLW   0x05		    ; 5 -> W (Caragamos W con el valor de 5)
    MOVWF   counter1,0	      	    ; (w)-> f : carga del contador con el numero de offsets
    MOVLW   0x00		    ; 0 -> W (Caragamos W con el valor de 0)
    MOVWF   offset,0		    ; definimos el valor del offset inicial
    
Secuenciade10:
    MOVLW   0x0A		    ; 10 -> W (Caragamos W con el valor de 10)
    MOVWF   counter,0		    ; (w)-> f : carga del contador con el numero de offsets
    MOVLW   0x00		    ; 0 -> W (Caragamos W con el valor de 0)
    MOVWF   offset,0		    ; definimos el valor del offset inicial
    GOTO    Loop		    ; Se va a inicar la secuencia de 10
    
Table:
    ADDWF   PCL,1,0
    RETLW   10000001B	; offset: 0
    RETLW   01000010B	; offset: 1
    RETLW   00100100B	; offset: 2
    RETLW   00011000B	; offset: 3
    RETLW   00000000B	; offset: 4 -> se apagan todos
    RETLW   00011000B	; offset: 5
    RETLW   00100100B	; offset: 6
    RETLW   01000010B	; offset: 7
    RETLW   10000001B	; offset: 8
    RETLW   00000000B	; offset: 9
    
    
Interrupcion3:
    BTFSS   PIR10,0,0		    ; ¿Se ha producido la INT2?
    GOTO    Exit
    BCF	    PIR10,0,0		    ; limpiamos el flag de INT2 para no tener reingresos
    GOTO    exit    
       
Config_OSC:
    ;Configuracion del Oscilador Interno a una frecuencia de 4MHz
    BANKSEL OSCCON1
    MOVLW   0x60    ;seleccionamos el bloque del osc interno(HFINTOSC) con DIV=1
    MOVWF   OSCCON1,1 
    MOVLW   0x02    ;seleccionamos una frecuencia de Clock = 4MHz
    MOVWF   OSCFRQ,1
    RETURN
   
Config_Port:	
    ;Config Led
    BANKSEL PORTF
    CLRF    PORTF,1	
    BSF	    LATF,3,1
    CLRF    ANSELF,1	
    BCF	    TRISF,3,1
    
    ;Config User Button
    BANKSEL PORTA
    CLRF    PORTA,1	
    CLRF    ANSELA,1	
    BSF	    TRISA,3,1	
    BSF	    WPUA,3,1
    
    ;Config Ext Button
    BANKSEL PORTB
    CLRF    PORTB,1	
    CLRF    ANSELB,1	
    BSF	    TRISB,4,1	
    BSF	    WPUB,4,1
    
    ;Config Ext Button2
    BANKSEL PORTF
    CLRF    PORTF,1	
    CLRF    ANSELF,1	
    BSF	    TRISF,2,1	
    BSF	    WPUB,2,1
    
    ;Config PORTC
    BANKSEL PORTC
    CLRF    PORTC,1	
    CLRF    LATC,1	
    CLRF    ANSELC,1	
    CLRF    TRISC,1
    RETURN
    
Config_PPS:
    ;Config INT0
    BANKSEL INT0PPS
    MOVLW   0x03
    MOVWF   INT0PPS,1	; INT0 --> RA3
    
    ;Config INT1
    BANKSEL INT1PPS
    MOVLW   0x0C
    MOVWF   INT1PPS,1	; INT1 --> RB4
    
    ;Config INT2
    BANKSEL INT2PPS
    MOVLW   0x2A
    MOVWF   INT2PPS,1
    
    RETURN
    
;   Secuencia para configurar interrupcion:
;    1. Definir prioridades
;    2. Configurar interrupcion
;    3. Limpiar el flag
;    4. Habilitar la interrupcion
;    5. Habilitar las interrupciones globales
Config_INT0_INT1:
    ;Configuracion de prioridades
    BSF	INTCON0,5,0 ; INTCON0<IPEN> = 1 -- Habilitamos las prioridades
    BANKSEL IPR1
    BCF	IPR1,0,1    ; IPR1<INT0IP> = 0 --  INT0 de baja prioridad
    BSF	IPR6,0,1    ; IPR6<INT1IP> = 0 --  INT1 de alta prioridad
    BSF	IPR10,0,1   ; IPR1<INT2IP> = 1 -- INT2 de alta prioridad
    
    ;Config INT0
    BCF	INTCON0,0,0 ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext0
    
    ;Config INT1
    BCF	INTCON0,1,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR6,0,0    ; PIR6<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0    ; PIE6<INT0IE> = 1 -- habilitamos la interrupcion ext1
    
    ;Config INT2
    BCF	INTCON0,2,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR10,0,0    ; PIR6<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE10,0,0    ; PIE6<INT0IE> = 1 -- habilitamos la interrupcion ext1
    
    ;Habilitacion de interrupciones
    BSF	INTCON0,7,0 ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global y de alta prioridad
    BSF	INTCON0,6,0 ; INTCON0<GIEL> = 1 -- habilitamos las interrupciones de baja prioridad
    RETURN
        
Delay_250ms:				  ; 2Tcy -- Call
    MOVLW   250				  ; 1Tcy -- k2
    MOVWF   contador2,0			  ; 1Tcy
; T = (6 + 4k)us       1Tcy = 1us
Ext_Loop:		    
    MOVLW   249				  ; 1Tcy -- k1
    MOVWF   contador1,0			  ; 1Tcy
Int_Loop:	
    NOP					  ; k1*Tcy
    DECFSZ  contador1,1,0		  ; (k1-1)+ 3Tcy
    GOTO    Int_Loop			  ; (k1-1)*2Tcy
    DECFSZ  contador2,1,0
    GOTO    Ext_Loop
    RETURN				  ; 2Tcy
;500ms
Delay_500ms:
    MOVLW 2
    MOVWF contador3,0
    Loop_250ms:				  ;2tcy
    MOVLW 250				  ;1tcy
    MOVWF contador2,0			  ;1tcy
    Loop_1ms8:			     
    MOVLW   249				  ;k Tcy
    MOVWF   contador1,0			  ;k tcy
    INT_LOOP8:			    
    Nop					  ;249k TCY
    DECFSZ  contador1,1,0		  ;251k TCY 
    Goto    INT_LOOP8			  ;496k TCY
    DECFSZ  contador2,1,0		  ;(k-1)+3tcy
    GOTO    Loop_1ms8			  ;(k-1)*2tcy
    DECFSZ  contador3,1,0
    GOTO Loop_250ms
    RETURN  
    
exit:     
End resetVect