        list		p=16f887	
	#include	<p16f887.inc>	

	__CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_ON & _FCMEN_ON & _LVP_OFF
        __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF


;**********************************************************************
	
	HORA        EQU   0x20
        MIN         EQU   0x21
        SEG         EQU   0x22
	
        Contador    EQU   0x23
  
        Decenas     EQU   0x24
        Unidades    EQU   0x25
        TiempoA     EQU   0x26
   
        Elementos   EQU   0x27
  
        Flag        EQU   0x28
       
        AUX         EQU   0x29
	AUX2        EQU   0x30
       
        B1          EQU   0x31
	B2          EQU   0x32
	B3          EQU   0x33
	B4          EQU   0x36
	 
	W_TEMP      EQU   0x34
	STATUS_TEMP EQU   0x35
    
;**********************************************************************  
    
        ORG 0x000
	GOTO Configuracion
	
	ORG 0x004
	GOTO Interrupcion

;**********************************************************************
	
Configuracion 
	; -- Puertos --
	BANKSEL ANSEL
	CLRF ANSEL
	CLRF ANSELH            ;El resto digital
	BSF ANSEL,0            ;AN0 analogica (ADC)
	
	BANKSEL TRISA
	BSF TRISA,0            ;AN0 entrada
	BCF TRISE,0
	BCF TRISE,1            ;RE0-RE1 salidas (Display)
	BCF TRISC,4
	BCF TRISC,5            ;RC4-RC5 salidas (MOTOR)
	CLRF TRISD             ;Port D salidas (7 SEG)
	MOVLW b'11000001'
	MOVWF TRISB            ;Teclado (excepto RB0)
	MOVWF PORTB            ;Valores iniciales teclado
	BCF PORTB,0
	CLRF PORTC
	
	; -- Inicializacion Interrupciones --
	MOVLW b'01111000'
	MOVWF INTCON           ;PEIE, T0IE, INTE, RBIE
	BSF PIE1,6             ;ADIE
	;La interrupcion por TSerie se activa aparte
	
	; -- Configuracion Adicional --
	MOVLW b'00000111'      ;PS (256) y RPUB
	MOVWF OPTION_REG
	MOVLW b'11000000'
	MOVWF WPUB             ;Pull-Ups (RB7-RB6)
	MOVWF IOCB             ;Interrupcion Puerto B
	
	; -- Conexion Serie --
	CLRF TXSTA             ;SYNC = 0, TXEN = 0
	BSF TXSTA,2            ;BRGH = 1
	MOVLW .25
	MOVWF SPBRG            ;BAUD rate 9600
	CLRF SPBRGH
	BANKSEL BAUDCTL        ;BAUD16 = 0
	BCF BAUDCTL,3          ;(no es necesario pero por las dudas)
	
	BANKSEL RCSTA
	CLRF RCSTA
	BSF RCSTA,7            ;SPEN = 1
	
	; -- Conversor A/D --
	BANKSEL ADCON1
	CLRF ADCON1            ;Vref internos
	BSF ADCON1,7           ;Justificado Derecha
	
	BANKSEL ADCON0
	MOVLW b'01000001'      ;(Fosc/8) + CH0 + ADON
	MOVWF ADCON0
	CLRF PIR1              ;Limpieza Flags Perifericas
	
	; -- Inicializacion Variables --
	MOVLW .11
	MOVWF HORA
	MOVLW .12
	MOVWF MIN
	CLRF SEG
	CLRF Flag
	CLRF Decenas
	CLRF Unidades
	
	MOVLW .10
	MOVWF TiempoA
	MOVWF AUX
	MOVLW .20
	MOVWF Contador
	MOVLW .61
	MOVWF TMR0
	
	; -- Inicializacion FSR --
	BCF STATUS,7
	MOVLW 0xA0
	MOVWF FSR              ;Aca empieza la tabla de horarios
	CLRF Elementos         ;"La tabla esta vacia"
	
	; -- Habilitacion Final --
	BSF INTCON,7           ;GIE
	

;**********************************************************************
	
Main
	;Primer Display
	CALL Retardo
	BCF PORTE,1
	BSF PORTE,0        
	MOVF Decenas,0
	CALL TablaDecimal
	MOVWF PORTD
	
	NOP
	NOP
	
	CALL Retardo
	;Segundo Display
	BCF PORTE,0
	BSF PORTE,1
	MOVF Unidades,0
	CALL TablaDecimal
	MOVWF PORTD
	
	GOTO Main
	
	
;**********************************************************************
	
Interrupcion
	;GUARDO CONTEXTO
	MOVWF W_TEMP
	SWAPF STATUS,0
	MOVWF STATUS_TEMP
	
	BTFSC INTCON,2
	GOTO Timer
	BTFSC INTCON,1
	GOTO Pulsador
	BTFSC INTCON,0
	GOTO Teclado
	BTFSC PIR1,6
	GOTO Conversor
	GOTO Transmision

;**********************************************************************
	
TablaDecimal
    ADDWF PCL,1
    RETLW b'00111111'     ;0
    RETLW b'00000110'     ;1
    RETLW b'01011011'     ;2
    RETLW b'01001111'     ;3
    RETLW b'01100110'     ;4
    RETLW b'01101101'     ;5
    RETLW b'01111101'     ;6
    RETLW b'00000111'     ;7
    RETLW b'01111111'     ;8
    RETLW b'01100111'     ;9
 
;**********************************************************************
    
TablaHexadecimal
    ADDWF PCL,1
    RETLW 0x00
    RETLW 0x01
    RETLW 0x02
    RETLW 0x03
    RETLW 0x04
    RETLW 0x05
    RETLW 0x06
    RETLW 0x07
    RETLW 0x08
    RETLW 0x09
    RETLW 0x10
    RETLW 0x11
    RETLW 0x12
    RETLW 0x13
    RETLW 0x14
    RETLW 0x15
    RETLW 0x16
    RETLW 0x17
    RETLW 0x18
    RETLW 0x19
    RETLW 0x20
    RETLW 0x21
    RETLW 0x22
    RETLW 0x23
    RETLW 0x24
    RETLW 0x25
    RETLW 0x26
    RETLW 0x27
    RETLW 0x28
    RETLW 0x29
    RETLW 0x30
    RETLW 0x31
    RETLW 0x32
    RETLW 0x33
    RETLW 0x34
    RETLW 0x35
    RETLW 0x36
    RETLW 0x37
    RETLW 0x38
    RETLW 0x39
    RETLW 0x40
    RETLW 0x41
    RETLW 0x42
    RETLW 0x43
    RETLW 0x44
    RETLW 0x45
    RETLW 0x46
    RETLW 0x47
    RETLW 0x48
    RETLW 0x49
    RETLW 0x50
    RETLW 0x51
    RETLW 0x52
    RETLW 0x53
    RETLW 0x54
    RETLW 0x55
    RETLW 0x56
    RETLW 0x57
    RETLW 0x58
    RETLW 0x59
    RETLW 0x60
    
;**********************************************************************
    
Timer
	DECFSZ Contador,1     ;20 veces 50ms es 1[s]
	GOTO Reseteo
	
	BTFSS Flag,0          ;Prende el ADC cada 1 seg
	BSF ADCON0,1
	
	BTFSC Flag,0
	DECF TiempoA,1     
	
	; -- SUBRUTINA DE DECODIFICACION 7 SEG --
	MOVF TiempoA,0
	CALL TablaHexadecimal
	MOVWF Decenas
	SWAPF Decenas,1
	MOVWF Unidades
	MOVLW b'00001111'
	ANDWF Unidades,1
	ANDWF Decenas,1
	
	MOVF TiempoA,1       ;(Para modificar el valor de Status)
	BTFSC STATUS,2       ;Z
	CALL Cerrar
	
	; -- SUBRUTINA DE TIEMPO --
	MOVLW .20
	MOVWF Contador      ;Reseteo el valor de Contador
	
	INCF SEG,1          ;Incremento 1 segundo
	MOVF SEG,0          ;Verifico si ya pasaron 60 segundos
	SUBLW .60           ;60 seg
	BTFSS STATUS,2      ;Z
	GOTO Reseteo        ;Si no pasaron entonces retorno
	
	CLRF SEG            ;Seteo SEG en 0
	INCF MIN,1          ;Incremento 1 minuto
	MOVF MIN,0          ;Verifico si ya pasaron 60 minutos
	SUBLW .60           ;60 min
	BTFSS STATUS,2      ;Z
	GOTO Reseteo        ;Si no pasaron entonces retorno
	
	CLRF MIN            ;Seteo MIN en 0
	INCF HORA,1         ;Incremento 1 hora
	MOVF HORA,0         ;Verifico si ya pasaron 24 horas
	SUBLW .24           ;24 horas
	BTFSS STATUS,2      ;Z
	GOTO Reseteo        ;Si no pasaron entonces retorno
	CLRF HORA           ;Si pasaron limpio Hora

	GOTO Reseteo        ;Retorno de la Interrupcion
	
;**********************************************************************
	
Teclado
	BSF PORTB,1
	BSF PORTB,2         ;Dejo en 0 la columna 1
	
	BTFSS PORTB,7       ;Verifico si apretó el "1"
	CALL MODO1
	BTFSS PORTB,6       ;Verifico si apretó el "4"
	CALL MODO4
	
	BSF PORTB,3
	BCF PORTB,2         ;Dejo en 0 la columna 2
	
	BTFSS PORTB,7       ;Verifico si apretó el "2"
	CALL MODO2
	BTFSS PORTB,6       ;Verifico si apretó el "5"
	CALL MODO5
	
	BSF PORTB,2
	BCF PORTB,1         ;Dejo en 0 la columna 3
	
	BTFSS PORTB,7       ;Verifico si apreto el "3"
	CALL MODO3
	BTFSS PORTB,6       ;Verifico si apretó el "6"
	CALL MODO6
	
	BCF PORTB,3
	BCF PORTB,2
	BCF PORTB,1         ;Reseteo las columnas
	
	GOTO Limpiar

MODO1   ;Tiempo de Apertura 10 seg
	MOVLW .10
	MOVWF TiempoA
	MOVWF AUX
	RETURN
	
MODO2   ;Tiempo de Apertura 20 seg
	MOVLW .20
	MOVWF TiempoA
	MOVWF AUX
	RETURN
	
MODO3   ;Tiempo de Apertura 30 seg
	MOVLW .30
	MOVWF TiempoA
	MOVWF AUX
	RETURN
	
MODO4   ;Tiempo de Apertura 40 seg
	MOVLW .40
	MOVWF TiempoA
	MOVWF AUX
	RETURN
	
MODO5   ;Tiempo de Apertura 50 seg
	MOVLW .50
	MOVWF TiempoA
	MOVWF AUX
	RETURN

MODO6   ;Tiempo de Apertura 60 seg
	MOVLW .60
	MOVWF TiempoA
	MOVWF AUX
	RETURN
	
;**********************************************************************

Conversor
	BTFSC ADRESH,1      ;si supera los 2.5[V] entonces abre
	CALL Abrir
	
	BANKSEL PIR1
	BCF PIR1,6
	GOTO Limpiar

;**********************************************************************
	
Pulsador
	BANKSEL PIE1
	BSF PIE1,4          ;TXIE
	MOVLW 0xA0
	MOVWF FSR
	BSF TXSTA,5         ;TXEN
	
	MOVF Elementos,0
	MOVWF AUX2          ;Guardo el valor de Cant_Elem
	
	BCF INTCON,1
	GOTO Limpiar
	
;**********************************************************************
	
Transmision
	MOVF INDF,0
	MOVWF TXREG
	INCF FSR,1
	
	DECFSZ Elementos,1
	GOTO Limpiar        ;Si bien la flag se limpia sola hay que ...
                            ;... recuperar el contexto
	
	;SI YA NO HAY ELEMENTOS TERMINO LA TRANSMISION
	BANKSEL PIE1
	BCF PIE1,4
	BCF TXSTA,5         ;TXEN = 0
	
	MOVF AUX2,0
	MOVWF Elementos     ;Reseteo el valor de Elementos
	
	GOTO Limpiar

;**********************************************************************
	
Abrir
	INCF Flag,1
	BCF PORTC,5 
	BSF PORTC,4       ;Polaridad Horario
	
	CALL Bucle0      
	BCF PORTC,4
	
	;Guardo HH/MM/SS en la Tabla
	MOVF HORA,0
	MOVWF INDF
	INCF Elementos,1
	INCF FSR,1
	
	MOVF MIN,0
	MOVWF INDF
	INCF Elementos,1
	INCF FSR,1
	
	MOVF SEG,0
	MOVWF INDF
	INCF Elementos,1
	INCF FSR,1
	
	RETURN

Cerrar
	INCF Flag,1
	BCF PORTC,4
	BSF PORTC,5       ;Polaridad Antihorario
	
	CALL Bucle0
	BCF PORTC,5
	
	MOVF AUX,0
	MOVWF TiempoA     ;Reseteo el valor de TiempoA
	
	RETURN
	
;**********************************************************************
	
Bucle0
	MOVLW .255
	MOVWF B1
	
	CALL Bucle1
	DECFSZ B1,1
	GOTO $-2
	RETURN

Bucle1
	MOVLW .255
	MOVWF B2
	
	CALL Bucle2
	DECFSZ B2,1
	GOTO $-2
        RETURN

Bucle2
	MOVLW .26
	MOVWF B3
	
	DECFSZ B3,1
	GOTO $-1
	RETURN

Retardo
	MOVLW .40
	MOVWF B4
	
	DECFSZ B4,1
	GOTO $-1
	RETURN

;**********************************************************************
	
Reseteo ;Resetea el valor inicial del timer
	BANKSEL TMR0
	MOVLW .61
	MOVWF TMR0
	BCF INTCON,2
	
	GOTO Limpiar
	
Limpiar ;Limpia todas las Banderas y retorna de la interrupcion
	BCF INTCON,0
	
	;RECUPERO CONTEXTO
	SWAPF STATUS_TEMP,0
	MOVWF STATUS
	SWAPF W_TEMP,1
	SWAPF W_TEMP,0
	
	RETFIE
	
;**********************************************************************	
	
    END


