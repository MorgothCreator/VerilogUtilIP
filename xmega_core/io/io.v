/*
 * This IP is the Atmel IO headerfile definition.
 * 
 * Copyright (C) 2017  Iulian Gheorghiu
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

/*
--------------------------------------------------------------------------
TWI - Two-Wire Interface
--------------------------------------------------------------------------
*/

/* TWI - Two-Wire Interface */
`define TWI_CTRL			0
`define TWI_MASTER_CTRLA	1
`define TWI_MASTER_CTRLB	2
`define TWI_MASTER_CTRLC	3
`define TWI_MASTER_STATUS	4
`define TWI_MASTER_BAUD		5
`define TWI_MASTER_ADDR		6
`define TWI_MASTER_DATA		7
`define TWI_SLAVE_CTRLA		8
`define TWI_SLAVE_CTRLB		9
`define TWI_SLAVE_STATUS	10
`define TWI_SLAVE_ADDR		11
`define TWI_SLAVE_DATA		12
`define TWI_SLAVE_ADDRMASK	13

/* TWI - Two-Wire Interface */
/* SDA Hold Time */
`define TWI_SDAHOLD_OFF_gc				(0x00<<1)  /* SDA Hold Time off */
`define TWI_SDAHOLD_50NS_gc				(0x01<<1)  /* SDA Hold Time 50 ns */
`define TWI_SDAHOLD_300NS_gc			(0x02<<1)  /* SDA Hold Time 300 ns */
`define TWI_SDAHOLD_400NS_gc			(0x03<<1)  /* SDA Hold Time 400 ns */

/* Master Interrupt Level */
`define TWI_MASTER_INTLVL_OFF_gc		(0x00<<6)  /* Interrupt Disabled */
`define TWI_MASTER_INTLVL_LO_gc			(0x01<<6)  /* Low Level */
`define TWI_MASTER_INTLVL_MED_gc		(0x02<<6)  /* Medium Level */
`define TWI_MASTER_INTLVL_HI_gc			(0x03<<6)  /* High Level */

/* Inactive Timeout */
`define TWI_MASTER_TIMEOUT_DISABLED_gc	(0x00<<2)  /* Bus Timeout Disabled */
`define TWI_MASTER_TIMEOUT_50US_gc		(0x01<<2)  /* 50 Microseconds */
`define TWI_MASTER_TIMEOUT_100US_gc		(0x02<<2)  /* 100 Microseconds */
`define TWI_MASTER_TIMEOUT_200US_gc		(0x03<<2)  /* 200 Microseconds */

/* Master Command */
`define TWI_MASTER_CMD_NOACT_gc			(0x00<<0)  /* No Action */
`define TWI_MASTER_CMD_REPSTART_gc		(0x01<<0)  /* Issue Repeated Start Condition */
`define TWI_MASTER_CMD_RECVTRANS_gc		(0x02<<0)  /* Receive or Transmit Data */
`define TWI_MASTER_CMD_STOP_gc			(0x03<<0)  /* Issue Stop Condition */

/* Master Bus State */
`define TWI_MASTER_BUSSTATE_UNKNOWN_gc	(0x00<<0)  /* Unknown Bus State */
`define TWI_MASTER_BUSSTATE_IDLE_gc		(0x01<<0)  /* Bus is Idle */
`define TWI_MASTER_BUSSTATE_OWNER_gc	(0x02<<0)  /* This Module Controls The Bus */
`define TWI_MASTER_BUSSTATE_BUSY_gc		(0x03<<0)  /* The Bus is Busy */

/* Slave Interrupt Level */
`define TWI_SLAVE_INTLVL_OFF_gc			(0x00<<6)  /* Interrupt Disabled */
`define TWI_SLAVE_INTLVL_LO_gc			(0x01<<6)  /* Low Level */
`define TWI_SLAVE_INTLVL_MED_gc			(0x02<<6)  /* Medium Level */
`define TWI_SLAVE_INTLVL_HI_gc			(0x03<<6)  /* High Level */

/* Slave Command */
`define TWI_SLAVE_CMD_NOACT_gc			(0x00<<0)  /* No Action */
`define TWI_SLAVE_CMD_COMPTRANS_gc		(0x02<<0)  /* Used To Complete a Transaction */
`define TWI_SLAVE_CMD_RESPONSE_gc		(0x03<<0)  /* Used in Response to Address/Data Interrupt */


/* TWI_MASTER.CTRLA  bit masks and bit positions */
`define TWI_MASTER_INTLVL_gm  0xC0  /* Interrupt Level group mask. */
`define TWI_MASTER_INTLVL_gp  6  /* Interrupt Level group position. */
`define TWI_MASTER_INTLVL0_bm  (1<<6)  /* Interrupt Level bit 0 mask. */
`define TWI_MASTER_INTLVL0_bp  6  /* Interrupt Level bit 0 position. */
`define TWI_MASTER_INTLVL1_bm  (1<<7)  /* Interrupt Level bit 1 mask. */
`define TWI_MASTER_INTLVL1_bp  7  /* Interrupt Level bit 1 position. */

`define TWI_MASTER_RIEN_bm  0x20  /* Read Interrupt Enable bit mask. */
`define TWI_MASTER_RIEN_bp  5  /* Read Interrupt Enable bit position. */

`define TWI_MASTER_WIEN_bm  0x10  /* Write Interrupt Enable bit mask. */
`define TWI_MASTER_WIEN_bp  4  /* Write Interrupt Enable bit position. */

`define TWI_MASTER_ENABLE_bm  0x08  /* Enable TWI Master bit mask. */
`define TWI_MASTER_ENABLE_bp  3  /* Enable TWI Master bit position. */

/* TWI_MASTER.CTRLB  bit masks and bit positions */
`define TWI_MASTER_TIMEOUT_gm  0x0C  /* Inactive Bus Timeout group mask. */
`define TWI_MASTER_TIMEOUT_gp  2  /* Inactive Bus Timeout group position. */
`define TWI_MASTER_TIMEOUT0_bm  (1<<2)  /* Inactive Bus Timeout bit 0 mask. */
`define TWI_MASTER_TIMEOUT0_bp  2  /* Inactive Bus Timeout bit 0 position. */
`define TWI_MASTER_TIMEOUT1_bm  (1<<3)  /* Inactive Bus Timeout bit 1 mask. */
`define TWI_MASTER_TIMEOUT1_bp  3  /* Inactive Bus Timeout bit 1 position. */

`define TWI_MASTER_QCEN_bm  0x02  /* Quick Command Enable bit mask. */
`define TWI_MASTER_QCEN_bp  1  /* Quick Command Enable bit position. */

`define TWI_MASTER_SMEN_bm  0x01  /* Smart Mode Enable bit mask. */
`define TWI_MASTER_SMEN_bp  0  /* Smart Mode Enable bit position. */

/* TWI_MASTER.CTRLC  bit masks and bit positions */
`define TWI_MASTER_ACKACT_bm  0x04  /* Acknowledge Action bit mask. */
`define TWI_MASTER_ACKACT_bp  2  /* Acknowledge Action bit position. */

`define TWI_MASTER_CMD_gm  0x03  /* Command group mask. */
`define TWI_MASTER_CMD_gp  0  /* Command group position. */
`define TWI_MASTER_CMD0_bm  (1<<0)  /* Command bit 0 mask. */
`define TWI_MASTER_CMD0_bp  0  /* Command bit 0 position. */
`define TWI_MASTER_CMD1_bm  (1<<1)  /* Command bit 1 mask. */
`define TWI_MASTER_CMD1_bp  1  /* Command bit 1 position. */

/* TWI_MASTER.STATUS  bit masks and bit positions */
`define TWI_MASTER_RIF_bm  0x80  /* Read Interrupt Flag bit mask. */
`define TWI_MASTER_RIF_bp  7  /* Read Interrupt Flag bit position. */

`define TWI_MASTER_WIF_bm  0x40  /* Write Interrupt Flag bit mask. */
`define TWI_MASTER_WIF_bp  6  /* Write Interrupt Flag bit position. */

`define TWI_MASTER_CLKHOLD_bm  0x20  /* Clock Hold bit mask. */
`define TWI_MASTER_CLKHOLD_bp  5  /* Clock Hold bit position. */

`define TWI_MASTER_RXACK_bm  0x10  /* Received Acknowledge bit mask. */
`define TWI_MASTER_RXACK_bp  4  /* Received Acknowledge bit position. */

`define TWI_MASTER_ARBLOST_bm  0x08  /* Arbitration Lost bit mask. */
`define TWI_MASTER_ARBLOST_bp  3  /* Arbitration Lost bit position. */

`define TWI_MASTER_BUSERR_bm  0x04  /* Bus Error bit mask. */
`define TWI_MASTER_BUSERR_bp  2  /* Bus Error bit position. */

`define TWI_MASTER_BUSSTATE_gm  0x03  /* Bus State group mask. */
`define TWI_MASTER_BUSSTATE_gp  0  /* Bus State group position. */
`define TWI_MASTER_BUSSTATE0_bm  (1<<0)  /* Bus State bit 0 mask. */
`define TWI_MASTER_BUSSTATE0_bp  0  /* Bus State bit 0 position. */
`define TWI_MASTER_BUSSTATE1_bm  (1<<1)  /* Bus State bit 1 mask. */
`define TWI_MASTER_BUSSTATE1_bp  1  /* Bus State bit 1 position. */

/* TWI_SLAVE.CTRLA  bit masks and bit positions */
`define TWI_SLAVE_INTLVL_gm  0xC0  /* Interrupt Level group mask. */
`define TWI_SLAVE_INTLVL_gp  6  /* Interrupt Level group position. */
`define TWI_SLAVE_INTLVL0_bm  (1<<6)  /* Interrupt Level bit 0 mask. */
`define TWI_SLAVE_INTLVL0_bp  6  /* Interrupt Level bit 0 position. */
`define TWI_SLAVE_INTLVL1_bm  (1<<7)  /* Interrupt Level bit 1 mask. */
`define TWI_SLAVE_INTLVL1_bp  7  /* Interrupt Level bit 1 position. */

`define TWI_SLAVE_DIEN_bm  0x20  /* Data Interrupt Enable bit mask. */
`define TWI_SLAVE_DIEN_bp  5  /* Data Interrupt Enable bit position. */

`define TWI_SLAVE_APIEN_bm  0x10  /* Address/Stop Interrupt Enable bit mask. */
`define TWI_SLAVE_APIEN_bp  4  /* Address/Stop Interrupt Enable bit position. */

`define TWI_SLAVE_ENABLE_bm  0x08  /* Enable TWI Slave bit mask. */
`define TWI_SLAVE_ENABLE_bp  3  /* Enable TWI Slave bit position. */

`define TWI_SLAVE_PIEN_bm  0x04  /* Stop Interrupt Enable bit mask. */
`define TWI_SLAVE_PIEN_bp  2  /* Stop Interrupt Enable bit position. */

`define TWI_SLAVE_PMEN_bm  0x02  /* Promiscuous Mode Enable bit mask. */
`define TWI_SLAVE_PMEN_bp  1  /* Promiscuous Mode Enable bit position. */

`define TWI_SLAVE_SMEN_bm  0x01  /* Smart Mode Enable bit mask. */
`define TWI_SLAVE_SMEN_bp  0  /* Smart Mode Enable bit position. */

/* TWI_SLAVE.CTRLB  bit masks and bit positions */
`define TWI_SLAVE_ACKACT_bm  0x04  /* Acknowledge Action bit mask. */
`define TWI_SLAVE_ACKACT_bp  2  /* Acknowledge Action bit position. */

`define TWI_SLAVE_CMD_gm  0x03  /* Command group mask. */
`define TWI_SLAVE_CMD_gp  0  /* Command group position. */
`define TWI_SLAVE_CMD0_bm  (1<<0)  /* Command bit 0 mask. */
`define TWI_SLAVE_CMD0_bp  0  /* Command bit 0 position. */
`define TWI_SLAVE_CMD1_bm  (1<<1)  /* Command bit 1 mask. */
`define TWI_SLAVE_CMD1_bp  1  /* Command bit 1 position. */

/* TWI_SLAVE.STATUS  bit masks and bit positions */
`define TWI_SLAVE_DIF_bm  0x80  /* Data Interrupt Flag bit mask. */
`define TWI_SLAVE_DIF_bp  7  /* Data Interrupt Flag bit position. */

`define TWI_SLAVE_APIF_bm  0x40  /* Address/Stop Interrupt Flag bit mask. */
`define TWI_SLAVE_APIF_bp  6  /* Address/Stop Interrupt Flag bit position. */

`define TWI_SLAVE_CLKHOLD_bm  0x20  /* Clock Hold bit mask. */
`define TWI_SLAVE_CLKHOLD_bp  5  /* Clock Hold bit position. */

`define TWI_SLAVE_RXACK_bm  0x10  /* Received Acknowledge bit mask. */
`define TWI_SLAVE_RXACK_bp  4  /* Received Acknowledge bit position. */

`define TWI_SLAVE_COLL_bm  0x08  /* Collision bit mask. */
`define TWI_SLAVE_COLL_bp  3  /* Collision bit position. */

`define TWI_SLAVE_BUSERR_bm  0x04  /* Bus Error bit mask. */
`define TWI_SLAVE_BUSERR_bp  2  /* Bus Error bit position. */

`define TWI_SLAVE_DIR_bm  0x02  /* Read/Write Direction bit mask. */
`define TWI_SLAVE_DIR_bp  1  /* Read/Write Direction bit position. */

`define TWI_SLAVE_AP_bm  0x01  /* Slave Address or Stop bit mask. */
`define TWI_SLAVE_AP_bp  0  /* Slave Address or Stop bit position. */

/* TWI_SLAVE.ADDRMASK  bit masks and bit positions */
`define TWI_SLAVE_ADDRMASK_gm  0xFE  /* Address Mask group mask. */
`define TWI_SLAVE_ADDRMASK_gp  1  /* Address Mask group position. */
`define TWI_SLAVE_ADDRMASK0_bm  (1<<1)  /* Address Mask bit 0 mask. */
`define TWI_SLAVE_ADDRMASK0_bp  1  /* Address Mask bit 0 position. */
`define TWI_SLAVE_ADDRMASK1_bm  (1<<2)  /* Address Mask bit 1 mask. */
`define TWI_SLAVE_ADDRMASK1_bp  2  /* Address Mask bit 1 position. */
`define TWI_SLAVE_ADDRMASK2_bm  (1<<3)  /* Address Mask bit 2 mask. */
`define TWI_SLAVE_ADDRMASK2_bp  3  /* Address Mask bit 2 position. */
`define TWI_SLAVE_ADDRMASK3_bm  (1<<4)  /* Address Mask bit 3 mask. */
`define TWI_SLAVE_ADDRMASK3_bp  4  /* Address Mask bit 3 position. */
`define TWI_SLAVE_ADDRMASK4_bm  (1<<5)  /* Address Mask bit 4 mask. */
`define TWI_SLAVE_ADDRMASK4_bp  5  /* Address Mask bit 4 position. */
`define TWI_SLAVE_ADDRMASK5_bm  (1<<6)  /* Address Mask bit 5 mask. */
`define TWI_SLAVE_ADDRMASK5_bp  6  /* Address Mask bit 5 position. */
`define TWI_SLAVE_ADDRMASK6_bm  (1<<7)  /* Address Mask bit 6 mask. */
`define TWI_SLAVE_ADDRMASK6_bp  7  /* Address Mask bit 6 position. */

`define TWI_SLAVE_ADDREN_bm  0x01  /* Address Enable bit mask. */
`define TWI_SLAVE_ADDREN_bp  0  /* Address Enable bit position. */

/* TWI.CTRL  bit masks and bit positions */
`define TWI_SDAHOLD_gm  0x06  /* SDA Hold Time Enable group mask. */
`define TWI_SDAHOLD_gp  1  /* SDA Hold Time Enable group position. */
`define TWI_SDAHOLD0_bm  (1<<1)  /* SDA Hold Time Enable bit 0 mask. */
`define TWI_SDAHOLD0_bp  1  /* SDA Hold Time Enable bit 0 position. */
`define TWI_SDAHOLD1_bm  (1<<2)  /* SDA Hold Time Enable bit 1 mask. */
`define TWI_SDAHOLD1_bp  2  /* SDA Hold Time Enable bit 1 position. */

`define TWI_EDIEN_bm  0x01  /* External Driver Interface Enable bit mask. */
`define TWI_EDIEN_bp  0  /* External Driver Interface Enable bit position. */

/*
--------------------------------------------------------------------------
PORT - I/O Port Configuration
--------------------------------------------------------------------------
*/

/* PORT - I/O Ports */
`define PORT_DIR			0
`define PORT_DIRSET			1
`define PORT_DIRCLR			2
`define PORT_DIRTGL			3
`define PORT_OUT			4
`define PORT_OUTSET			5
`define PORT_OUTCLR			6
`define PORT_OUTTGL			7
`define PORT_IN				8
`define PORT_INTCTRL		9
`define PORT_INT0MASK		10
`define PORT_INT1MASK		11
`define PORT_INTFLAGS		12
`define PORT_REMAP			13
`define PORT_PIN0CTRL		16
`define PORT_PIN1CTRL		17
`define PORT_PIN2CTRL		18
`define PORT_PIN3CTRL		19
`define PORT_PIN4CTRL		20
`define PORT_PIN5CTRL		21
`define PORT_PIN6CTRL		22
`define PORT_PIN7CTRL		23

/* Port Interrupt 0 Level */
`define PORT_INT0LVL_OFF_gc			(0x00<<0)  /* Interrupt Disabled */
`define PORT_INT0LVL_LO_gc			(0x01<<0)  /* Low Level */
`define PORT_INT0LVL_MED_gc			(0x02<<0)  /* Medium Level */
`define PORT_INT0LVL_HI_gc			(0x03<<0)  /* High Level */

/* Port Interrupt 1 Level */
`define PORT_INT1LVL_OFF_gc			(0x00<<2)  /* Interrupt Disabled */
`define PORT_INT1LVL_LO_gc			(0x01<<2)  /* Low Level */
`define PORT_INT1LVL_MED_gc			(0x02<<2)  /* Medium Level */
`define PORT_INT1LVL_HI_gc			(0x03<<2)  /* High Level */

/* Output/Pull Configuration */
`define PORT_OPC_TOTEM_gc			(0x00<<3)  /* Totempole */
`define PORT_OPC_BUSKEEPER_gc		(0x01<<3)  /* Totempole w/ Bus keeper on Input and Output */
`define PORT_OPC_PULLDOWN_gc		(0x02<<3)  /* Totempole w/ Pull-down on Input */
`define PORT_OPC_PULLUP_gc			(0x03<<3)  /* Totempole w/ Pull-up on Input */
`define PORT_OPC_WIREDOR_gc			(0x04<<3)  /* Wired OR */
`define PORT_OPC_WIREDAND_gc		(0x05<<3)  /* Wired AND */
`define PORT_OPC_WIREDORPULL_gc		(0x06<<3)  /* Wired OR w/ Pull-down */
`define PORT_OPC_WIREDANDPULL_gc	(0x07<<3)  /* Wired AND w/ Pull-up */

/* Input/Sense Configuration */
`define PORT_ISC_BOTHEDGES_gc		(0x00<<0)  /* Sense Both Edges */
`define PORT_ISC_RISING_gc			(0x01<<0)  /* Sense Rising Edge */
`define PORT_ISC_FALLING_gc			(0x02<<0)  /* Sense Falling Edge */
`define PORT_ISC_LEVEL_gc			(0x03<<0)  /* Sense Level (Transparent For Events) */
`define PORT_ISC_INPUT_DISABLE_gc	(0x07<<0)  /* Disable Digital Input Buffer */

/* PORT - I/O Port Configuration */
/* PORT.INTCTRL  bit masks and bit positions */
`define PORT_INT1LVL_gm  0x0C  /* Port Interrupt 1 Level group mask. */
`define PORT_INT1LVL_gp  2  /* Port Interrupt 1 Level group position. */
`define PORT_INT1LVL0_bm  (1<<2)  /* Port Interrupt 1 Level bit 0 mask. */
`define PORT_INT1LVL0_bp  2  /* Port Interrupt 1 Level bit 0 position. */
`define PORT_INT1LVL1_bm  (1<<3)  /* Port Interrupt 1 Level bit 1 mask. */
`define PORT_INT1LVL1_bp  3  /* Port Interrupt 1 Level bit 1 position. */

`define PORT_INT0LVL_gm  0x03  /* Port Interrupt 0 Level group mask. */
`define PORT_INT0LVL_gp  0  /* Port Interrupt 0 Level group position. */
`define PORT_INT0LVL0_bm  (1<<0)  /* Port Interrupt 0 Level bit 0 mask. */
`define PORT_INT0LVL0_bp  0  /* Port Interrupt 0 Level bit 0 position. */
`define PORT_INT0LVL1_bm  (1<<1)  /* Port Interrupt 0 Level bit 1 mask. */
`define PORT_INT0LVL1_bp  1  /* Port Interrupt 0 Level bit 1 position. */

/* PORT.INTFLAGS  bit masks and bit positions */
`define PORT_INT1IF_bm  0x02  /* Port Interrupt 1 Flag bit mask. */
`define PORT_INT1IF_bp  1  /* Port Interrupt 1 Flag bit position. */

`define PORT_INT0IF_bm  0x01  /* Port Interrupt 0 Flag bit mask. */
`define PORT_INT0IF_bp  0  /* Port Interrupt 0 Flag bit position. */

/* PORT.REMAP  bit masks and bit positions */
`define PORT_SPI_bm  0x20  /* SPI bit mask. */
`define PORT_SPI_bp  5  /* SPI bit position. */

`define PORT_USART0_bm  0x10  /* USART0 bit mask. */
`define PORT_USART0_bp  4  /* USART0 bit position. */

`define PORT_TC0D_bm  0x08  /* Timer/Counter 0 Output Compare D bit mask. */
`define PORT_TC0D_bp  3  /* Timer/Counter 0 Output Compare D bit position. */

`define PORT_TC0C_bm  0x04  /* Timer/Counter 0 Output Compare C bit mask. */
`define PORT_TC0C_bp  2  /* Timer/Counter 0 Output Compare C bit position. */

`define PORT_TC0B_bm  0x02  /* Timer/Counter 0 Output Compare B bit mask. */
`define PORT_TC0B_bp  1  /* Timer/Counter 0 Output Compare B bit position. */

`define PORT_TC0A_bm  0x01  /* Timer/Counter 0 Output Compare A bit mask. */
`define PORT_TC0A_bp  0  /* Timer/Counter 0 Output Compare A bit position. */

/* PORT.PIN0CTRL  bit masks and bit positions */
`define PORT_SRLEN_bm  0x80  /* Slew Rate Enable bit mask. */
`define PORT_SRLEN_bp  7  /* Slew Rate Enable bit position. */

`define PORT_INVEN_bm  0x40  /* Inverted I/O Enable bit mask. */
`define PORT_INVEN_bp  6  /* Inverted I/O Enable bit position. */

`define PORT_OPC_gm  0x38  /* Output/Pull Configuration group mask. */
`define PORT_OPC_gp  3  /* Output/Pull Configuration group position. */
`define PORT_OPC0_bm  (1<<3)  /* Output/Pull Configuration bit 0 mask. */
`define PORT_OPC0_bp  3  /* Output/Pull Configuration bit 0 position. */
`define PORT_OPC1_bm  (1<<4)  /* Output/Pull Configuration bit 1 mask. */
`define PORT_OPC1_bp  4  /* Output/Pull Configuration bit 1 position. */
`define PORT_OPC2_bm  (1<<5)  /* Output/Pull Configuration bit 2 mask. */
`define PORT_OPC2_bp  5  /* Output/Pull Configuration bit 2 position. */

`define PORT_ISC_gm  0x07  /* Input/Sense Configuration group mask. */
`define PORT_ISC_gp  0  /* Input/Sense Configuration group position. */
`define PORT_ISC0_bm  (1<<0)  /* Input/Sense Configuration bit 0 mask. */
`define PORT_ISC0_bp  0  /* Input/Sense Configuration bit 0 position. */
`define PORT_ISC1_bm  (1<<1)  /* Input/Sense Configuration bit 1 mask. */
`define PORT_ISC1_bp  1  /* Input/Sense Configuration bit 1 position. */
`define PORT_ISC2_bm  (1<<2)  /* Input/Sense Configuration bit 2 mask. */
`define PORT_ISC2_bp  2  /* Input/Sense Configuration bit 2 position. */

/*
--------------------------------------------------------------------------
USART - Universal Asynchronous Receiver-Transmitter
--------------------------------------------------------------------------
*/

/* USART - Universal Synchronous/Asynchronous Receiver/Transmitter */
`define USART_DATA			0
`define USART_STATUS		1
`define USART_CTRLA			3
`define USART_CTRLB			4
`define USART_CTRLC			5
`define USART_BAUDCTRLA		6
`define USART_BAUDCTRLB		7

/* Receive Complete Interrupt level */
`define USART_RXCINTLVL_OFF_gc		(0x00<<4)  /* Interrupt Disabled */
`define USART_RXCINTLVL_LO_gc		(0x01<<4)  /* Low Level */
`define USART_RXCINTLVL_MED_gc		(0x02<<4)  /* Medium Level */
`define USART_RXCINTLVL_HI_gc		(0x03<<4)  /* High Level */

/* Transmit Complete Interrupt level */
`define USART_TXCINTLVL_OFF_gc		(0x00<<2)  /* Interrupt Disabled */
`define USART_TXCINTLVL_LO_gc		(0x01<<2)  /* Low Level */
`define USART_TXCINTLVL_MED_gc		(0x02<<2)  /* Medium Level */
`define USART_TXCINTLVL_HI_gc		(0x03<<2)  /* High Level */

/* Data Register Empty Interrupt level */
`define USART_DREINTLVL_OFF_gc		(0x00<<0)  /* Interrupt Disabled */
`define USART_DREINTLVL_LO_gc		(0x01<<0)  /* Low Level */
`define USART_DREINTLVL_MED_gc		(0x02<<0)  /* Medium Level */
`define USART_DREINTLVL_HI_gc		(0x03<<0)  /* High Level */

/* Character Size */
`define USART_CHSIZE_5BIT_gc		(0x00<<0)  /* Character size: 5 bit */
`define USART_CHSIZE_6BIT_gc		(0x01<<0)  /* Character size: 6 bit */
`define USART_CHSIZE_7BIT_gc		(0x02<<0)  /* Character size: 7 bit */
`define USART_CHSIZE_8BIT_gc		(0x03<<0)  /* Character size: 8 bit */
`define USART_CHSIZE_9BIT_gc		(0x07<<0)  /* Character size: 9 bit */

/* Communication Mode */
`define USART_CMODE_ASYNCHRONOUS_gc	(0x00<<6)  /* Asynchronous Mode */
`define USART_CMODE_SYNCHRONOUS_gc	(0x01<<6)  /* Synchronous Mode */
`define USART_CMODE_IRDA_gc			(0x02<<6)  /* IrDA Mode */
`define USART_CMODE_MSPI_gc			(0x03<<6)  /* Master SPI Mode */

/* Parity Mode */
`define USART_PMODE_DISABLED_gc		(0x00<<4)  /* No Parity */
`define USART_PMODE_EVEN_gc			(0x02<<4)  /* Even Parity */
`define USART_PMODE_ODD_gc			(0x03<<4)  /* Odd Parity */


/* USART - Universal Asynchronous Receiver-Transmitter */
/* USART.STATUS  bit masks and bit positions */
`define USART_RXCIF_bm  0x80  /* Receive Interrupt Flag bit mask. */
`define USART_RXCIF_bp  7  /* Receive Interrupt Flag bit position. */

`define USART_TXCIF_bm  0x40  /* Transmit Interrupt Flag bit mask. */
`define USART_TXCIF_bp  6  /* Transmit Interrupt Flag bit position. */

`define USART_DREIF_bm  0x20  /* Data Register Empty Flag bit mask. */
`define USART_DREIF_bp  5  /* Data Register Empty Flag bit position. */

`define USART_FERR_bm  0x10  /* Frame Error bit mask. */
`define USART_FERR_bp  4  /* Frame Error bit position. */

`define USART_BUFOVF_bm  0x08  /* Buffer Overflow bit mask. */
`define USART_BUFOVF_bp  3  /* Buffer Overflow bit position. */

`define USART_PERR_bm  0x04  /* Parity Error bit mask. */
`define USART_PERR_bp  2  /* Parity Error bit position. */

`define USART_RXB8_bm  0x01  /* Receive Bit 8 bit mask. */
`define USART_RXB8_bp  0  /* Receive Bit 8 bit position. */

/* USART.CTRLA  bit masks and bit positions */
`define USART_RXCINTLVL_gm  0x30  /* Receive Interrupt Level group mask. */
`define USART_RXCINTLVL_gp  4  /* Receive Interrupt Level group position. */
`define USART_RXCINTLVL0_bm  (1<<4)  /* Receive Interrupt Level bit 0 mask. */
`define USART_RXCINTLVL0_bp  4  /* Receive Interrupt Level bit 0 position. */
`define USART_RXCINTLVL1_bm  (1<<5)  /* Receive Interrupt Level bit 1 mask. */
`define USART_RXCINTLVL1_bp  5  /* Receive Interrupt Level bit 1 position. */

`define USART_TXCINTLVL_gm  0x0C  /* Transmit Interrupt Level group mask. */
`define USART_TXCINTLVL_gp  2  /* Transmit Interrupt Level group position. */
`define USART_TXCINTLVL0_bm  (1<<2)  /* Transmit Interrupt Level bit 0 mask. */
`define USART_TXCINTLVL0_bp  2  /* Transmit Interrupt Level bit 0 position. */
`define USART_TXCINTLVL1_bm  (1<<3)  /* Transmit Interrupt Level bit 1 mask. */
`define USART_TXCINTLVL1_bp  3  /* Transmit Interrupt Level bit 1 position. */

`define USART_DREINTLVL_gm  0x03  /* Data Register Empty Interrupt Level group mask. */
`define USART_DREINTLVL_gp  0  /* Data Register Empty Interrupt Level group position. */
`define USART_DREINTLVL0_bm  (1<<0)  /* Data Register Empty Interrupt Level bit 0 mask. */
`define USART_DREINTLVL0_bp  0  /* Data Register Empty Interrupt Level bit 0 position. */
`define USART_DREINTLVL1_bm  (1<<1)  /* Data Register Empty Interrupt Level bit 1 mask. */
`define USART_DREINTLVL1_bp  1  /* Data Register Empty Interrupt Level bit 1 position. */

/* USART.CTRLB  bit masks and bit positions */
`define USART_RXEN_bm  0x10  /* Receiver Enable bit mask. */
`define USART_RXEN_bp  4  /* Receiver Enable bit position. */

`define USART_TXEN_bm  0x08  /* Transmitter Enable bit mask. */
`define USART_TXEN_bp  3  /* Transmitter Enable bit position. */

`define USART_CLK2X_bm  0x04  /* Double transmission speed bit mask. */
`define USART_CLK2X_bp  2  /* Double transmission speed bit position. */

`define USART_MPCM_bm  0x02  /* Multi-processor Communication Mode bit mask. */
`define USART_MPCM_bp  1  /* Multi-processor Communication Mode bit position. */

`define USART_TXB8_bm  0x01  /* Transmit bit 8 bit mask. */
`define USART_TXB8_bp  0  /* Transmit bit 8 bit position. */

/* USART.CTRLC  bit masks and bit positions */
`define USART_CMODE_gm  0xC0  /* Communication Mode group mask. */
`define USART_CMODE_gp  6  /* Communication Mode group position. */
`define USART_CMODE0_bm  (1<<6)  /* Communication Mode bit 0 mask. */
`define USART_CMODE0_bp  6  /* Communication Mode bit 0 position. */
`define USART_CMODE1_bm  (1<<7)  /* Communication Mode bit 1 mask. */
`define USART_CMODE1_bp  7  /* Communication Mode bit 1 position. */

`define USART_PMODE_gm  0x30  /* Parity Mode group mask. */
`define USART_PMODE_gp  4  /* Parity Mode group position. */
`define USART_PMODE0_bm  (1<<4)  /* Parity Mode bit 0 mask. */
`define USART_PMODE0_bp  4  /* Parity Mode bit 0 position. */
`define USART_PMODE1_bm  (1<<5)  /* Parity Mode bit 1 mask. */
`define USART_PMODE1_bp  5  /* Parity Mode bit 1 position. */

`define USART_SBMODE_bm  0x08  /* Stop Bit Mode bit mask. */
`define USART_SBMODE_bp  3  /* Stop Bit Mode bit position. */

`define USART_CHSIZE_gm  0x07  /* Character Size group mask. */
`define USART_CHSIZE_gp  0  /* Character Size group position. */
`define USART_CHSIZE0_bm  (1<<0)  /* Character Size bit 0 mask. */
`define USART_CHSIZE0_bp  0  /* Character Size bit 0 position. */
`define USART_CHSIZE1_bm  (1<<1)  /* Character Size bit 1 mask. */
`define USART_CHSIZE1_bp  1  /* Character Size bit 1 position. */
`define USART_CHSIZE2_bm  (1<<2)  /* Character Size bit 2 mask. */
`define USART_CHSIZE2_bp  2  /* Character Size bit 2 position. */

/* USART.BAUDCTRLA  bit masks and bit positions */
`define USART_BSEL_gm  0xFF  /* Baud Rate Selection Bits [7:0] group mask. */
`define USART_BSEL_gp  0  /* Baud Rate Selection Bits [7:0] group position. */
`define USART_BSEL0_bm  (1<<0)  /* Baud Rate Selection Bits [7:0] bit 0 mask. */
`define USART_BSEL0_bp  0  /* Baud Rate Selection Bits [7:0] bit 0 position. */
`define USART_BSEL1_bm  (1<<1)  /* Baud Rate Selection Bits [7:0] bit 1 mask. */
`define USART_BSEL1_bp  1  /* Baud Rate Selection Bits [7:0] bit 1 position. */
`define USART_BSEL2_bm  (1<<2)  /* Baud Rate Selection Bits [7:0] bit 2 mask. */
`define USART_BSEL2_bp  2  /* Baud Rate Selection Bits [7:0] bit 2 position. */
`define USART_BSEL3_bm  (1<<3)  /* Baud Rate Selection Bits [7:0] bit 3 mask. */
`define USART_BSEL3_bp  3  /* Baud Rate Selection Bits [7:0] bit 3 position. */
`define USART_BSEL4_bm  (1<<4)  /* Baud Rate Selection Bits [7:0] bit 4 mask. */
`define USART_BSEL4_bp  4  /* Baud Rate Selection Bits [7:0] bit 4 position. */
`define USART_BSEL5_bm  (1<<5)  /* Baud Rate Selection Bits [7:0] bit 5 mask. */
`define USART_BSEL5_bp  5  /* Baud Rate Selection Bits [7:0] bit 5 position. */
`define USART_BSEL6_bm  (1<<6)  /* Baud Rate Selection Bits [7:0] bit 6 mask. */
`define USART_BSEL6_bp  6  /* Baud Rate Selection Bits [7:0] bit 6 position. */
`define USART_BSEL7_bm  (1<<7)  /* Baud Rate Selection Bits [7:0] bit 7 mask. */
`define USART_BSEL7_bp  7  /* Baud Rate Selection Bits [7:0] bit 7 position. */

/* USART.BAUDCTRLB  bit masks and bit positions */
`define USART_BSCALE_gm  0xF0  /* Baud Rate Scale group mask. */
`define USART_BSCALE_gp  4  /* Baud Rate Scale group position. */
`define USART_BSCALE0_bm  (1<<4)  /* Baud Rate Scale bit 0 mask. */
`define USART_BSCALE0_bp  4  /* Baud Rate Scale bit 0 position. */
`define USART_BSCALE1_bm  (1<<5)  /* Baud Rate Scale bit 1 mask. */
`define USART_BSCALE1_bp  5  /* Baud Rate Scale bit 1 position. */
`define USART_BSCALE2_bm  (1<<6)  /* Baud Rate Scale bit 2 mask. */
`define USART_BSCALE2_bp  6  /* Baud Rate Scale bit 2 position. */
`define USART_BSCALE3_bm  (1<<7)  /* Baud Rate Scale bit 3 mask. */
`define USART_BSCALE3_bp  7  /* Baud Rate Scale bit 3 position. */

/* USART_BSEL  Predefined. */
/* USART_BSEL  Predefined. */
/*
--------------------------------------------------------------------------
SPI - Serial Peripheral Interface
--------------------------------------------------------------------------
*/

/* SPI - Serial Peripheral Interface */
`define SPI_CTRL			0
`define SPI_INTCTRL			1
`define SPI_STATUS			2
`define SPI_DATA			3

/* SPI Mode */
`define SPI_MODE_0_gc			(0x00<<2)  /* SPI Mode 0 */
`define SPI_MODE_1_gc			(0x01<<2)  /* SPI Mode 1 */
`define SPI_MODE_2_gc			(0x02<<2)  /* SPI Mode 2 */
`define SPI_MODE_3_gc			(0x03<<2)  /* SPI Mode 3 */

/* Prescaler setting */
`define SPI_PRESCALER_DIV4_gc	(0x00<<0)  /* System Clock / 4 */
`define SPI_PRESCALER_DIV16_gc	(0x01<<0)  /* System Clock / 16 */
`define SPI_PRESCALER_DIV64_gc	(0x02<<0)  /* System Clock / 64 */
`define SPI_PRESCALER_DIV128_gc	(0x03<<0)  /* System Clock / 128 */

/* Interrupt level */
`define SPI_INTLVL_OFF_gc		(0x00<<0)  /* Interrupt Disabled */
`define SPI_INTLVL_LO_gc		(0x01<<0)  /* Low Level */
`define SPI_INTLVL_MED_gc		(0x02<<0)  /* Medium Level */
`define SPI_INTLVL_HI_gc		(0x03<<0)  /* High Level */

/* SPI - Serial Peripheral Interface */
/* SPI.CTRL  bit masks and bit positions */
`define SPI_CLK2X_bm  0x80  /* Enable Double Speed bit mask. */
`define SPI_CLK2X_bp  7  /* Enable Double Speed bit position. */

`define SPI_ENABLE_bm  0x40  /* Enable Module bit mask. */
`define SPI_ENABLE_bp  6  /* Enable Module bit position. */

`define SPI_DORD_bm  0x20  /* Data Order Setting bit mask. */
`define SPI_DORD_bp  5  /* Data Order Setting bit position. */

`define SPI_MASTER_bm  0x10  /* Master Operation Enable bit mask. */
`define SPI_MASTER_bp  4  /* Master Operation Enable bit position. */

`define SPI_MODE_gm  0x0C  /* SPI Mode group mask. */
`define SPI_MODE_gp  2  /* SPI Mode group position. */
`define SPI_MODE0_bm  (1<<2)  /* SPI Mode bit 0 mask. */
`define SPI_MODE0_bp  2  /* SPI Mode bit 0 position. */
`define SPI_MODE1_bm  (1<<3)  /* SPI Mode bit 1 mask. */
`define SPI_MODE1_bp  3  /* SPI Mode bit 1 position. */

`define SPI_PRESCALER_gm  0x03  /* Prescaler group mask. */
`define SPI_PRESCALER_gp  0  /* Prescaler group position. */
`define SPI_PRESCALER0_bm  (1<<0)  /* Prescaler bit 0 mask. */
`define SPI_PRESCALER0_bp  0  /* Prescaler bit 0 position. */
`define SPI_PRESCALER1_bm  (1<<1)  /* Prescaler bit 1 mask. */
`define SPI_PRESCALER1_bp  1  /* Prescaler bit 1 position. */

/* SPI.INTCTRL  bit masks and bit positions */
`define SPI_INTLVL_gm  0x03  /* Interrupt level group mask. */
`define SPI_INTLVL_gp  0  /* Interrupt level group position. */
`define SPI_INTLVL0_bm  (1<<0)  /* Interrupt level bit 0 mask. */
`define SPI_INTLVL0_bp  0  /* Interrupt level bit 0 position. */
`define SPI_INTLVL1_bm  (1<<1)  /* Interrupt level bit 1 mask. */
`define SPI_INTLVL1_bp  1  /* Interrupt level bit 1 position. */

/* SPI.STATUS  bit masks and bit positions */
`define SPI_IF_bm  0x80  /* Interrupt Flag bit mask. */
`define SPI_IF_bp  7  /* Interrupt Flag bit position. */

`define SPI_WRCOL_bm  0x40  /* Write Collision bit mask. */
`define SPI_WRCOL_bp  6  /* Write Collision bit position. */

