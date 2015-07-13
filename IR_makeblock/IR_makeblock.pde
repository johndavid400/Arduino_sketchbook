// This code is intended to decode an Infrared helicopter remote using a standard IR receiver from Radio Shack
// This code is tested on the Makeblock orion
// JDW 2015

#include <Makeblock.h>
#include <Arduino.h>
#include <SoftwareSerial.h>
#include <Wire.h>

MeDCMotor MotorL(M1);
MeDCMotor MotorR(M2);

int ledPin = 13; // optional LED on pin 13
int pulse_pin = 2; // connect IR receiver - I used pin 21, but you can change this if using a regular Arduino, any pin will work.
int pulse_val = 0;
boolean reading = false;
int ir_array[20];
int n = 0;
int z = 0;
int speed_val = 0;
int turn_val = 0;
int m1_val = 0;
int m2_val = 0;

void setup() {
  // start serial monitor
  Serial.begin(9600);
  //led on arduino pin 13
  pinMode(ledPin, OUTPUT);
  // IR signal from helicopter controller
  pinMode(pulse_pin, INPUT);
}

void pulse(){
  pulse_val = pulseIn(pulse_pin, HIGH, 10000);
}

void booleanize(){
  // this function changes the pulse readings of 500 microseconds and 1100 microseconds (the only 2 pulse lengths I could detect) into 1 or 0 boolean values.
  if (pulse_val > 750){
    pulse_val = 1;
  }
  else {
    pulse_val = 0;
  }
}

void loop() {
  // get a pulse reading from the IR sensor
  pulse();
  // now check to see if it is above 0
  if (pulse_val > 0){
    digitalWrite(ledPin, HIGH);
    // if so, lets start reading the pulses
    reading = true;
    booleanize();
    // put each of the 20 or so readings into an array
    ir_array[n] = pulse_val;
    // cycle the counter up one to continue through the array
    n++;
  }
  // if the pulse is not greater than 0...
  else {
    // if this is the first 0 reading after a set of pulses, go ahead and close the set out and read the pulses
    if (reading == true){
      // check to make sure we got at least 18 of the 20 pulses
      if (n > 18){
        n = 0;
        // read and decode pulses
        decode_speed();
        // check for turn
        decode_turn();
        // check for button
        decode_button();
        // check and limit the signal so no bad value is written to the H-bridge (above 255)
        limit_signal();
        // finally, write the values to the motors
        write_motors();
        // another counter variable used for error correction
        z = 0;

        Serial.print("speed: ");
        Serial.print(speed_val);
        Serial.print("m1/m2: ");
        Serial.print(m1_val);
        Serial.print("/");
        Serial.println(m2_val);
      }
    }
    reading = false;
    z++;
    // make sure it has not received a signal in a few seconds before stopping.
    if (z > 50){
      m1_stop();
      m2_stop();
      z = 0;
    }
  }
  digitalWrite(ledPin, LOW);
}

void write_motors(){
  // check direction of m1_val and write appropriately
  if (m1_val > 0){
    m1_forward(m1_val);
  }
  else if (m1_val < 0){
    m1_reverse(-m1_val);
  }
  else {
    m1_stop();
  }
  // check direction of m2_val and write appropriately
  if (m2_val > 0){
    m2_forward(m2_val);
  }
  else if (m2_val < 0){
    m2_reverse(-m2_val);
  }
  else {
    m2_stop();
  }
}

void limit_signal(){
  if (m1_val > 255){
    m1_val = 255;
  }
  else if (m1_val < -255){
    m1_val = -255;
  }
  if (m2_val > 255){
    m2_val = 255;
  }
  else if (m2_val < -255){
    m2_val = -255;
  }
}

void decode_turn(){
  // turn
  if (ir_array[15] == 1){
    if (ir_array[16] == 1){
      if (ir_array[17] == 1){
        // left 1
        m2_val = speed_val / 2;
        m1_val = speed_val;
      }
      else {
        // left 2
        m2_val = 0;
        m1_val = speed_val * 2;
      }
    }
    else {
      // left 3
      m2_val = -speed_val;
      m1_val = speed_val;
    }
  }
  else {
    if (ir_array[16] == 1){
      if (ir_array[17] == 1){
        // right 3
        m2_val = speed_val;
        m1_val = -speed_val;
      }
      else {
        // right 2
        m2_val = speed_val * 2;
        m1_val = 0;
      }
    }
    else {
      if (ir_array[17] == 1){
        // right 1
        m2_val = speed_val;
        m1_val = speed_val / 2;
      }
      else {
        // no turn
        m1_val = speed_val;
        m2_val = speed_val;
      }
    }
  }
}

void decode_button(){
  // button

  if (ir_array[14] == 1){
    if (ir_array[13] == 1){
      // left button
      m1_val = -m1_val;
      m2_val = -m2_val;
    }
    else {
      // right button 
      m1_val = -m1_val;
      m2_val = -m2_val;
    }
  }


}

void decode_speed(){
  // speed 

  if (ir_array[7] == 1){
    if (ir_array[8] == 1){
      if (ir_array[9] == 1){
        //speed 13
        speed_val = 255;
      }
      else {
        if (ir_array[10] == 1){
          //speed 12
          speed_val = 240;
        }
        else{
          //speed 11
          speed_val = 220;
        }
      }
    }
    else {
      if (ir_array[9] == 1){
        if (ir_array[10] == 1){
          //speed 10
          speed_val = 200;
        }
        else{
          //speed 9
          speed_val = 180;
        }
      }
      else {
        if (ir_array[10] == 1){
          //speed 8
          speed_val = 160;
        }
        else{
          //speed 7
          speed_val = 140;
        }
      }
    }
  }
  else {
    if (ir_array[8] == 1){
      if (ir_array[9] == 1){
        if (ir_array[10] == 1){
          //speed 6
          speed_val = 120;
        }
        else{
          //speed 5
          speed_val = 100;
        }
      }
      else {
        if (ir_array[10] == 1){
          //speed 4
          speed_val = 80;
        }
        else{
          //speed 3
          speed_val = 60;
        }
      }
    }
    else{
      if (ir_array[10] == 1){
        //speed 2
        speed_val = 40;
      }
      else{
        //speed 1
        speed_val = 0;
      }
    }
  }
}

void m1_reverse(int x){
  // function for motor 1 reverse
  MotorL.run(-x);
}


void m1_forward(int x){
  // function for motor 1 forward
  MotorL.run(x);
}


void m1_stop(){
  // function for motor 1 stop
  MotorL.run(0);
}


void m2_forward(int y){
  // function for motor 2 forward
  MotorR.run(y);
}


void m2_reverse(int y){
  // function for motor 2 reverse
  MotorR.run(-y);
}


void m2_stop(){
  // function for motor 2 stop
  MotorR.run(0);
}

void motors_release(){
  MotorL.run(0);
  MotorR.run(0);
}

