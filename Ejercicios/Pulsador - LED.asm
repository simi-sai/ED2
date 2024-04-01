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
;    Date:          12/4/2023                                         *
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


    list            p=16f887	  ; list directive to define processor
    #include	    "p16f887.inc" ; processor specific variable definitions

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word

 __CONFIG _CONFIG1, _FOSC_EXTRC_CLKOUT & _WDTE_ON & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
	
;**********************************************************************

   ORG 0x000
   GOTO Configuracion
   
Configuracion
   BSF STATUS,6
   BSF STATUS,5    ; elijo Banco de Registros 3 (11)
   
   CLRF ANSEL      ; seteo las entradas a Digitales (0)
   CLRF ANSELH
   
   BCF STATUS,6    ; elijo Banco de Registros 1 (01)
   
   BSF TRISB,0     ; elijo como entrada (IMPUT)[1] a RA3
   BCF TRISD,0     ; elijo como salida (OUTPUT)[0] a RD1
  
Inicio
   BTFSS PORTB,0   ; Salteo si RA3 esta en "1"
   GOTO Apagado    ; Voy a apagado si RA3 esta en "0"
   GOTO Encendido
   
Encendido
   BSF PORTD,0     ; "enciendo" la salida del LED
   GOTO Inicio
   
Apagado
   BCF PORTD,0     ; "apago" la salida del LED
   GOTO Inicio
  
   END
   




