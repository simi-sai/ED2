
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

   ORG 0x000
   
   A         EQU  0x21
   B         EQU  0x22
   C         EQU  0x23
   Resultado EQU  0x24
  
   GOTO Main
   
Main
   MOVLW A         ; AHORA W VALE A
   ADDWF B,0       ; AHORA W VALE A + B Y EL RESULTADO SE GUARDA EN W
   SUBWF C,0       ; AHORA W VALE (A + B) - C Y EL RESULTADO SE GUARDA EN W
   MOVWF Resultado ; AHORA Resultado vale W que vale (A + B) - C
   
   END
       
   
   




