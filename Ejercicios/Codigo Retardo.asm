;**********************************************************************
;   This file is a basic code template for assembly code generation   *
;   on the PIC16F887. This file contains the basic code               *
;   building blocks to build upon.                                    *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).                     *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:	    LED                                               *
;    Date:          28/04/23                                        *
;    File Version:  1.0                                               *
;                                                                     *
;    Author:        Grupo 11                                          *
;    Company:       FCEFyN - UNC                                      *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files Required: P16F887.INC                                      *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;**********************************************************************

    #include "PIC16F887.INC"
    list     P=16F887
    
; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

    __CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
    __CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

	
;**********************************************************************

    ORG 0x000
    BUFF1  EQU  0x20     ; Buffer de 255
    BUFF2  EQU  0x21     ; Buffer de 217
    BUFF3  EQU  0x22     ; Buffer de 3
    
Configuracion
    BANKSEL ANSEL
    CLRF ANSEL
    CLRF ANSELH          ; Entradas y Salidas Digitales
    
    BANKSEL TRISD
    CLRF TRISD           ; Salida RD0 - RD7 - 7seg LED
    BCF TRISB,2          ; Salida RB2 - LED indicador de Retardo
    BSF TRISA,3          ; Entrada RA3 - Pulsador de Inicio
    BSF TRISA,4          ; Entrada RA4 - Seguro para Apagar el Ciclo
    
    MOVLW   .255       
    MOVWF   BUFF1
    MOVLW   .218
    MOVWF   BUFF2        ; Le asigno 255d a BUFF1 y 218d a BUFF2
    MOVLW   .3
    MOVWF   BUFF3        ; Le asigno 67d a BUFF3
    CLRF    PORTD

Main
    BTFSS PORTA,3        ; Compruebo si apreté el boton o no
    GOTO Main
    MOVLW .0
    
LED
    CALL  Tabla
    MOVWF PORTD
    
    BSF PORTB,2          ; Prendo el LED mientras se ejecuta el Retardo
    CALL  Sec_Retardo
    BCF PORTB,2          ; Apago el LED al no terminar el retardo
    
    INCF  W
    ANDLW b'00001111'
    
    BTFSC PORTA,4
    GOTO LED
    GOTO Main
    
Sec_Retardo                    ; Aproximadamente 1 millon de ciclos
   Retardo
       DECFSZ BUFF3,0          ; 3 veces
       GOTO RetardoAUX         ; 2 x 2 ciclos
       RETURN                  ; 2

   RetardoAUX
       DECFSZ BUFF1,0          ; 255 ciclos
       GOTO RetardoAUX2        ; 2 x 254 ciclos
       GOTO Retardo            ; 2 ciclos
   
   RetardoAUX2
       DECFSZ BUFF2,0          ; 217 ciclos
       GOTO RetardoAUX2        ; 2 x 216 ciclos
       GOTO RetardoAUX         ; 2
       
Tabla
    ADDWF PCL,1
    RETLW b'00111111'    ;0
    RETLW b'00000011'    ;1
    RETLW b'01011011'    ;2
    RETLW b'00001111'    ;3
    RETLW b'01100110'    ;4
    RETLW b'01101101'    ;5
    RETLW b'01111101'    ;6
    RETLW b'00000111'    ;7
    RETLW b'01111111'    ;8
    RETLW b'01100111'    ;9
    RETLW b'01011111'    ;A
    RETLW b'01111100'    ;b
    RETLW b'00111001'    ;C
    RETLW b'01011110'    ;d
    RETLW b'01111001'    ;E
    RETLW b'01110001'    ;F
    
   END


