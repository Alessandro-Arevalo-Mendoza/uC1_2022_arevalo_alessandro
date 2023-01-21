;--------------------------------------------------------------
; @file:		retardos.inc
; @brief:		Esta es una librería de retardos las cuales el valor de la frecuencia del oscilador es de 4 MHZ
;			por lo tanto, un TCY = 4/Fosc = 4 / 4 * 10^6 = 1 * 10^-6 = 1 us			
; @date:		09/01/2023
; @author:		Alessandro Miguel Arevalo Mendoza
; @Version and program:	MPLAB X IDE v6.00
;------------------------------------------------------------------
PSECT udata_acs
contador1: DS 1	    ;reserva 1 byte en access ram
contador2: DS 1	    ;reserva 1 byte en access ram
    
PSECT code
 
;retardo1 = (6+4k)us
Delay_10us:				    ;2tcy
    MOVLW 1				    ;1tcy
    MOVWF contador1,0			    ;1tcy
Delay_loop10us:		    
    Nop				            ;k tcy
    DECFSZ contador1,1,0		    ;(k-1) +3 tcy   
    GOTO   Delay_loop10us		    ;(k-1)*2tcy	    
    RETURN				    ;2tcy
    
;retardo2 = (3k+7)us
Delay_25us:				    ;2tcy
    MOVLW 6				    ;1tcy
    MOVWF contador1,0			    ;1tcy
    NOP					    ;1tcy
Delay_loop25us:
    DECFSZ contador1,1,0		    ;(k-1) +3 tcy =k+2
    GOTO   Delay_loop25us		    ;(k-1)*2tcy	  =2k-2
    RETURN				    ;2tcy
    
;retardo3 = (6+4k)us
Delay_50us:				    ;2tcy
    MOVLW 11				    ;1tcy
    MOVWF contador1,0			    ;1tcy
Delay_loop50us:
    Nop					    ;k tcy
    DECFSZ contador1,1,0		    ;(k-1) +3 tcy   =2k-2
    GOTO   Delay_loop50us		    ;(k-1)*2tcy	    =2k-2
    RETURN				    ;2tcy
    
;retardo4 = (3k+7)us
Delay_100us:				    ;2tcy
    MOVLW 31				    ;1tcy
    MOVWF contador1,0			    ;1tcy
    NOP					    ;1tcy
Delay_loop100us:
    DECFSZ contador1,1,0		    ;(k-1) +3 tcy =k+2
    GOTO   Delay_loop100us		    ;(k-1)*2tcy	  =2k-2
    RETURN				    ;2tcy
    
;retardo5 = (3k+8)us
Delay_200us:				    ;2tcy
    MOVLW 64				    ;1tcy
    MOVWF contador1,0			    ;1tcy
    NOP					    ;1tcy
    NOP					    ;1tcy
Delay_loop200us:	
    DECFSZ contador1,1,0		    ;(k-1) +3 tcy =k+2
    GOTO   Delay_loop200us		    ;(k-1)*2tcy	  =2k-2
    RETURN				    ;2tcy
    
;retardo6 = (3k+7)us
Delay_250us:				    ;2tcy
    MOVLW 81				    ;1tcy
    MOVWF contador1,0			    ;1tcy
    NOP					    ;1tcy
Delay_loop250us:
    DECFSZ contador1,1,0		    ;(k-1) +3 tcy =k+2
    GOTO   Delay_loop250us		    ;(k-1)*2tcy	  =2k-2
    RETURN				    ;2tcy
    
;retardo 7 = (3k+8)us
Delay_500us:				    ;2tcy
    MOVLW 164				    ;1tcy
    MOVWF contador1,0			    ;1tcy
    NOP					    ;1tcy
    NOP					    ;1tcy
Delay_loop500us:
    DECFSZ contador1,1,0		    ;(k-1) +3 tcy =k+2
    GOTO   Delay_loop500us		    ;(k-1)*2tcy	  =2k-2
    RETURN				    ;2tcy
    
;retardo 8 = 1 ms
Delay_1ms:				    ;2tcy
    MOVLW 1				    ;1tcy
    MOVWF contador2,0			    ;1tcy
EXT_Loop_1ms:			    
    MOVLW   249				    ;k Tcy
    MOVWF   contador1,0			    ;k tcy
INT_LOOP:			    
    Nop					    ;249k TCY
    DECFSZ  contador1,1,0		    ;251k TCY 
    Goto    INT_LOOP			    ;494k TCY
    DECFSZ  contador2,1,0		    ;(k-1)+3tcy
    GOTO    EXT_Loop_1ms		    ;(k-1)*2tcy
    RETURN			            ;2 TCY
    
;retardo9 = 5 ms
Delay_5ms:				    ;2tcy
    MOVLW 5				    ;1tcy
    MOVWF contador2,0			    ;1tcy
EXT_Loop_1ms_1:			     
    MOVLW   249				    ;k Tcy
    MOVWF   contador1,0			    ;k tcy
INT_LOOP1:			    
    Nop					    ;249k TCY
    DECFSZ  contador1,1,0		    ;251k TCY 
    Goto    INT_LOOP1			    ;494k TCY
    DECFSZ  contador2,1,0		    ;(k-1)+3tcy
    GOTO    EXT_Loop_1ms_1		    ;(k-1)*2tcy
    RETURN			            ;2 TCY
    
;retardo10 = 10 ms
Delay_10ms:				    ;2tcy
    MOVLW 10				    ;1tcy
    MOVWF contador2,0			    ;1tcy
EXT_Loop_1ms_2:			     
    MOVLW   249				    ;k Tcy
    MOVWF   contador1,0			    ;k tcy
INT_LOOP2:			    
    Nop					    ;249k TCY
    DECFSZ  contador1,1,0		    ;251k TCY 
    Goto    INT_LOOP2			    ;494k TCY
    DECFSZ  contador2,1,0		    ;(k-1)+3tcy
    GOTO    EXT_Loop_1ms_2		    ;(k-1)*2tcy
    RETURN			            ;2 TCY
    
;retardo11 = 25 ms
Delay_25ms:				    ;2tcy
    MOVLW 25				    ;1tcy
    MOVWF contador2,0			    ;1tcy
EXT_Loop_1ms_3:			    
    MOVLW   249				    ;k Tcy
    MOVWF   contador1,0			    ;k tcy
INT_LOOP3:			    
    Nop					    ;249k TCY
    DECFSZ  contador1,1,0		    ;251k TCY 
    Goto    INT_LOOP3			    ;494k TCY
    DECFSZ  contador2,1,0		    ;(k-1)+3tcy
    GOTO    EXT_Loop_1ms_3		    ;(k-1)*2tcy
    RETURN			            ;2 TCY
    
;retardo12 = 50 ms
Delay_50ms:				    ;2tcy
    MOVLW 50				    ;1tcy
    MOVWF contador2,0			    ;1tcy
EXT_Loop_1ms_4:			    
    MOVLW   249				    ;k Tcy
    MOVWF   contador1,0			    ;k tcy
INT_LOOP4:			    
    Nop					    ;249k TCY
    DECFSZ  contador1,1,0		    ;251k TCY 
    Goto    INT_LOOP4			    ;494k TCY
    DECFSZ  contador2,1,0		    ;(k-1)+3tcy
    GOTO    EXT_Loop_1ms_4		    ;(k-1)*2tcy
    RETURN			            ;2 TCY
    
;retardo13= 100 ms
Delay_100ms:				    ;2tcy
    MOVLW 100				    ;1tcy
    MOVWF contador2,0			    ;1tcy
EXT_Loop_1ms_5:			     
    MOVLW   249				    ;1 Tcy
    MOVWF   contador1,0			    ;1 tcy
INT_LOOP5:			    
    Nop					    ;249k TCY
    DECFSZ  contador1,1,0		    ;251k TCY 
    Goto    INT_LOOP5			    ;494k TCY
    DECFSZ  contador2,1,0		    ;(k-1)+3tcy
    GOTO    EXT_Loop_1ms_5		    ;(k-1)*tcy
    RETURN			            ;2 TCY
    
;retardo14 = 200 ms
Delay_200ms:				    ;2tcy
    MOVLW 200				    ;1tcy
    MOVWF contador2,0			    ;1tcy
EXT_Loop_1ms_6:			     
    MOVLW   249				    ;k Tcy
    MOVWF   contador1,0			    ;k tcy
INT_LOOP6:			    
    Nop					    ;249k TCY
    DECFSZ  contador1,1,0		    ;251k TCY 
    Goto    INT_LOOP6			    ;494k TCY
    DECFSZ  contador2,1,0		    ;(k-1)+3tcy
    GOTO    EXT_Loop_1ms_6		    ;(k-1)*2tcy
    RETURN			            ;2 TCY
    
;retardo15 = 250 ms
Delay_250ms:				    ;2tcy
    MOVLW 250				    ;1tcy
    MOVWF contador2,0			    ;1tcy
EXT_Loop_1ms_7:			     
    MOVLW   249				    ;k Tcy
    MOVWF   contador1,0			    ;k tcy
INT_LOOP7:			    
    Nop					    ;249k TCY
    DECFSZ  contador1,1,0		    ;251k TCY 
    Goto    INT_LOOP7			    ;496k TCY
    DECFSZ  contador2,1,0		    ;(k-1)+3tcy
    GOTO    EXT_Loop_1ms_7		    ;(k-1)*2tcy
    RETURN			            ;2 TCY