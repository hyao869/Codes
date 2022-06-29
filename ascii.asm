;------------------------------------------------------------------------
;list 256 ASCII Characters with their ASCII code in hexdecimAL in front
;------------------------------------------------------------------------

DATA SEGMENT
	MSG DB 'Hello! The 256 ASCII Characters are: ' ,0DH ,0AH ,24H ; 
	; 0DH : end, 0AH : new line, 24H : '$' 
DATA ENDS

;Stack, without following statements, warning
SSEG SEGMENT PARA STACK
	DW 256 DUP(?)
SSEG ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA 
						
MAIN:
	MOV AX,DATA					 		; AX, Accumulator; 
	MOV DS,AX 							; DS, Data
	MOV DX,OFFSET MSG						; 

	MOV AH,9							; AH=9 - output of a string at DS:DX. String must be terminated by '$'
	INT 21H								; output string
	
	MOV CX, 256							; CX, count, initiALize CX
	MOV AH, 2							; set output 
	MOV DL, 0							; DX, DATA, DL = character to write, initiALize DL with 0


	LOOP1:								; loop label
		printHigh:
			PUSH DX	
			MOV  AL, DL	
			MOV  BH, DL 
			
			;higher nibble, manipulate AL, leave BL unchanged	
			push CX
			MOV CL, 04H
			shr AL, CL					; shift right 4 bits 
			POP CX

			push AX
			SUB AL, 10					; 0aH
			JB printHigh0to9
		
		printHighAtoF:
			POP AX
			SUB AL, 10					; translate hex digit into hex str
			ADD AL, 'A'
			MOV DL, AL					; MOVe hex str into output string 
			INT 21H	
			
		printLow:	
			AND BH, 00001111b				; isolate rightmost hex digit
			push BX
			SUB BH, 10
			JB printLow0to9

		printLowAtoF:
			POP bx
			SUB BH, 10					; translate hex digit into hex 
			ADD BH, 'A'
			MOV DL, BH					; MOVe hex str into output string 
			INT 21H	
			
		printLow_Finished:		
		
		MOV DL, ' '						; space
		INT 21H	
		
		POP DX							; ASCII
		INT 21H	
		PUSH DX
		MOV DL, ' '
		INT 21H	
		POP DX
		
		INC DL							; increment DL to next ASCII character
	LOOP LOOP1							; loop's condition
		
	MOV AH, 4CH							; return control to DOS
	INT 21H	
	
	 printHigh0to9:
		POP AX
		ADD AL, '0'
		MOV DL, AL
		INT 21H	
		JMP printLow_start
		
	 printLow0to9:
		POP bx
		ADD BH, '0'						; translate hex digit into hex str
		MOV DL, BH						; MOVe hex str into output string 
		INT 21H						
		JMP printLow_Finished

CODE ENDS
END MAIN
