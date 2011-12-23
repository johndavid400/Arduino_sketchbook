/* Copyright (C) 2008 Free Software Foundation.  All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * See file LICENSE.txt for further informations on licensing terms.
 */

/* Supports as many analog inputs and analog PWM outputs as possible.
 *
 * Written by Hans-Christoph Steiner <hans@eds.org>
 */
#include <Firmata.h>

byte analogPin;

void analogWriteCallback(byte pin, int value)
{
    pinMode(pin,OUTPUT);
    analogWrite(pin, value);
}

void setup()
{
    Firmata.setFirmwareVersion(0, 1);
    Firmata.attach(ANALOG_MESSAGE, analogWriteCallback);
    Firmata.begin();
}

void loop()
{
    while(Firmata.available()) {
        Firmata.processInput();
    }
    for(analogPin = 0; analogPin < TOTAL_ANALOG_PINS; analogPin++) {
        Firmata.sendAnalog(analogPin, analogRead(analogPin)); 
    }
}


