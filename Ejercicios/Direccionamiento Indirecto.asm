

    list p = 16f887
    #include <p16f887.inc>
    
    __CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF
    & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF
    & _INTRC_OSC_NOCLKOUT
    __CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

    
    ORG 0x000
    Tabla1  EQU  0x20
    Tabla2  EQU  0x30
    Valor   EQU  0x40
   
   MOVLW Tabla1
   MOVWF FSR     ;FSR tiene la direccion 0x20

TESTEO
   MOVF INDF,0  ;W ahora tiene el valor de INDF (el valor en la direccion FSR)
   SUBWF Valor
   
   BTFSS STATUS,2
   GOTO LOOP
   GOTO Final
   
LOOP
   INCF FSR
   GOTO TESTEO
   
Final
   END
   
   
  

