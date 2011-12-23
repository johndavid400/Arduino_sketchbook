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

/* This firmware supports as many servos as possible. The "Servo" library from
 * http://www.arduino.cc/playground/ComponentLib/Servo is required.
 *
 * TODO add message to configure minPulse/maxPulse/degrees
 *
 * Written by Hans-Christoph Steiner <hans@eds.org>
 */
#include <Firmata.h>
#include <Servo.h>

#define  TOTAL_SERVOS    12  // pins 0,1 are dedicated to serial

/*==============================================================================
 * GLOBAL VARIABLES
 *============================================================================*/

// array of Servo instances
Servo servos[TOTAL_SERVOS];

/*==============================================================================
 * FUNCTIONS                                                                
 *============================================================================*/

void analogWriteCallback(byte pin, int value)
{
    // - 2 since pin 0 and 1 are dedicated to serial
    servos[pin - 2].write(value);
}

/*==============================================================================
 * SETUP()
 *============================================================================*/
void setup() 
{
    byte i;

    Firmata.setFirmwareVersion(0, 1);
    Firmata.attach(ANALOG_MESSAGE, analogWriteCallback);

    for(i=0; i<TOTAL_DIGITAL_PINS; ++i) {
        pinMode(i,OUTPUT);
    }
    for(i=0; i<TOTAL_SERVOS; ++i) {
        servos[i].attach(i + 2); // +2 since pin 0,1 are dedicated to serial
    }
    Firmata.begin();
}

/*==============================================================================
 * LOOP()
 *============================================================================*/
void loop() 
{
    while(Firmata.available())
        Firmata.processInput();
    Servo::refresh();
}

