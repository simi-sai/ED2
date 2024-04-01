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
    
    #include	    <P16f887.inc> ; processor specific variable definitions
    list            p=16f887	  ; list directive to define processor
    
; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

    __CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
    __CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

	
;**********************************************************************

    ORG 0x000
    NOP
    GOTO Inicio
    
    ORG 0x004
    
    BTFSC INTCON,2
    CALL Timer
    BTFSC INTCON,1
    CALL Reseteo
    BTFSC INTCON,0
    CALL Teclado
    RETFIE
    
Configuracion
    
    MOVLW b'00111000'
    MOVWF INTCON
    
    BSF INTCON,7
    
    
Inicio
    GOTO $
    
    
    
Timer
    ;PROGRAMA Timer T0
    
    BCF INTCON,2
    RETURN
    
Reseteo
    ;PROGRAMA RESET
    
    BCF INTCON,1
    RETURN
    
Teclado
    ;PROGRAMA TECLADO
    
    BCF INTCON,0
    RETURN
    
    
    END
    
    
    

