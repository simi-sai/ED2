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
;    Filename:	    Interruptor LED.asm                               *
;    Date:          10 / 4 / 2023                                     *
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


	list		p=16f887	; list directive to define processor
	#include	<p16f887.inc>	; processor specific variable definitions


; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF
	& _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF
	& _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

	
;**********************************************************************
	
	ORG     0x000
	GOTO INICIO
	
INICIO
	BSF STATUS,5
	BSF STATUS,6
	CLRF ANSEL
	BCF STATUS,6
	BSF TRISA,1
	BCF TRISD,3
	BCF STATUS,5
	
BUCLE
	BTFSS PORTA,1
	GOTO APAGADO
	GOTO ENCENDIDO

ENCENDIDO
	BSF PORTD,3
	GOTO BUCLE

APAGADO
	BCF PORTD,3
	GOTO BUCLE

END
 


