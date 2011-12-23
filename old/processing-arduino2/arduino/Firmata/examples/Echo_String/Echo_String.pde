/* Copyright (C) 2008 Free Software Foundation.  All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * See file LICENSE.txt for further informations on licensing terms.
 */

/* This sketch accepts strings and raw sysex messages and echos them back.
 *
 * Written by Hans-Christoph Steiner <hans@eds.org>
 */
#include <Firmata.h>

byte analogPin;

void stringCallback(char *myString)
{
    Firmata.sendString(myString);
}


void sysexCallback(byte command, byte argc, byte*argv)
{
    Serial.print(START_SYSEX, BYTE);
    Serial.print(command, BYTE);
    for(byte i=0; i<argc; i++) {
        Serial.print(argv[i], BYTE);
    }
    Serial.print(END_SYSEX, BYTE);
}

void setup()
{
    Firmata.setFirmwareVersion(0, 1);
    Firmata.attach(FIRMATA_STRING, stringCallback);
    Firmata.attach(START_SYSEX, sysexCallback);
    Firmata.begin();
}

void loop()
{
    while(Firmata.available()) {
        Firmata.processInput();
    }
}


