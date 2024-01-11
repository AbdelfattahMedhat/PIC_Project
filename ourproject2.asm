
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;ourproject2.c,46 :: 		void interrupt()
;ourproject2.c,50 :: 		if (TMR0IF_bit == 1)
	BTFSS      TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
	GOTO       L_interrupt0
;ourproject2.c,52 :: 		TMR0=TIMER0_OVF_VALUE(195); // number of tick for ovf interrupt
	MOVLW      60
	MOVWF      TMR0+0
;ourproject2.c,53 :: 		if (++timer0_int_counter == TIMER0_PER_SEC)
	INCF       _timer0_int_counter+0, 1
	MOVF       _timer0_int_counter+0, 0
	XORLW      40
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;ourproject2.c,55 :: 		if(belt_flag == BELT_STOP )
	MOVF       _belt_flag+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
;ourproject2.c,57 :: 		BELT_MOTOR_PIN       = LOGIC_LOW;
	BCF        PORTC+0, 1
;ourproject2.c,58 :: 		ARM_MOTOR_PIN        = LOGIC_HIGH;
	BSF        PORTB+0, 5
;ourproject2.c,59 :: 		LED_BELT_STATE_PIN   = LOGIC_LOW  ;
	BCF        PORTC+0, 0
;ourproject2.c,60 :: 		belt_flag            = BELT_RUN;
	MOVLW      1
	MOVWF      _belt_flag+0
;ourproject2.c,61 :: 		}
	GOTO       L_interrupt3
L_interrupt2:
;ourproject2.c,62 :: 		else if(belt_flag == BELT_RUN )
	MOVF       _belt_flag+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt4
;ourproject2.c,64 :: 		BELT_MOTOR_PIN       = LOGIC_HIGH;
	BSF        PORTC+0, 1
;ourproject2.c,65 :: 		ARM_MOTOR_PIN        = LOGIC_LOW;
	BCF        PORTB+0, 5
;ourproject2.c,66 :: 		LED_BELT_STATE_PIN   = LOGIC_HIGH;
	BSF        PORTC+0, 0
;ourproject2.c,67 :: 		}
L_interrupt4:
L_interrupt3:
;ourproject2.c,69 :: 		LED_INDECATOR_PIN    =LED_INDECATOR_PIN^LOGIC_HIGH;
	MOVLW      2
	XORWF      PORTB+0, 1
;ourproject2.c,70 :: 		timer0_int_counter   = 0;
	CLRF       _timer0_int_counter+0
;ourproject2.c,72 :: 		}
L_interrupt1:
;ourproject2.c,73 :: 		TMR0IF_bit=0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;ourproject2.c,74 :: 		}
L_interrupt0:
;ourproject2.c,76 :: 		if (intf_bit==1 )     // high when set ground on ex_int
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt5
;ourproject2.c,78 :: 		ball_counter++;
	INCF       _ball_counter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _ball_counter+0
;ourproject2.c,79 :: 		digit1=ball_counter % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       _ball_counter+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _digit1+0
;ourproject2.c,80 :: 		digit2=ball_counter/10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       _ball_counter+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      _digit2+0
;ourproject2.c,81 :: 		if(ball_counter >= BALL_MAX_NUM)
	MOVLW      20
	SUBWF      _ball_counter+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_interrupt6
;ourproject2.c,83 :: 		ball_counter = 0;
	CLRF       _ball_counter+0
;ourproject2.c,84 :: 		box++;
	INCF       _box+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _box+0
;ourproject2.c,85 :: 		if(box >= BOX_MAX_NUM)
	MOVLW      3
	SUBWF      _box+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_interrupt7
;ourproject2.c,87 :: 		box = 0;
	CLRF       _box+0
;ourproject2.c,88 :: 		}
L_interrupt7:
;ourproject2.c,89 :: 		}
L_interrupt6:
;ourproject2.c,90 :: 		intf_bit=0;
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;ourproject2.c,91 :: 		}
L_interrupt5:
;ourproject2.c,94 :: 		}
L_end_interrupt:
L__interrupt22:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;ourproject2.c,96 :: 		void main()
;ourproject2.c,100 :: 		trisb             =0b00000101;                              // init REG B with bin (0,2) inputs and remain are output
	MOVLW      5
	MOVWF      TRISB+0
;ourproject2.c,102 :: 		trisd             =0;                              // init REG D all output
	CLRF       TRISD+0
;ourproject2.c,103 :: 		portd             =0;                              // init REG D all Low
	CLRF       PORTD+0
;ourproject2.c,105 :: 		trisc             = 0;                             // init REG D all output & init input pin 5 of IR sensor
	CLRF       TRISC+0
;ourproject2.c,107 :: 		option_reg        = 0b00000111;                    //set timer0 prescaler as 256
	MOVLW      7
	MOVWF      OPTION_REG+0
;ourproject2.c,108 :: 		TMR0              =TIMER0_OVF_VALUE(195);          // timer init with ovf int after 195 tick
	MOVLW      60
	MOVWF      TMR0+0
;ourproject2.c,110 :: 		intcon            = 0b11110000;                    // Enable interrupts
	MOVLW      240
	MOVWF      INTCON+0
;ourproject2.c,112 :: 		while (1)
L_main8:
;ourproject2.c,115 :: 		while(box <= BOX_MAX_NUM)
L_main10:
	MOVF       _box+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_main11
;ourproject2.c,117 :: 		SSD_select_counter++;
	INCF       _SSD_select_counter+0, 1
;ourproject2.c,118 :: 		if (SSD_select_counter      == SSD_DIGIT_BALL_1 )  // done
	MOVF       _SSD_select_counter+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main12
;ourproject2.c,120 :: 		SSD_BOX_PIN    =LOGIC_LOW;
	BCF        PORTB+0, 6
;ourproject2.c,121 :: 		portd          =seg[digit1];
	MOVF       _digit1+0, 0
	ADDLW      _seg+0
	MOVWF      R0+0
	MOVLW      hi_addr(_seg+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      PORTD+0
;ourproject2.c,122 :: 		SSD_DIGIT1_PIN =LOGIC_HIGH;
	BSF        PORTB+0, 3
;ourproject2.c,123 :: 		SSD_DIGIT2_PIN =LOGIC_LOW;
	BCF        PORTB+0, 4
;ourproject2.c,124 :: 		delay_ms(5);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main13:
	DECFSZ     R13+0, 1
	GOTO       L_main13
	DECFSZ     R12+0, 1
	GOTO       L_main13
	NOP
	NOP
;ourproject2.c,125 :: 		}
	GOTO       L_main14
L_main12:
;ourproject2.c,126 :: 		else if(SSD_select_counter  == SSD_DIGIT_BALL_2 ) // done
	MOVF       _SSD_select_counter+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main15
;ourproject2.c,129 :: 		SSD_DIGIT1_PIN =LOGIC_LOW;
	BCF        PORTB+0, 3
;ourproject2.c,130 :: 		portd          =seg[digit2];
	MOVF       _digit2+0, 0
	ADDLW      _seg+0
	MOVWF      R0+0
	MOVLW      hi_addr(_seg+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      PORTD+0
;ourproject2.c,131 :: 		SSD_DIGIT2_PIN =LOGIC_HIGH;
	BSF        PORTB+0, 4
;ourproject2.c,132 :: 		SSD_BOX_PIN    =LOGIC_LOW;
	BCF        PORTB+0, 6
;ourproject2.c,133 :: 		delay_ms(5);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main16:
	DECFSZ     R13+0, 1
	GOTO       L_main16
	DECFSZ     R12+0, 1
	GOTO       L_main16
	NOP
	NOP
;ourproject2.c,134 :: 		}
	GOTO       L_main17
L_main15:
;ourproject2.c,135 :: 		else if(SSD_select_counter  == SSD_DIGIT_BOXS ) // done
	MOVF       _SSD_select_counter+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main18
;ourproject2.c,138 :: 		SSD_DIGIT1_PIN    =LOGIC_LOW;
	BCF        PORTB+0, 3
;ourproject2.c,139 :: 		SSD_DIGIT2_PIN     =LOGIC_LOW;
	BCF        PORTB+0, 4
;ourproject2.c,140 :: 		portd		          =seg[box];
	MOVF       _box+0, 0
	ADDLW      _seg+0
	MOVWF      R0+0
	MOVLW      hi_addr(_seg+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      PORTD+0
;ourproject2.c,141 :: 		SSD_BOX_PIN        =LOGIC_HIGH;
	BSF        PORTB+0, 6
;ourproject2.c,142 :: 		delay_ms(5);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main19:
	DECFSZ     R13+0, 1
	GOTO       L_main19
	DECFSZ     R12+0, 1
	GOTO       L_main19
	NOP
	NOP
;ourproject2.c,143 :: 		SSD_select_counter = SSD_DIGIT_BALL_1;
	CLRF       _SSD_select_counter+0
;ourproject2.c,144 :: 		}
L_main18:
L_main17:
L_main14:
;ourproject2.c,145 :: 		if (ARM_MOTOR_START_PIN == PRESSED)
	BTFSC      PORTB+0, 2
	GOTO       L_main20
;ourproject2.c,147 :: 		belt_flag       = BELT_STOP;
	CLRF       _belt_flag+0
;ourproject2.c,148 :: 		}
L_main20:
;ourproject2.c,149 :: 		}
	GOTO       L_main10
L_main11:
;ourproject2.c,151 :: 		}
	GOTO       L_main8
;ourproject2.c,152 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
