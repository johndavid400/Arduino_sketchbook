/*
 * Copyright (C) 2008 Free Software Foundation.  All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * See file LICENSE.txt for further informations on licensing terms.
 */

/* This firmware supports as many analog ports as possible, all analog inputs,
 * six PWM outputs, and the other six remaining digital pins are set up with
 * servo support.
 *
 * The "Servo" library from http://www.arduino.cc/playground/ComponentLib/Servo
 * is required.
 *
 * Written by Hans-Christoph Steiner <hans@eds.org>
 */
#include <Firmata.h>
#include <Servo.h>

/*==============================================================================
 * GLOBAL VARIABLES
 *============================================================================*/

/* servos */
Servo servo2, servo4, servo7, servo8, servo12, servo13; // one instance per pin
/* analog inputs */
int analogInputsToReport = 0; // bitwise array to store pin reporting
int analogPin = 0; // counter for reading analog pins
/* timer variables */
extern volatile unsigned long timer0_overflow_count; // timer0 from wiring.c
unsigned long nextExecuteTime; // for comparison with timer0_overflow_count


/*==============================================================================
 * FUNCTIONS                                                                
 *============================================================================*/

void analogWriteCallback(byte pin, int value)
{
    switch(pin) {
    case 2: servo2.write(value); break;
    case 4: servo4.write(value); break;
    case 7: servo7.write(value); break;
    case 8: servo8.write(value); break;
    case 12: servo12.write(value); break;
    case 13: servo13.write(value); break;
    case 3: 
    case 5: 
    case 6: 
    case 9: 
    case 10: 
    case 11: // PWM pins
        analogWrite(pin, value); 
        break;
    }
}
// -----------------------------------------------------------------------------
// sets bits in a bit array (int) to toggle the reporting of the analogIns
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

/*==============================================================================
 * SETUP()
 *============================================================================*/
void setup() 
{
    byte i;

    Firmata.setFirmwareVersion(0, 1);
    Firmata.attach(ANALOG_MESSAGE, analogWriteCallback);
    Firmata.attach(REPORT_ANALOG, reportAnalogCallback);

    for(i=0; i<TOTAL_DIGITAL_PINS; ++i) {
        pinMode(i,OUTPUT);
    }
    servo2.attach(2);
    servo4.attach(4);
    servo7.attach(7);
    servo8.attach(8);
    servo12.attach(12);
    servo13.attach(13);
    Firmata.begin();
}

/*==============================================================================
 * LOOP()
 *============================================================================*/
void loop() 
{
    while(Firmata.available())
        Firmata.processInput();
	
    if(timer0_overflow_count > nextExecuteTime) {  
        nextExecuteTime = timer0_overflow_count + 19; // run this every 20ms
        Servo::refresh();
        for(analogPin=0;analogPin<TOTAL_ANALOG_PINS;analogPin++) {
            if( analogInputsToReport & (1 << analogPin) ) 
                Firmata.sendAnalog(analogPin, analogRead(analogPin));
        }
    }
}

