
    list            p=16f887	  ; list directive to define processor
    #include	    <p16f887.inc> ; processor specific variable definitions


; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

    __CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF
    & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF
    & _INTRC_OSC_NOCLKOUT
    __CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

	
;**********************************************************************
; Escribir un programa que compare dos números A y B.
;- Si son iguales, el resultado debe ser 0.
;- Si A > B, el resultado debe ser la diferencia A ? B.
;- Y si A < B el resultado debe ser la suma A + B.
;Considere A en posición 30D, B en 31D y R en 32D.
    
    ORG 0x000
    
    A         EQU  0x20
    B         EQU  0x21
    R         EQU  0x22
    
    GOTO Main

Main
    MOVLW A        ;W TOMA EL VALOR DE A
    SUBWF B,0      ;W TOMA EL VALOR DE A - B
    
    BTFSC STATUS,2 ;Z ES EL BIT DESINGADO PARA AVISAR SI W ES 0 (Z = 1)
    CLRF R         ;R es igual a 0
    BTFSC STATUS,0 ;Si C es 0, saltea instruccion
    GOTO Suma
    GOTO Resta
    
Suma
    MOVLW A
    ADDWF B,0
    MOVWF R

Resta
    MOVLW A
    SUBWF B,0
    MOVWF R
    
    END
    
    
    
   
   
   
    
    


