/*
 * Copyright (C) 2006-2008 Free Software Foundation.  All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * See file LICENSE.txt for further informations on licensing terms.
 */

/* 
 * TODO: add Servo support using setPinMode(pin, SERVO);
 * TODO: use Program Control to load stored profiles from EEPROM
 */

#include <EEPROM.h>
#include <Firmata.h>

/*==============================================================================
 * MACROS
 *============================================================================*/



/*==============================================================================
 * GLOBAL VARIABLES
 *============================================================================*/

/* analog inputs */
int analogInputsToReport = 0; // bitwise array to store pin reporting
int analogPin = 0; // counter for reading analog pins

/* digital pins */
byte reportPINs[TOTAL_PORTS];   // PIN == input port
byte previousPINs[TOTAL_PORTS]; // PIN == input port
byte pinStatus[TOTAL_DIGITAL_PINS]; // store pin status, default OUTPUT

/* timer variables */
extern volatile unsigned long timer0_overflow_count; // timer0 from wiring.c
unsigned long nextExecuteTime; // for comparison with timer0_overflow_count


/*==============================================================================
 * FUNCTIONS                                                                
 *============================================================================*/

void outputPort(byte portNumber, byte portValue)
{
    if(previousPINs[portNumber] != portValue) {
        Firmata.sendDigitalPort(portNumber, portValue); 
        previousPINs[portNumber] = portValue;
        Firmata.sendDigitalPort(portNumber, portValue); 
    }
}

/* -----------------------------------------------------------------------------
 * check all the active digital inputs for change of state, then add any events
 * to the Serial output queue using Serial.print() */
void checkDigitalInputs(void) 
{
    byte i, tmp;
    for(i=0; i < TOTAL_PORTS; i++) {
        if(reportPINs[i]) {
            switch(i) {
            case 0: outputPort(0, PIND &~ B00000011); break; // ignore Rx/Tx 0/1
            case 1: outputPort(1, PINB); break;
            case ANALOG_PORT: outputPort(ANALOG_PORT, PINC); break;
            }
        }
    }
}

// -----------------------------------------------------------------------------
/* sets the pin mode to the correct state and sets the relevant bits in the
 * two bit-arrays that track Digital I/O and PWM status
 */
void setPinModeCallback(byte pin, int mode) {
    if(pin > 1) { // ignore RxTx pins (0,1)
        pinStatus[pin] = mode;
        switch(mode) {
        case INPUT:
        case OUTPUT:
            pinMode(pin, mode);
            break;
        case PWM:
            pinMode(pin,OUTPUT);
            break;
        default:
            Firmata.sendString("");
        }
        // TODO: save status to EEPROM here, if changed
    }
}

void analogWriteCallback(byte pin, int value)
{
    setPinModeCallback(pin,PWM);
    analogWrite(pin, value);
}

void digitalWriteCallback(byte port, int value)
{
    switch(port) {
    case 0: // pins 2-7  (0,1 are serial RX/TX, don't change their values)
        // 0xFF03 == B1111111100000011    0x03 == B00000011
        PORTD = (value &~ 0xFF03) | (PORTD & 0x03);
        break;
    case 1: // pins 8-13 (14,15 are disabled for the crystal) 
        PORTB = (byte)value;
        break;
    case 2: // analog pins used as digital
        PORTC = (byte)value;
        break;
    }
}

// -----------------------------------------------------------------------------
/* sets bits in a bit array (int) to toggle the reporting of the analogIns
 */
//void FirmataClass::setAnalogPinReporting(byte pin, byte state) {
//}
void reportAnalogCallback(byte pin, int value)
{
    if(value == 0) {
        analogInputsToReport = analogInputsToReport &~ (1 << pin);
    }
    else { // everything but 0 enables reporting of that pin
        analogInputsToReport = analogInputsToReport | (1 << pin);
    }
    // TODO: save status to EEPROM here, if changed
}

void reportDigitalCallback(byte port, int value)
{
    reportPINs[port] = (byte)value;
    if(port == ANALOG_PORT) // turn off analog reporting when used as digital
        analogInputsToReport = 0;
}

/*==============================================================================
 * SETUP()
 *============================================================================*/
void setup() 
{
    byte i;

    Firmata.setFirmwareVersion(2, 0);

    Firmata.attach(ANALOG_MESSAGE, analogWriteCallback);
    Firmata.attach(DIGITAL_MESSAGE, digitalWriteCallback);
    Firmata.attach(REPORT_ANALOG, reportAnalogCallback);
    Firmata.attach(REPORT_DIGITAL, reportDigitalCallback);
    Firmata.attach(SET_PIN_MODE, setPinModeCallback);

    for(i=0; i<TOTAL_DIGITAL_PINS; ++i) {
        setPinModeCallback(i,OUTPUT);
    }
    for(i=0; i<TOTAL_PORTS; ++i) {
        reportPINs[i] = false;
    }
    // TODO: load state from EEPROM here

    /* send digital inputs here, if enabled, to set the initial state on the
     * host computer, since once in the loop(), this firmware will only send
     * digital data on change. */
    if(reportPINs[0]) outputPort(0, PIND &~ B00000011); // ignore Rx/Tx 0/1
    if(reportPINs[1]) outputPort(1, PINB);
    if(reportPINs[ANALOG_PORT]) outputPort(ANALOG_PORT, PINC);

    Firmata.begin();
}

/*==============================================================================
 * LOOP()
 *============================================================================*/
void loop() 
{
/* DIGITALREAD - as fast as possible, check for changes and output them to the
 * FTDI buffer using Serial.print()  */
    checkDigitalInputs();  
    if(timer0_overflow_count > nextExecuteTime) {  
        nextExecuteTime = timer0_overflow_count + 19; // run this every 20ms
        /* SERIALREAD - Serial.read() uses a 128 byte circular buffer, so handle
         * all serialReads at once, i.e. empty the buffer */
        while(Firmata.available())
            Firmata.processInput();
        /* SEND FTDI WRITE BUFFER - make sure that the FTDI buffer doesn't go over
         * 60 bytes. use a timer to sending an event character every 4 ms to
         * trigger the buffer to dump. */
	
        /* ANALOGREAD - right after the event character, do all of the
         * analogReads().  These only need to be done every 4ms. */
        for(analogPin=0;analogPin<TOTAL_ANALOG_PINS;analogPin++) {
            if( analogInputsToReport & (1 << analogPin) ) 
                Firmata.sendAnalog(analogPin, analogRead(analogPin));
        }
    }
}
