	AREA	TastierProject, CODE, READONLY

    IMPORT  TastierDiv
	IMPORT	TastierMod
	IMPORT	TastierReadInt
	IMPORT	TastierPrintInt
	IMPORT	TastierPrintIntLf
	IMPORT	TastierPrintTrue
	IMPORT	TastierPrintTrueLf
	IMPORT	TastierPrintFalse
    IMPORT	TastierPrintFalseLf
    IMPORT  TastierPrintString
    
; Entry point called from C runtime __main
	EXPORT	main

; Preserve 8-byte stack alignment for external routines
	PRESERVE8

; Register names
BP  RN 10	; pointer to stack base
TOP RN 11	; pointer to top of stack

main
; Initialization
	LDR		R4, =globals
	LDR 	BP, =stack		; address of stack base
	LDR 	TOP, =stack+16	; address of top of stack frame
	B		Main
    LDR     R5, =0
    LDR     R2, =1
    ADD     R2, R4, R2, LSL #2
    STR     R5, [R2, R0, LSL #2] ; value of myArray[]
    LDR     R2, =1
    ADD     R2, R4, R2, LSL #2
    STR     R5, [R2, R1, LSL #2] ; value of myArray[]
    LDR     R2, =1
    ADD     R2, R4, R2, LSL #2
    STR     R5, [R2, R2, LSL #2] ; value of myArray[]
    LDR     R2, =1
    ADD     R2, R4, R2, LSL #2
    STR     R5, [R2, R3, LSL #2] ; value of myArray[]
    LDR     R2, =1
    ADD     R2, R4, R2, LSL #2
    STR     R5, [R2, R4, LSL #2] ; value of myArray[]
    LDR     R2, =1
    ADD     R2, R4, R2, LSL #2
    STR     R5, [R2, R5, LSL #2] ; value of myArray[]
    LDR     R2, =1
    ADD     R2, R4, R2, LSL #2
    STR     R5, [R2, R6, LSL #2] ; value of myArray[]
; Procedure Subtract
SubtractBody
    LDR     R2, =0
    LDR     R6, [R4, R2, LSL #2] ; i
    LDR     R8, =1
    SUB     R6, R6, R8
    LDR     R2, =0
    STR     R6, [R4, R2, LSL #2] ; i
    MOV     TOP, BP         ; reset top of stack
    LDR     BP, [TOP,#12]   ; and stack base pointers
    LDR     PC, [TOP]       ; return from Subtract
Subtract
    LDR     R0, =2          ; current lexic level
    LDR     R1, =0          ; number of local variables
    BL      enter           ; build new stack frame
    B       SubtractBody
; Procedure testPassFunc
testPassFuncBody
    LDR     R6, =0
    LDR     R2, =13
    STR     R6, [R4, R2, LSL #2] ; f
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L1
    DCB     "x =", 0
    ALIGN
L1
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; x
    MOV     R0, R5
    BL      TastierPrintIntLf
    LDR     R6, =5
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    STR     R6, [R2]        ; x
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L2
    DCB     "x =", 0
    ALIGN
L2
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; x
    MOV     R0, R5
    BL      TastierPrintIntLf
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L3
    DCB     "y =", 0
    ALIGN
L3
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; y
    MOV     R0, R5
    BL      TastierPrintIntLf
    MOV     TOP, BP         ; reset top of stack
    LDR     BP, [TOP,#12]   ; and stack base pointers
    LDR     PC, [TOP]       ; return from testPassFunc
testPassFunc
    LDR     R0, =2          ; current lexic level
    LDR     R1, =0          ; number of local variables
    BL      enter           ; build new stack frame
    B       testPassFuncBody
           ;x type : 1 scope : 2
           ;y type : 1 scope : 2
; Procedure Add
AddBody
    LDR     R2, =0
    LDR     R5, [R4, R2, LSL #2] ; i
    LDR     R7, =0
    CMP     R5, R7
    MOVGT   R5, #1
    MOVLE   R5, #0
    MOVS    R5, R5          ; reset Z flag in CPSR
    BEQ     L4              ; jump on condition false
    MOV     R2, BP          ; load current base pointer
    LDR     R2, [R2,#8]
    ADD     R2, R2, #16
    LDR     R1, =1
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; sum
    LDR     R2, =0
    LDR     R6, [R4, R2, LSL #2] ; i
    ADD     R5, R5, R6
    MOV     R2, BP          ; load current base pointer
    LDR     R2, [R2,#8]
    ADD     R2, R2, #16
    LDR     R1, =1
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; sum
    ADD     R0, PC, #4      ; store return address
    STR     R0, [TOP]       ; in new stack frame
    B       Subtract
    ADD     R0, PC, #4      ; store return address
    STR     R0, [TOP]       ; in new stack frame
    B       Add
    B       L5
L4
L5
    MOV     TOP, BP         ; reset top of stack
    LDR     BP, [TOP,#12]   ; and stack base pointers
    LDR     PC, [TOP]       ; return from Add
Add
    LDR     R0, =2          ; current lexic level
    LDR     R1, =0          ; number of local variables
    BL      enter           ; build new stack frame
    B       AddBody
; Procedure SumUp
SumUpBody
    LDR     R6, =0
    B       L7
L8
    ADD     R2, BP, #16
    LDR     R1, =2
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; index
    LDR     R7, =1
    ADD     R5, R5, R7
    ADD     R2, BP, #16
    LDR     R1, =2
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; index
L7
    ADD     R2, BP, #16
    LDR     R1, =2
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; index
    LDR     R7, =10
    CMP     R5, R7
    MOVLT   R5, #1
    MOVGE   R5, #0
    MOVS    R5, R5          ; reset Z flag in CPSR
    BEQ     L6              ; jump on condition false
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L9
    DCB     "hi", 0
    ALIGN
L9
    ADD     R2, BP, #16
    LDR     R1, =2
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; index
    MOV     R0, R5
    BL      TastierPrintInt
    B       L8
L6
    LDR     R6, =2
    ADD     R2, BP, #16
    LDR     R1, =3
    ADD     R2, R2, R1, LSL #2
    STR     R6, [R2]        ; testParam
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L10
    DCB     "testParam ---== ", 0
    ALIGN
L10
    ADD     R2, BP, #16
    LDR     R1, =3
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; testParam
    MOV     R0, R5
    BL      TastierPrintIntLf
    LDR     R2, =0
    LDR     R5, [R4, R2, LSL #2] ; i
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; j
    LDR     R6, =0
    ADD     R2, BP, #16
    LDR     R1, =1
    ADD     R2, R2, R1, LSL #2
    STR     R6, [R2]        ; sum
    LDR     R6, =3
    LDR     R2, =8
    STR     R6, [R4, R2, LSL #2] ; b
    LDR     R2, =0
    LDR     R5, [R4, R2, LSL #2] ; a
    LDR     R2, =8
    LDR     R6, [R4, R2, LSL #2] ; b
    ADD     R5, R5, R6
    LDR     R2, =8
    STR     R5, [R4, R2, LSL #2] ; b
    ADD     R0, PC, #4      ; store return address
    STR     R0, [TOP]       ; in new stack frame
    B       testPassFunc
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L11
    DCB     "testParam ----= ", 0
    ALIGN
L11
    ADD     R2, BP, #16
    LDR     R1, =3
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; testParam
    MOV     R0, R5
    BL      TastierPrintIntLf
    LDR     R5, =0
    LDR     R7, =1
    LDR     R5, =6
    LDR     R2, =1
    ADD     R2, R4, R2, LSL #2
    STR     R7, [R2, R5, LSL #2] ; value of myArray[]
    LDR     R6, =0
    LDR     R8, =0
    LDR     R9, =6
    LDR     R2, =1
    ADD     R2, R4, R2, LSL #2
    LDR     R8, [R2, R9, LSL #2] ; value of myArray[]
    LDR     R5, =4
    LDR     R2, =1
    ADD     R2, R4, R2, LSL #2
    STR     R8, [R2, R5, LSL #2] ; value of myArray[]
    LDR     R7, =0
    LDR     R8, =4
    LDR     R2, =1
    ADD     R2, R4, R2, LSL #2
    LDR     R7, [R2, R8, LSL #2] ; value of myArray[]
    LDR     R2, =8
    STR     R7, [R4, R2, LSL #2] ; b
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L12
    DCB     "b = ", 0
    ALIGN
L12
    LDR     R2, =8
    LDR     R5, [R4, R2, LSL #2] ; b
    MOV     R0, R5
    BL      TastierPrintIntLf
    LDR     R5, =0
    LDR     R7, =4
    LDR     R5, =5
    LDR     R2, =1
    ADD     R2, R4, R2, LSL #2
    STR     R7, [R2, R5, LSL #2] ; value of myArray[]
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L13
    DCB     "myArray at 5 = ", 0
    ALIGN
L13
    LDR     R7, =0
    LDR     R8, =5
    LDR     R2, =1
    ADD     R2, R4, R2, LSL #2
    LDR     R7, [R2, R8, LSL #2] ; value of myArray[]
    LDR     R2, =9
    STR     R7, [R4, R2, LSL #2] ; c
    LDR     R2, =9
    LDR     R5, [R4, R2, LSL #2] ; c
    MOV     R0, R5
    BL      TastierPrintIntLf
    MOVS    R5, #1          ; true
    BEQ     L14              ; jump on condition false
    B       L15
    LDR     R6, =4
    LDR     R7, =6
L14
    LDR     R5, =6
    LDR     R2, =10
    STR     R5, [R4, R2, LSL #2] ; condition
    B       L16
L15
    LDR     R5, =4
    LDR     R2, =10
    STR     R5, [R4, R2, LSL #2] ; condition
L16
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L17
    DCB     "condition = ", 0
    ALIGN
L17
    LDR     R2, =10
    LDR     R6, [R4, R2, LSL #2] ; condition
    MOV     R0, R6
    BL      TastierPrintIntLf
    LDR     R6, =1
    LDR     R8, =2
    CMP     R6, R8
    MOVGT   R6, #1
    MOVLE   R6, #0
    MOVS    R6, R6          ; reset Z flag in CPSR
    BEQ     L18              ; jump on condition false
    B       L19
    LDR     R6, =2
    LDR     R7, =3
L18
    LDR     R5, =3
    LDR     R2, =11
    STR     R5, [R4, R2, LSL #2] ; d
    B       L20
L19
    LDR     R5, =2
    LDR     R2, =11
    STR     R5, [R4, R2, LSL #2] ; d
L20
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L21
    DCB     "d = ", 0
    ALIGN
L21
    LDR     R2, =11
    LDR     R6, [R4, R2, LSL #2] ; d
    MOV     R0, R6
    BL      TastierPrintIntLf
    LDR     R6, =6
    LDR     R2, =12
    STR     R6, [R4, R2, LSL #2] ; e
    LDR     R2, =12
    LDR     R5, [R4, R2, LSL #2] ; e
    LDR     R7, =4
    CMP     R7, R5
    MOVEQ   R7, #1
    MOVNE   R7, #0
    MOVS    R7, R7          ; reset Z flag in CPSR
    BEQ     L23              ; jump on condition false
    LDR     R6, =10
    LDR     R2, =12
    STR     R6, [R4, R2, LSL #2] ; e
    B       L22
L23
    LDR     R7, =6
    CMP     R7, R5
    MOVEQ   R7, #1
    MOVNE   R7, #0
    MOVS    R7, R7          ; reset Z flag in CPSR
    BEQ     L24              ; jump on condition false
    LDR     R6, =2
    LDR     R2, =12
    STR     R6, [R4, R2, LSL #2] ; e
    B       L22
L24
    LDR     R7, =3
    CMP     R7, R5
    MOVEQ   R7, #1
    MOVNE   R7, #0
    MOVS    R7, R7          ; reset Z flag in CPSR
    BEQ     L25              ; jump on condition false
    LDR     R6, =3
    LDR     R2, =12
    STR     R6, [R4, R2, LSL #2] ; e
    B       L22
L25
    LDR     R6, =0
    LDR     R2, =12
    STR     R6, [R4, R2, LSL #2] ; e
    B       L22
L22
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L26
    DCB     "SWITCH ----e = ", 0
    ALIGN
L26
    LDR     R2, =12
    LDR     R5, [R4, R2, LSL #2] ; e
    MOV     R0, R5
    BL      TastierPrintIntLf
    ADD     R0, PC, #4      ; store return address
    STR     R0, [TOP]       ; in new stack frame
    B       Add
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L27
    DCB     "The sum of the values from 1 to ", 0
    ALIGN
L27
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; j
    MOV     R0, R5
    BL      TastierPrintInt
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L28
    DCB     " is ", 0
    ALIGN
L28
    ADD     R2, BP, #16
    LDR     R1, =1
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; sum
    MOV     R0, R5
    BL      TastierPrintIntLf
    MOV     TOP, BP         ; reset top of stack
    LDR     BP, [TOP,#12]   ; and stack base pointers
    LDR     PC, [TOP]       ; return from SumUp
SumUp
    LDR     R0, =1          ; current lexic level
    LDR     R1, =4          ; number of local variables
    BL      enter           ; build new stack frame
    B       SumUpBody
           ;j type : 1 scope : 1
           ;sum type : 1 scope : 1
           ;index type : 1 scope : 1
           ;testParam type : 1 scope : 1
           ;Subtract type : 0 scope : 1
           ;testPassFunc type : 0 scope : 1
           ;Add type : 0 scope : 1
MainBody
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L29
    DCB     "Enter value for i (or 0 to stop): ", 0
    ALIGN
L29
    LDR     R2, =8
    LDR     R5, [R4, R2, LSL #2] ; b
    MOV     R0, R5
    BL      TastierPrintIntLf
    BL      TastierReadInt
    LDR     R2, =0
    STR     R0, [R4, R2, LSL #2] ; i
    LDR     R6, =7
    LDR     R2, =0
    STR     R6, [R4, R2, LSL #2] ; cons
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L30
    DCB     "cons ==", 0
    ALIGN
L30
    LDR     R2, =0
    LDR     R5, [R4, R2, LSL #2] ; cons
    MOV     R0, R5
    BL      TastierPrintIntLf
L31
    LDR     R2, =0
    LDR     R5, [R4, R2, LSL #2] ; i
    LDR     R7, =0
    CMP     R5, R7
    MOVGT   R5, #1
    MOVLE   R5, #0
    MOVS    R5, R5          ; reset Z flag in CPSR
    BEQ     L32              ; jump on condition false
    ADD     R0, PC, #4      ; store return address
    STR     R0, [TOP]       ; in new stack frame
    B       SumUp
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L33
    DCB     "Enter value for i (or 0 to stop): ", 0
    ALIGN
L33
    BL      TastierReadInt
    LDR     R2, =0
    STR     R0, [R4, R2, LSL #2] ; i
    B       L31
L32
StopTest
    B       StopTest
Main
    LDR     R0, =1          ; current lexic level
    LDR     R1, =0          ; number of local variables
    BL      enter           ; build new stack frame
    B       MainBody
           ;i type : 1 scope : 0
           ;a type : 1 scope : 0
           ;cons type : 1 scope : 0
           ;myArray type : 1 scope : 0
           ;b type : 1 scope : 0
           ;c type : 1 scope : 0
           ;condition type : 1 scope : 0
           ;d type : 1 scope : 0
           ;e type : 1 scope : 0
           ;f type : 1 scope : 0
           ;firstPar type : 1 scope : 0
           ;secondPar type : 1 scope : 0
           ;SumUp type : 0 scope : 0
           ;main type : 0 scope : 0

; Subroutine enter
; Construct stack frame for procedure
; Input: R0 - lexic level (LL)
;		 R1 - number of local variables
; Output: new stack frame

enter
	STR		R0, [TOP,#4]			; set lexic level
	STR		BP, [TOP,#12]			; and dynamic link
	; if called procedure is at the same lexic level as
	; calling procedure then its static link is a copy of
	; the calling procedure's static link, otherwise called
 	; procedure's static link is a copy of the static link 
	; found LL delta levels down the static link chain
    LDR		R2, [BP,#4]				; check if called LL (R0) and
	SUBS	R0, R2					; calling LL (R2) are the same
	BGT		enter1
	LDR		R0, [BP,#8]				; store calling procedure's static
	STR		R0, [TOP,#8]			; link in called procedure's frame
	B		enter2
enter1
	MOV		R3, BP					; load current base pointer
	SUBS	R0, R0, #1				; and step down static link chain
    BEQ     enter2-4                ; until LL delta has been reduced
	LDR		R3, [R3,#8]				; to zero
	B		enter1+4				;
	STR		R3, [TOP,#8]			; store computed static link
enter2
	MOV		BP, TOP					; reset base and top registers to
	ADD		TOP, TOP, #16			; point to new stack frame adding
	ADD		TOP, TOP, R1, LSL #2	; four bytes per local variable
	BX		LR						; return
	
	AREA	Memory, DATA, READWRITE
globals     SPACE 4096
stack      	SPACE 16384

	END