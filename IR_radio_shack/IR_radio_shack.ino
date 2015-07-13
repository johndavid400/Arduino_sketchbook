// This code is intended to decode an Infrared helicopter remote using a standard IR receiver from Radio Shack using Interrupts
// This code is tested on an Arduino Mega
// JDW 2015
//
// binary codes transmitted by switches 1-8 respectively
// 00101101111
// 00101110111
// 00101111011
// 00101111101
// 00101111110
// 00101111111
// 00110101111
// 00110110111

#include <Makeblock.h>
#include <Arduino.h>
#include <SoftwareSerial.h>
#include <Wire.h>

MeDCMotor MotorL(M1);
MeDCMotor MotorR(M2);

int ledPin = 13;
int pulse_pin = 2;
int pulse_val = 0;
boolean reading = false;
String str = String("");
int z = 0;

void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  pinMode(pulse_pin, INPUT);
  Serial.println("Ready...");
}

void loop() {
  pulse();
  if (pulse_val > 0){
    digitalWrite(ledPin, HIGH);
    reading = true;
    booleanize();
    str = String(str + pulse_val);
  }
  else {
    if (reading == true){
      decode_signal();
      //z = 0;
      //serial_print_stuff();
    }
    reading = false;
    str = String("");
    //z++;
    //if (z > 50){z = 0;}
  }
  digitalWrite(ledPin, LOW);
}

void pulse(){
  pulse_val = pulseIn(pulse_pin, HIGH, 10000);
}

void booleanize(){
  if (pulse_val > 750){pulse_val = 1;}
  else {pulse_val = 0;}
}
void decode_signal(){
  if (str == String("00101101111")){Serial.println("Sw1"); forward();}
  if (str == String("00101110111")){Serial.println("Sw2"); left();}
  if (str == String("00101111011")){Serial.println("Sw3"); reverse();}
  if (str == String("00101111101")){Serial.println("Sw4"); right();}
  if (str == String("00101111110")){Serial.println("Sw5"); forward();}
  if (str == String("00101111111")){Serial.println("Sw6"); reverse();}
  if (str == String("00110101111")){Serial.println("Sw7"); left();}
  if (str == String("00110110111")){Serial.println("Sw8"); right();}
}

void forward(){
  MotorL.run(255);
  MotorR.run(255);
}
void reverse(){
  MotorL.run(-255);
  MotorR.run(-255);
}
void right(){
  MotorL.run(255);
  MotorR.run(-255);
}
void left(){
  MotorL.run(-255);
  MotorR.run(255);
}
void stop(){
  MotorL.run(0);
  MotorR.run(0);
}

void serial_print_stuff(){
  Serial.println(str);
}

