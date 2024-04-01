
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
; Escribir un programa que sume dos números de 16 bits A (20H 21H) y 
; B (22H y 23H) y al resultado colocarlo en A.
    
    
   ORG 0x000
   
    A1     EQU  0x20
    A2     EQU  0x21
    B1     EQU  0x22
    B2     EQU  0x23
    CARRY  EQU  0x24
    
    GOTO Main
     
Main
    MOVLW A1    ;W TOMA EL VALOR DE A1
    ADDWF B1,0  ;W TOMA EL VALOR DE A1 + B1
    MOVWF A1    ;EL VALOR DE W SE GUARDA EN A1
    
    BTFSC STATUS,0 ;VERIFICO SI HUBO ACARREO
    BSF CARRY,0
  
    MOVLW A2    ;W TOMA EL VALOR DE A2
    ADDWF B2,0  ;W TOMA EL VALOR DE A2 + B2
    MOVWF A2    ;EL VALOR DE 2 SE GUARDA EN A2
   
  
    END
    
   
   


