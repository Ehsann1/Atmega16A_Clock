
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _select=R5
	.DEF _r_h=R4
	.DEF _r_m=R7
	.DEF _r_s=R6
	.DEF _ti=R9
	.DEF _temp=R8
	.DEF _r_D=R11
	.DEF _r_M=R10
	.DEF _r_Y=R13
	.DEF _r_wd=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_Display:
	.DB  0xC0,0xF9,0xA4,0x30,0x99,0x92,0x82,0xF8
	.DB  0x80,0x90

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0

_0x0:
	.DB  0x25,0x30,0x32,0x64,0x3A,0x25,0x30,0x32
	.DB  0x64,0x3A,0x25,0x30,0x32,0x64,0x20,0x20
	.DB  0x43,0x61,0x6E,0x63,0x65,0x6C,0x31,0x34
	.DB  0x25,0x30,0x32,0x64,0x2F,0x25,0x30,0x32
	.DB  0x64,0x2F,0x25,0x30,0x32,0x64,0x20,0x20
	.DB  0x20,0x4F,0x6B,0x0,0x4E,0x6F,0x72,0x6F
	.DB  0x75,0x7A,0x69,0x7C,0x53,0x69,0x61,0x68
	.DB  0x72,0x61,0x6E,0x67,0x0,0x20,0x20,0x20
	.DB  0x53,0x61,0x76,0x69,0x6E,0x67,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x53,0x61,0x76
	.DB  0x69,0x6E,0x67,0x2E,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x53,0x61,0x76,0x69,0x6E,0x67
	.DB  0x2E,0x2E,0x20,0x0,0x20,0x20,0x20,0x53
	.DB  0x61,0x76,0x69,0x6E,0x67,0x2E,0x2E,0x2E
	.DB  0x20,0x0,0x20,0x20,0x20,0x63,0x61,0x6E
	.DB  0x63,0x65,0x6C,0x69,0x6E,0x67,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x63,0x61,0x6E
	.DB  0x63,0x65,0x6C,0x69,0x6E,0x67,0x2E,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x63,0x61,0x6E
	.DB  0x63,0x65,0x6C,0x69,0x6E,0x67,0x2E,0x2E
	.DB  0x20,0x0,0x20,0x20,0x20,0x63,0x61,0x6E
	.DB  0x63,0x65,0x6C,0x69,0x6E,0x67,0x2E,0x2E
	.DB  0x2E,0x20,0x0,0x20,0x20,0x20,0x53,0x74
	.DB  0x61,0x72,0x74,0x69,0x6E,0x67,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x53,0x74,0x61
	.DB  0x72,0x74,0x69,0x6E,0x67,0x2E,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x53,0x74,0x61,0x72
	.DB  0x74,0x69,0x6E,0x67,0x2E,0x2E,0x20,0x0
	.DB  0x20,0x20,0x20,0x53,0x74,0x61,0x72,0x74
	.DB  0x69,0x6E,0x67,0x2E,0x2E,0x2E,0x20,0x0
	.DB  0x25,0x64,0xDF,0x43,0x0,0x31,0x34,0x25
	.DB  0x30,0x32,0x64,0x2F,0x25,0x30,0x32,0x64
	.DB  0x2F,0x25,0x30,0x32,0x64,0x0,0x25,0x30
	.DB  0x32,0x64,0x3A,0x25,0x30,0x32,0x64,0x3A
	.DB  0x25,0x30,0x32,0x64,0x0
_0x2020003:
	.DB  0x80,0xC0
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20E0060:
	.DB  0x1
_0x20E0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  0x05
	.DW  __REG_VARS*2

	.DW  0x11
	.DW  _0x44
	.DW  _0x0*2+44

	.DW  0x0D
	.DW  _0x44+17
	.DW  _0x0*2+61

	.DW  0x0D
	.DW  _0x44+30
	.DW  _0x0*2+74

	.DW  0x0D
	.DW  _0x44+43
	.DW  _0x0*2+87

	.DW  0x0E
	.DW  _0x44+56
	.DW  _0x0*2+100

	.DW  0x11
	.DW  _0x45
	.DW  _0x0*2+44

	.DW  0x10
	.DW  _0x45+17
	.DW  _0x0*2+114

	.DW  0x10
	.DW  _0x45+33
	.DW  _0x0*2+130

	.DW  0x10
	.DW  _0x45+49
	.DW  _0x0*2+146

	.DW  0x11
	.DW  _0x45+65
	.DW  _0x0*2+162

	.DW  0x11
	.DW  _0x52
	.DW  _0x0*2+44

	.DW  0x0F
	.DW  _0x52+17
	.DW  _0x0*2+179

	.DW  0x0F
	.DW  _0x52+32
	.DW  _0x0*2+194

	.DW  0x0F
	.DW  _0x52+47
	.DW  _0x0*2+209

	.DW  0x10
	.DW  _0x52+62
	.DW  _0x0*2+224

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

	.DW  0x01
	.DW  __seed_G107
	.DW  _0x20E0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 7/21/2021
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <i2c.h>
;#include <ds1307.h>
;#include <alcd.h>
;#include <stdio.h>
;
;
;// Variables:
;#define H1 PORTC.5
;#define H2 PORTC.4
;#define M1 PORTC.3
;#define M2 PORTC.2
;
;#define _7seg PORTD
;
;#define selectKey PINA.6
;#define ValueKey PINA.7
;
;char select=0,
;     r_h, r_m, r_s,
;     ti=0, temp,
;     r_D, r_M, r_Y ,r_wd;
;
;unsigned char text[32], edit_mode[6]; // H:M:S | Y/M/D
;flash char Display[10] = { 0XC0 , 0XF9 , 0XA4 , 0X30 , 0X99 , 0X92 , 0X82 , 0XF8 , 0X80 , 0X90 };
;// Variables/
;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void){
; 0000 0035 interrupt [10] void timer0_ovf_isr(void){

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0036       TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 0037       // Timer Codes
; 0000 0038 
; 0000 0039       if(ti==0){
	TST  R9
	BRNE _0x3
; 0000 003A        M2=1;H2=0;M1=0;H1=0;
	SBI  0x15,2
	CBI  0x15,4
	CBI  0x15,3
	CBI  0x15,5
; 0000 003B         _7seg = Display[r_m%10];
	MOV  R26,R7
	CALL SUBOPT_0x0
; 0000 003C         }
; 0000 003D       if(ti==1){
_0x3:
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0xC
; 0000 003E         M1=1;H2=0;M2=0;H1=0;
	SBI  0x15,3
	CBI  0x15,4
	CBI  0x15,2
	CBI  0x15,5
; 0000 003F         _7seg = Display[r_m/10];
	MOV  R26,R7
	CALL SUBOPT_0x1
; 0000 0040         }
; 0000 0041       if(ti==2){
_0xC:
	LDI  R30,LOW(2)
	CP   R30,R9
	BRNE _0x15
; 0000 0042         H2=1;M2=0;M1=0;H1=0;
	SBI  0x15,4
	CBI  0x15,2
	CBI  0x15,3
	CBI  0x15,5
; 0000 0043         _7seg = Display[r_h%10];
	MOV  R26,R4
	CALL SUBOPT_0x0
; 0000 0044         }
; 0000 0045       if(ti==3){
_0x15:
	LDI  R30,LOW(3)
	CP   R30,R9
	BRNE _0x1E
; 0000 0046         H1=1;H2=0;M1=0;M2=0;
	SBI  0x15,5
	CBI  0x15,4
	CBI  0x15,3
	CBI  0x15,2
; 0000 0047         _7seg = Display[r_h/10];
	MOV  R26,R4
	CALL SUBOPT_0x1
; 0000 0048         }
; 0000 0049         ti++;
_0x1E:
	INC  R9
; 0000 004A         if(ti==4){ti=0;}
	LDI  R30,LOW(4)
	CP   R30,R9
	BRNE _0x27
	CLR  R9
; 0000 004B 
; 0000 004C }
_0x27:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input){
; 0000 0052 unsigned int read_adc(unsigned char adc_input){
_read_adc:
; .FSTART _read_adc
; 0000 0053       ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0054       delay_us(10);
	__DELAY_USB 27
; 0000 0055       ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0056       while ((ADCSRA & (1<<ADIF))==0);
_0x28:
	SBIS 0x6,4
	RJMP _0x28
; 0000 0057       ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0058       return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x2100006
; 0000 0059 }
; .FEND
;
;
;void change_select_po(void){
; 0000 005C void change_select_po(void){
_change_select_po:
; .FSTART _change_select_po
; 0000 005D switch (select){
	MOV  R30,R5
	LDI  R31,0
; 0000 005E                 case 0:lcd_gotoxy(1,0);_lcd_write_data(0xF);break;
	SBIW R30,0
	BRNE _0x2E
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _0x66
; 0000 005F                 case 1:lcd_gotoxy(4,0);_lcd_write_data(0xF);break;
_0x2E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2F
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _0x66
; 0000 0060                 case 2:lcd_gotoxy(7,0);_lcd_write_data(0xF);break;
_0x2F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x30
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _0x66
; 0000 0061                 case 3:lcd_gotoxy(10,0);_lcd_write_data(0xF);break;
_0x30:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x31
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _0x66
; 0000 0062                 case 4:lcd_gotoxy(3,1);_lcd_write_data(0xF);break;
_0x31:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x32
	LDI  R30,LOW(3)
	RJMP _0x67
; 0000 0063                 case 5:lcd_gotoxy(6,1);_lcd_write_data(0xF);break;
_0x32:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x33
	LDI  R30,LOW(6)
	RJMP _0x67
; 0000 0064                 case 6:lcd_gotoxy(9,1);_lcd_write_data(0xF);break;
_0x33:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x34
	LDI  R30,LOW(9)
	RJMP _0x67
; 0000 0065                 case 7:lcd_gotoxy(13,1);_lcd_write_data(0xF);break;
_0x34:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2D
	LDI  R30,LOW(13)
_0x67:
	ST   -Y,R30
	LDI  R26,LOW(1)
_0x66:
	CALL _lcd_gotoxy
	LDI  R26,LOW(15)
	RCALL __lcd_write_data
; 0000 0066             }
_0x2D:
; 0000 0067 }
	RET
; .FEND
;
;
;void change_select_va(void){
; 0000 006A void change_select_va(void){
_change_select_va:
; .FSTART _change_select_va
; 0000 006B switch (select){
	MOV  R30,R5
	LDI  R31,0
; 0000 006C                 case 0:edit_mode[0]++;if(edit_mode[0]==25)edit_mode[0]=0;break;
	SBIW R30,0
	BRNE _0x39
	LDS  R30,_edit_mode
	SUBI R30,-LOW(1)
	STS  _edit_mode,R30
	LDS  R26,_edit_mode
	CPI  R26,LOW(0x19)
	BRNE _0x3A
	LDI  R30,LOW(0)
	STS  _edit_mode,R30
_0x3A:
	RJMP _0x38
; 0000 006D                 case 1:edit_mode[1]++;if(edit_mode[1]==61)edit_mode[1]=0;break;
_0x39:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3B
	__GETB1MN _edit_mode,1
	SUBI R30,-LOW(1)
	__PUTB1MN _edit_mode,1
	__GETB2MN _edit_mode,1
	CPI  R26,LOW(0x3D)
	BRNE _0x3C
	LDI  R30,LOW(0)
	__PUTB1MN _edit_mode,1
_0x3C:
	RJMP _0x38
; 0000 006E                 case 2:edit_mode[2]++;if(edit_mode[2]==61)edit_mode[2]=0;break;
_0x3B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3D
	__GETB1MN _edit_mode,2
	SUBI R30,-LOW(1)
	__PUTB1MN _edit_mode,2
	__GETB2MN _edit_mode,2
	CPI  R26,LOW(0x3D)
	BRNE _0x3E
	LDI  R30,LOW(0)
	__PUTB1MN _edit_mode,2
_0x3E:
	RJMP _0x38
; 0000 006F                 case 4:edit_mode[3]++;break;
_0x3D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x3F
	__GETB1MN _edit_mode,3
	SUBI R30,-LOW(1)
	__PUTB1MN _edit_mode,3
	RJMP _0x38
; 0000 0070                 case 5:edit_mode[4]++;if(edit_mode[4]==13)edit_mode[4]=0;break;
_0x3F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x40
	__GETB1MN _edit_mode,4
	SUBI R30,-LOW(1)
	__PUTB1MN _edit_mode,4
	__GETB2MN _edit_mode,4
	CPI  R26,LOW(0xD)
	BRNE _0x41
	LDI  R30,LOW(0)
	__PUTB1MN _edit_mode,4
_0x41:
	RJMP _0x38
; 0000 0071                 case 6:edit_mode[5]++;if(edit_mode[5]==32)edit_mode[5]=0;break;
_0x40:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x38
	__GETB1MN _edit_mode,5
	SUBI R30,-LOW(1)
	__PUTB1MN _edit_mode,5
	__GETB2MN _edit_mode,5
	CPI  R26,LOW(0x20)
	BRNE _0x43
	LDI  R30,LOW(0)
	__PUTB1MN _edit_mode,5
_0x43:
; 0000 0072             }
_0x38:
; 0000 0073             lcd_clear();
	CALL SUBOPT_0x2
; 0000 0074             sprintf(text,"%02d:%02d:%02d  Cancel14%02d/%02d/%02d   Ok",
; 0000 0075                  edit_mode[0],edit_mode[1],edit_mode[2],
; 0000 0076                  edit_mode[3],edit_mode[4],edit_mode[5]
; 0000 0077                 );
; 0000 0078             lcd_puts(text);
; 0000 0079             change_select_po();
; 0000 007A }
	RET
; .FEND
;
;
;
;void saving_page(void){
; 0000 007E void saving_page(void){
_saving_page:
; .FSTART _saving_page
; 0000 007F     lcd_clear();
	CALL SUBOPT_0x3
; 0000 0080 
; 0000 0081 lcd_gotoxy(0,1) ;lcd_puts("Norouzi|Siahrang");
	__POINTW2MN _0x44,0
	CALL SUBOPT_0x4
; 0000 0082 
; 0000 0083 lcd_gotoxy(0,0);lcd_puts("   Saving   ");
	__POINTW2MN _0x44,17
	CALL SUBOPT_0x5
; 0000 0084 delay_ms(500);
; 0000 0085 lcd_gotoxy(0,0);lcd_puts("   Saving.  ");
	__POINTW2MN _0x44,30
	CALL SUBOPT_0x5
; 0000 0086 delay_ms(500);
; 0000 0087 lcd_gotoxy(0,0);lcd_puts("   Saving.. ");
	__POINTW2MN _0x44,43
	CALL SUBOPT_0x5
; 0000 0088 delay_ms(500);
; 0000 0089 lcd_gotoxy(0,0);lcd_puts("   Saving... ");
	__POINTW2MN _0x44,56
	RJMP _0x2100008
; 0000 008A delay_ms(500);
; 0000 008B 
; 0000 008C delay_ms(300);
; 0000 008D }
; .FEND

	.DSEG
_0x44:
	.BYTE 0x46
;
;void save_data(void){
; 0000 008F void save_data(void){

	.CSEG
_save_data:
; .FSTART _save_data
; 0000 0090 
; 0000 0091     rtc_set_time(edit_mode[0],edit_mode[1],edit_mode[2]);
	LDS  R30,_edit_mode
	ST   -Y,R30
	__GETB1MN _edit_mode,1
	ST   -Y,R30
	__GETB2MN _edit_mode,2
	RCALL _rtc_set_time
; 0000 0092     rtc_set_date(7,edit_mode[5],edit_mode[4],edit_mode[3]);
	LDI  R30,LOW(7)
	ST   -Y,R30
	__GETB1MN _edit_mode,5
	ST   -Y,R30
	__GETB1MN _edit_mode,4
	ST   -Y,R30
	__GETB2MN _edit_mode,3
	RCALL _rtc_set_date
; 0000 0093     saving_page();
	RCALL _saving_page
; 0000 0094 }
	RET
; .FEND
;void canceling_page(void){
; 0000 0095 void canceling_page(void){
_canceling_page:
; .FSTART _canceling_page
; 0000 0096     lcd_clear();
	CALL SUBOPT_0x3
; 0000 0097 
; 0000 0098 lcd_gotoxy(0,1) ;lcd_puts("Norouzi|Siahrang");
	__POINTW2MN _0x45,0
	CALL SUBOPT_0x4
; 0000 0099 
; 0000 009A lcd_gotoxy(0,0);lcd_puts("   canceling   ");
	__POINTW2MN _0x45,17
	CALL SUBOPT_0x5
; 0000 009B delay_ms(500);
; 0000 009C lcd_gotoxy(0,0);lcd_puts("   canceling.  ");
	__POINTW2MN _0x45,33
	CALL SUBOPT_0x5
; 0000 009D delay_ms(500);
; 0000 009E lcd_gotoxy(0,0);lcd_puts("   canceling.. ");
	__POINTW2MN _0x45,49
	CALL SUBOPT_0x5
; 0000 009F delay_ms(500);
; 0000 00A0 lcd_gotoxy(0,0);lcd_puts("   canceling... ");
	__POINTW2MN _0x45,65
_0x2100008:
	CALL _lcd_puts
; 0000 00A1 delay_ms(500);
	CALL SUBOPT_0x6
; 0000 00A2 
; 0000 00A3 delay_ms(300);
; 0000 00A4 }
	RET
; .FEND

	.DSEG
_0x45:
	.BYTE 0x52
;
;
;void main(void)
; 0000 00A8 {

	.CSEG
_main:
; .FSTART _main
; 0000 00A9 
; 0000 00AA 
; 0000 00AB // Timer/Counter 0 initialization
; 0000 00AC // Clock source: System Clock
; 0000 00AD // Clock value: 125.000 kHz
; 0000 00AE // Mode: Normal top=0xFF
; 0000 00AF // OC0 output: Disconnected
; 0000 00B0 // Timer Period: 1 ms
; 0000 00B1 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 00B2 TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 00B3 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 00B4 
; 0000 00B5 // Timer/Counter 1 initialization
; 0000 00B6 // Clock source: System Clock
; 0000 00B7 // Clock value: Timer1 Stopped
; 0000 00B8 // Mode: Normal top=0xFFFF
; 0000 00B9 // OC1A output: Disconnected
; 0000 00BA // OC1B output: Disconnected
; 0000 00BB // Noise Canceler: Off
; 0000 00BC // Input Capture on Falling Edge
; 0000 00BD // Timer1 Overflow Interrupt: Off
; 0000 00BE // Input Capture Interrupt: Off
; 0000 00BF // Compare A Match Interrupt: Off
; 0000 00C0 // Compare B Match Interrupt: Off
; 0000 00C1 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00C2 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00C3 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00C4 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00C5 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00C6 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00C7 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00C8 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00C9 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00CA OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00CB 
; 0000 00CC // Timer/Counter 2 initialization
; 0000 00CD // Clock source: System Clock
; 0000 00CE // Clock value: Timer2 Stopped
; 0000 00CF // Mode: Normal top=0xFF
; 0000 00D0 // OC2 output: Disconnected
; 0000 00D1 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00D2 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00D3 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00D4 OCR2=0x00;
	OUT  0x23,R30
; 0000 00D5 
; 0000 00D6 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00D7 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00D8 
; 0000 00D9 
; 0000 00DA DDRA = 0X00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00DB 
; 0000 00DC // ADC:
; 0000 00DD ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00DE ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 00DF ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 00E0 SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00E1 
; 0000 00E2 // DS1307:
; 0000 00E3 i2c_init();
	CALL _i2c_init
; 0000 00E4 rtc_init(0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 00E5 
; 0000 00E6 // LCD:
; 0000 00E7 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00E8 #asm("sei")
	sei
; 0000 00E9 
; 0000 00EA 
; 0000 00EB 
; 0000 00EC // Ports configur:
; 0000 00ED DDRD = 0XFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 00EE DDRA = 0X00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00EF 
; 0000 00F0 // Pull Up:
; 0000 00F1 PORTA.6=1;
	SBI  0x1B,6
; 0000 00F2 PORTA.7=1;
	SBI  0x1B,7
; 0000 00F3 
; 0000 00F4 // 7Seg shifter pins:
; 0000 00F5 DDRC.2 = 1;
	SBI  0x14,2
; 0000 00F6 DDRC.3 = 1;
	SBI  0x14,3
; 0000 00F7 DDRC.4 = 1;
	SBI  0x14,4
; 0000 00F8 DDRC.5 = 1;
	SBI  0x14,5
; 0000 00F9 
; 0000 00FA 
; 0000 00FB 
; 0000 00FC  rtc_get_time(&r_h, &r_m, &r_s);
	CALL SUBOPT_0x7
; 0000 00FD 
; 0000 00FE //rtc_set_time(23,59,50);
; 0000 00FF //rtc_set_date(7,30,4,00);
; 0000 0100 
; 0000 0101 
; 0000 0102 lcd_clear();
	CALL SUBOPT_0x3
; 0000 0103 
; 0000 0104 lcd_gotoxy(0,1) ;lcd_puts("Norouzi|Siahrang");
	__POINTW2MN _0x52,0
	CALL SUBOPT_0x4
; 0000 0105 
; 0000 0106 lcd_gotoxy(0,0);lcd_puts("   Starting   ");
	__POINTW2MN _0x52,17
	CALL SUBOPT_0x5
; 0000 0107 delay_ms(500);
; 0000 0108 lcd_gotoxy(0,0);lcd_puts("   Starting.  ");
	__POINTW2MN _0x52,32
	CALL SUBOPT_0x5
; 0000 0109 delay_ms(500);
; 0000 010A lcd_gotoxy(0,0);lcd_puts("   Starting.. ");
	__POINTW2MN _0x52,47
	CALL SUBOPT_0x5
; 0000 010B delay_ms(500);
; 0000 010C lcd_gotoxy(0,0);lcd_puts("   Starting... ");
	__POINTW2MN _0x52,62
	RCALL _lcd_puts
; 0000 010D delay_ms(500);
	CALL SUBOPT_0x6
; 0000 010E 
; 0000 010F delay_ms(300);
; 0000 0110 
; 0000 0111 lcd_clear();
	RCALL _lcd_clear
; 0000 0112 
; 0000 0113 while (1)
_0x53:
; 0000 0114       {
; 0000 0115         // Get time and date
; 0000 0116         rtc_get_time(&r_h, &r_m, &r_s);
	CALL SUBOPT_0x7
; 0000 0117         rtc_get_date(&r_wd,&r_D, &r_M,&r_Y );
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(13)
	LDI  R27,HIGH(13)
	RCALL _rtc_get_date
; 0000 0118 
; 0000 0119         // Print template:
; 0000 011A         temp = ((read_adc(0)/1024.0)*5000)/10 ;
	LDI  R26,LOW(0)
	RCALL _read_adc
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x44800000
	CALL __DIVF21
	__GETD2N 0x459C4000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	MOV  R8,R30
; 0000 011B         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xA
; 0000 011C         sprintf(text,"%d\xdf\C",temp);
	__POINTW1FN _0x0,240
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R8
	CALL SUBOPT_0xB
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 011D         lcd_puts(text);
	CALL SUBOPT_0xC
; 0000 011E 
; 0000 011F         // Print date:
; 0000 0120         lcd_gotoxy(3,1);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0121         sprintf(text,"14%02d/%02d/%02d",r_Y,r_M,r_D);
	LDI  R30,LOW(_text)
	LDI  R31,HIGH(_text)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,245
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R13
	CALL SUBOPT_0xB
	MOV  R30,R10
	CALL SUBOPT_0xB
	MOV  R30,R11
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
; 0000 0122         lcd_puts(text);
; 0000 0123 
; 0000 0124         // Print time:
; 0000 0125         lcd_gotoxy(7,0);
	LDI  R30,LOW(7)
	CALL SUBOPT_0xA
; 0000 0126         sprintf(text,"%02d:%02d:%02d",r_h,r_m,r_s);
	__POINTW1FN _0x0,262
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R4
	CALL SUBOPT_0xB
	MOV  R30,R7
	CALL SUBOPT_0xB
	MOV  R30,R6
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
; 0000 0127         lcd_puts(text);
; 0000 0128 
; 0000 0129 
; 0000 012A         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 012B 
; 0000 012C 
; 0000 012D         if(selectKey == 0){ // Menu button  // H:M:S | Y/M/D
	SBIC 0x19,6
	RJMP _0x56
; 0000 012E         delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 012F         if(selectKey == 0){
	SBIC 0x19,6
	RJMP _0x57
; 0000 0130             edit_mode[0] = 0;
	LDI  R30,LOW(0)
	STS  _edit_mode,R30
; 0000 0131             edit_mode[1] = 0;
	__PUTB1MN _edit_mode,1
; 0000 0132             edit_mode[2] = 0;
	__PUTB1MN _edit_mode,2
; 0000 0133             edit_mode[3] = 0;
	__PUTB1MN _edit_mode,3
; 0000 0134             edit_mode[4] = 0;
	__PUTB1MN _edit_mode,4
; 0000 0135             edit_mode[5] = 0;
	__PUTB1MN _edit_mode,5
; 0000 0136 
; 0000 0137             edit_mode[0]=r_h;edit_mode[1]=r_m;edit_mode[2]=r_s;
	STS  _edit_mode,R4
	__PUTBMRN _edit_mode,1,7
	__PUTBMRN _edit_mode,2,6
; 0000 0138             edit_mode[3]=r_Y;edit_mode[4]=r_M;edit_mode[5]=r_D;
	__PUTBMRN _edit_mode,3,13
	__PUTBMRN _edit_mode,4,10
	__PUTBMRN _edit_mode,5,11
; 0000 0139 
; 0000 013A             lcd_clear();
	CALL SUBOPT_0x2
; 0000 013B             sprintf(text,"%02d:%02d:%02d  Cancel14%02d/%02d/%02d   Ok",
; 0000 013C                  edit_mode[0],edit_mode[1],edit_mode[2],
; 0000 013D                  edit_mode[3],edit_mode[4],edit_mode[5]
; 0000 013E                 );
; 0000 013F             lcd_puts(text);
; 0000 0140 
; 0000 0141             change_select_po();
; 0000 0142 
; 0000 0143             while(selectKey == 0);// Up key
_0x58:
	SBIS 0x19,6
	RJMP _0x58
; 0000 0144 
; 0000 0145             while(1){
_0x5B:
; 0000 0146                 if(selectKey == 0){select++;if(select==8)select=0;change_select_po();delay_ms(500);}
	SBIC 0x19,6
	RJMP _0x5E
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x5F
	CLR  R5
_0x5F:
	RCALL _change_select_po
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0147                 if(ValueKey==0){
_0x5E:
	SBIC 0x19,7
	RJMP _0x60
; 0000 0148                     if(select==3){canceling_page();lcd_clear();break;}// Cancel
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x61
	RCALL _canceling_page
	RCALL _lcd_clear
	RJMP _0x5D
; 0000 0149                     else if(select==7){save_data();lcd_clear();break;} // Save
_0x61:
	LDI  R30,LOW(7)
	CP   R30,R5
	BRNE _0x63
	RCALL _save_data
	RCALL _lcd_clear
	RJMP _0x5D
; 0000 014A                     else{change_select_va();}
_0x63:
	RCALL _change_select_va
; 0000 014B                     delay_ms(400);
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL _delay_ms
; 0000 014C                 }
; 0000 014D             }
_0x60:
	RJMP _0x5B
_0x5D:
; 0000 014E         }
; 0000 014F 
; 0000 0150 
; 0000 0151 
; 0000 0152        }
_0x57:
; 0000 0153       }
_0x56:
	RJMP _0x53
; 0000 0154 }
_0x65:
	RJMP _0x65
; .FEND

	.DSEG
_0x52:
	.BYTE 0x4E

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2000003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2000004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2000004:
	CALL SUBOPT_0xE
	LDI  R26,LOW(7)
	CALL _i2c_write
	LDD  R26,Y+2
	CALL SUBOPT_0xF
	RJMP _0x2100007
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0xE
	LDI  R26,LOW(0)
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	MOV  R26,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL _i2c_stop
	ADIW R28,6
	RET
; .FEND
_rtc_set_time:
; .FSTART _rtc_set_time
	ST   -Y,R26
	CALL SUBOPT_0xE
	LDI  R26,LOW(0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	CALL SUBOPT_0xF
	RJMP _0x2100007
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0xE
	LDI  R26,LOW(3)
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	CALL SUBOPT_0x12
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	CALL SUBOPT_0x11
	CALL _i2c_stop
	ADIW R28,8
	RET
; .FEND
_rtc_set_date:
; .FSTART _rtc_set_date
	ST   -Y,R26
	CALL SUBOPT_0xE
	LDI  R26,LOW(3)
	CALL _i2c_write
	LDD  R26,Y+3
	CALL SUBOPT_0x16
	CALL SUBOPT_0x15
	CALL SUBOPT_0x14
	CALL SUBOPT_0xF
	JMP  _0x2100003
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 13
	SBI  0x18,2
	__DELAY_USB 13
	CBI  0x18,2
	__DELAY_USB 13
	RJMP _0x2100006
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x2100006
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x17
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x17
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020004
_0x2020005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020007
	RJMP _0x2100006
_0x2020007:
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2100006
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	LDD  R17,Y+0
_0x2100007:
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x18
	CALL SUBOPT_0x18
	CALL SUBOPT_0x18
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2100006:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G102:
; .FSTART _put_buff_G102
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x19
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	CALL SUBOPT_0x19
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__ftoe_G102:
; .FSTART __ftoe_G102
	CALL SUBOPT_0x1A
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2040019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2040000,0
	CALL _strcpyf
	RJMP _0x2100005
_0x2040019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2040018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2040000,1
	CALL _strcpyf
	RJMP _0x2100005
_0x2040018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x204001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x204001B:
	LDD  R17,Y+11
_0x204001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x204001E
	CALL SUBOPT_0x1B
	RJMP _0x204001C
_0x204001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x204001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x1B
	RJMP _0x2040020
_0x204001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x1C
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040021
	CALL SUBOPT_0x1B
_0x2040022:
	CALL SUBOPT_0x1C
	BRLO _0x2040024
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	RJMP _0x2040022
_0x2040024:
	RJMP _0x2040025
_0x2040021:
_0x2040026:
	CALL SUBOPT_0x1C
	BRSH _0x2040028
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	SUBI R19,LOW(1)
	RJMP _0x2040026
_0x2040028:
	CALL SUBOPT_0x1B
_0x2040025:
	__GETD1S 12
	CALL SUBOPT_0x21
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1C
	BRLO _0x2040029
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
_0x2040029:
_0x2040020:
	LDI  R17,LOW(0)
_0x204002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x204002C
	__GETD2S 4
	CALL SUBOPT_0x22
	CALL SUBOPT_0x21
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x9
	MOV  R16,R30
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x25
	CALL SUBOPT_0x20
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x204002A
	CALL SUBOPT_0x23
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x204002A
_0x204002C:
	CALL SUBOPT_0x26
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x204002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2040113
_0x204002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2040113:
	ST   X,R30
	CALL SUBOPT_0x26
	CALL SUBOPT_0x26
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x26
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2100005:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x19
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2040036
	CPI  R18,37
	BRNE _0x2040037
	LDI  R17,LOW(1)
	RJMP _0x2040038
_0x2040037:
	CALL SUBOPT_0x27
_0x2040038:
	RJMP _0x2040035
_0x2040036:
	CPI  R30,LOW(0x1)
	BRNE _0x2040039
	CPI  R18,37
	BRNE _0x204003A
	CALL SUBOPT_0x27
	RJMP _0x2040114
_0x204003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x204003B
	LDI  R16,LOW(1)
	RJMP _0x2040035
_0x204003B:
	CPI  R18,43
	BRNE _0x204003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003C:
	CPI  R18,32
	BRNE _0x204003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003D:
	RJMP _0x204003E
_0x2040039:
	CPI  R30,LOW(0x2)
	BRNE _0x204003F
_0x204003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040040
	ORI  R16,LOW(128)
	RJMP _0x2040035
_0x2040040:
	RJMP _0x2040041
_0x204003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2040042
_0x2040041:
	CPI  R18,48
	BRLO _0x2040044
	CPI  R18,58
	BRLO _0x2040045
_0x2040044:
	RJMP _0x2040043
_0x2040045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2040035
_0x2040043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2040046
	LDI  R17,LOW(4)
	RJMP _0x2040035
_0x2040046:
	RJMP _0x2040047
_0x2040042:
	CPI  R30,LOW(0x4)
	BRNE _0x2040049
	CPI  R18,48
	BRLO _0x204004B
	CPI  R18,58
	BRLO _0x204004C
_0x204004B:
	RJMP _0x204004A
_0x204004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2040035
_0x204004A:
_0x2040047:
	CPI  R18,108
	BRNE _0x204004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2040035
_0x204004D:
	RJMP _0x204004E
_0x2040049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2040035
_0x204004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2040053
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	CALL SUBOPT_0x28
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x2A
	RJMP _0x2040054
_0x2040053:
	CPI  R30,LOW(0x45)
	BREQ _0x2040057
	CPI  R30,LOW(0x65)
	BRNE _0x2040058
_0x2040057:
	RJMP _0x2040059
_0x2040058:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x204005A
_0x2040059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x2B
	CALL __GETD1P
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	LDD  R26,Y+13
	TST  R26
	BRMI _0x204005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x204005D
	CPI  R26,LOW(0x20)
	BREQ _0x204005F
	RJMP _0x2040060
_0x204005B:
	CALL SUBOPT_0x2E
	CALL __ANEGF1
	CALL SUBOPT_0x2C
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x204005D:
	SBRS R16,7
	RJMP _0x2040061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x2A
	RJMP _0x2040062
_0x2040061:
_0x204005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2040062:
_0x2040060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2040064
	CALL SUBOPT_0x2E
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2040065
_0x2040064:
	CALL SUBOPT_0x2E
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G102
_0x2040065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x2F
	RJMP _0x2040066
_0x204005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2040068
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x30
	CALL SUBOPT_0x2F
	RJMP _0x2040069
_0x2040068:
	CPI  R30,LOW(0x70)
	BRNE _0x204006B
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x30
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x204006D
	CP   R20,R17
	BRLO _0x204006E
_0x204006D:
	RJMP _0x204006C
_0x204006E:
	MOV  R17,R20
_0x204006C:
_0x2040066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x204006F
_0x204006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2040072
	CPI  R30,LOW(0x69)
	BRNE _0x2040073
_0x2040072:
	ORI  R16,LOW(4)
	RJMP _0x2040074
_0x2040073:
	CPI  R30,LOW(0x75)
	BRNE _0x2040075
_0x2040074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2040076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x31
	LDI  R17,LOW(10)
	RJMP _0x2040077
_0x2040076:
	__GETD1N 0x2710
	CALL SUBOPT_0x31
	LDI  R17,LOW(5)
	RJMP _0x2040077
_0x2040075:
	CPI  R30,LOW(0x58)
	BRNE _0x2040079
	ORI  R16,LOW(8)
	RJMP _0x204007A
_0x2040079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20400B8
_0x204007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x204007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x31
	LDI  R17,LOW(8)
	RJMP _0x2040077
_0x204007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x31
	LDI  R17,LOW(4)
_0x2040077:
	CPI  R20,0
	BREQ _0x204007D
	ANDI R16,LOW(127)
	RJMP _0x204007E
_0x204007D:
	LDI  R20,LOW(1)
_0x204007E:
	SBRS R16,1
	RJMP _0x204007F
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2B
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2040115
_0x204007F:
	SBRS R16,2
	RJMP _0x2040081
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x30
	CALL __CWD1
	RJMP _0x2040115
_0x2040081:
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x30
	CLR  R22
	CLR  R23
_0x2040115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2040083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2040084
	CALL SUBOPT_0x2E
	CALL __ANEGD1
	CALL SUBOPT_0x2C
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2040084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2040085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2040086
_0x2040085:
	ANDI R16,LOW(251)
_0x2040086:
_0x2040083:
	MOV  R19,R20
_0x204006F:
	SBRC R16,0
	RJMP _0x2040087
_0x2040088:
	CP   R17,R21
	BRSH _0x204008B
	CP   R19,R21
	BRLO _0x204008C
_0x204008B:
	RJMP _0x204008A
_0x204008C:
	SBRS R16,7
	RJMP _0x204008D
	SBRS R16,2
	RJMP _0x204008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x204008F
_0x204008E:
	LDI  R18,LOW(48)
_0x204008F:
	RJMP _0x2040090
_0x204008D:
	LDI  R18,LOW(32)
_0x2040090:
	CALL SUBOPT_0x27
	SUBI R21,LOW(1)
	RJMP _0x2040088
_0x204008A:
_0x2040087:
_0x2040091:
	CP   R17,R20
	BRSH _0x2040093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2040094
	CALL SUBOPT_0x32
	BREQ _0x2040095
	SUBI R21,LOW(1)
_0x2040095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2040094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x2A
	CPI  R21,0
	BREQ _0x2040096
	SUBI R21,LOW(1)
_0x2040096:
	SUBI R20,LOW(1)
	RJMP _0x2040091
_0x2040093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2040097
_0x2040098:
	CPI  R19,0
	BREQ _0x204009A
	SBRS R16,3
	RJMP _0x204009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x204009C
_0x204009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x204009C:
	CALL SUBOPT_0x27
	CPI  R21,0
	BREQ _0x204009D
	SUBI R21,LOW(1)
_0x204009D:
	SUBI R19,LOW(1)
	RJMP _0x2040098
_0x204009A:
	RJMP _0x204009E
_0x2040097:
_0x20400A0:
	CALL SUBOPT_0x33
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20400A2
	SBRS R16,3
	RJMP _0x20400A3
	SUBI R18,-LOW(55)
	RJMP _0x20400A4
_0x20400A3:
	SUBI R18,-LOW(87)
_0x20400A4:
	RJMP _0x20400A5
_0x20400A2:
	SUBI R18,-LOW(48)
_0x20400A5:
	SBRC R16,4
	RJMP _0x20400A7
	CPI  R18,49
	BRSH _0x20400A9
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20400A8
_0x20400A9:
	RJMP _0x20400AB
_0x20400A8:
	CP   R20,R19
	BRSH _0x2040116
	CP   R21,R19
	BRLO _0x20400AE
	SBRS R16,0
	RJMP _0x20400AF
_0x20400AE:
	RJMP _0x20400AD
_0x20400AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20400B0
_0x2040116:
	LDI  R18,LOW(48)
_0x20400AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20400B1
	CALL SUBOPT_0x32
	BREQ _0x20400B2
	SUBI R21,LOW(1)
_0x20400B2:
_0x20400B1:
_0x20400B0:
_0x20400A7:
	CALL SUBOPT_0x27
	CPI  R21,0
	BREQ _0x20400B3
	SUBI R21,LOW(1)
_0x20400B3:
_0x20400AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x33
	CALL __MODD21U
	CALL SUBOPT_0x2C
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x31
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20400A1
	RJMP _0x20400A0
_0x20400A1:
_0x204009E:
	SBRS R16,0
	RJMP _0x20400B4
_0x20400B5:
	CPI  R21,0
	BREQ _0x20400B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x2A
	RJMP _0x20400B5
_0x20400B7:
_0x20400B4:
_0x20400B8:
_0x2040054:
_0x2040114:
	LDI  R17,LOW(0)
_0x2040035:
	RJMP _0x2040030
_0x2040032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x34
	SBIW R30,0
	BRNE _0x20400B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2100004
_0x20400B9:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x34
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2100004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND
_bin2bcd:
; .FSTART _bin2bcd
	ST   -Y,R26
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret
; .FEND

	.CSEG

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x2100003
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x2100003:
	ADIW R28,4
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	RCALL SUBOPT_0x1A
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20E000D
	RCALL SUBOPT_0x35
	__POINTW2FN _0x20E0000,0
	CALL _strcpyf
	RJMP _0x2100002
_0x20E000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20E000C
	RCALL SUBOPT_0x35
	__POINTW2FN _0x20E0000,1
	CALL _strcpyf
	RJMP _0x2100002
_0x20E000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20E000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x37
	LDI  R30,LOW(45)
	ST   X,R30
_0x20E000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x20E0010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x20E0010:
	LDD  R17,Y+8
_0x20E0011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20E0013
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x39
	RJMP _0x20E0011
_0x20E0013:
	RCALL SUBOPT_0x3A
	CALL __ADDF12
	RCALL SUBOPT_0x36
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x39
_0x20E0014:
	RCALL SUBOPT_0x3A
	CALL __CMPF12
	BRLO _0x20E0016
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x39
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20E0017
	RCALL SUBOPT_0x35
	__POINTW2FN _0x20E0000,5
	CALL _strcpyf
	RJMP _0x2100002
_0x20E0017:
	RJMP _0x20E0014
_0x20E0016:
	CPI  R17,0
	BRNE _0x20E0018
	RCALL SUBOPT_0x37
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20E0019
_0x20E0018:
_0x20E001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20E001C
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x21
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x9
	MOV  R16,R30
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x24
	LDI  R31,0
	RCALL SUBOPT_0x38
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x36
	RJMP _0x20E001A
_0x20E001C:
_0x20E0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x2100001
	RCALL SUBOPT_0x37
	LDI  R30,LOW(46)
	ST   X,R30
_0x20E001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20E0020
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x36
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x24
	LDI  R31,0
	RCALL SUBOPT_0x3B
	CALL __CWD1
	CALL __CDF1
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x36
	RJMP _0x20E001E
_0x20E0020:
_0x2100001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2100002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.DSEG
_text:
	.BYTE 0x20
_edit_mode:
	.BYTE 0x6
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G107:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,LOW(-_Display*2)
	SBCI R31,HIGH(-_Display*2)
	LPM  R0,Z
	OUT  0x12,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,LOW(-_Display*2)
	SBCI R31,HIGH(-_Display*2)
	LPM  R0,Z
	OUT  0x12,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x2:
	CALL _lcd_clear
	LDI  R30,LOW(_text)
	LDI  R31,HIGH(_text)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_edit_mode
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1MN _edit_mode,1
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1MN _edit_mode,2
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1MN _edit_mode,3
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1MN _edit_mode,4
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1MN _edit_mode,5
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,24
	CALL _sprintf
	ADIW R28,28
	LDI  R26,LOW(_text)
	LDI  R27,HIGH(_text)
	CALL _lcd_puts
	JMP  _change_select_po

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x5:
	CALL _lcd_puts
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	JMP  _rtc_get_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x8:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL __DIVF21
	CALL __CFD1U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	LDI  R30,LOW(_text)
	LDI  R31,HIGH(_text)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xB:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(_text)
	LDI  R27,HIGH(_text)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	CALL _i2c_start
	LDI  R26,LOW(208)
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	CALL _i2c_start
	LDI  R26,LOW(209)
	CALL _i2c_write
	LDI  R26,LOW(1)
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	MOV  R26,R30
	CALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	CALL _i2c_write
	LD   R26,Y
	CALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	CALL _i2c_write
	LDD  R26,Y+1
	CALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	CALL _i2c_write
	LDD  R26,Y+2
	CALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1B:
	__GETD2S 4
	RCALL SUBOPT_0x8
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1C:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1E:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	RCALL SUBOPT_0x8
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x26:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x27:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x28:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x29:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2A:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2B:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2D:
	RCALL SUBOPT_0x28
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2F:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x30:
	RCALL SUBOPT_0x2B
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x32:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x37:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3A:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	__GETD2S 9
	RET


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
	.equ __i2c_port=0x15 ;PORTC
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
