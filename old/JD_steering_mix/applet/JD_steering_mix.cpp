// Decode 2 r/c signals using interrupts and 1 failsafe channel using pulseIn.
// The 2 motor channels have full 0-100% high-resolution pwm speed control
// The failsafe channel is polled, and outputs a digital HIGH/LOW. Suitable as a failsafe or auxillary channel.
// 
//  JD Warren 1-8-2010
//  www.rediculouslygoodlooking.com
// failsafe channel is currently used to toggle speed mode fast/slow.
// THIS CODE USES CHANNEL MIXING -- you need to use channel 1 up/down, and channel 2 left/right.

// This is the main code, it should run on the main processor.
// Read PPM signals from 2 channels of an RC reciever and convert the values to PWM in either direction.
// digital pins 5 & 9 control motor1, digital pins 6 & 10 control motor2. 
// DP 12 and 13 are neutral indicator lights. 
// DP 2 and 3 are inputs from the R/C receiver. 
// All analog pins are open. 
// When motor pin is HIGH, bridge is open.
// JDW 2009

// leave pins 0 and 1 open for serial communication

#include "WProgram.h"
void setup();
void ISR1_begin();
void ISR1_end();
void ISR2_begin();
void ISR2_end();
void loop();
int test();
void motor1_forward();
void motor2_forward();
void motor1_reverse();
void motor2_reverse();
void motor1_stop();
void motor2_stop();
void stop();
int ppm1 = 2; 
int ppm2 = 3;

int motor1_BHI = 7; 
int motor1_BLI = 6; 
int motor1_ALI = 5; 
int motor1_AHI = 4; 

int motor2_BHI = 11; 
int motor2_BLI = 10; 
int motor2_ALI = 9;
int motor2_AHI = 8;

int DIS = 14;  

int x;
int y;

int a;
int b;

int ledPin1 = 12;
int ledPin2 = 13;

volatile unsigned long servo1_start;
volatile unsigned servo1_val; 
int adj_val1;  
int servo1_Ready;

volatile unsigned long servo2_start;
volatile unsigned servo2_val; 
int adj_val2;  
int servo2_Ready;

int deadband_high = 275; 
int deadband_low = 235;  

int pwm_ceiling = 256; 
int pwm_floor = 255;  

int low1 = 1100;
int high1 = 1900;
int low2 = 1100;
int high2 = 1900;

void setup() {

  Serial.begin(9600);

  //TCCR1B = TCCR1B & 0b11111000 | 0x02;


  pinMode(DIS, OUTPUT);

  //motor1 pins
  pinMode(motor1_ALI, OUTPUT);
  pinMode(motor1_AHI, OUTPUT);
  pinMode(motor1_BLI, OUTPUT);
  pinMode(motor1_BHI, OUTPUT);

  //motor2 pins
  pinMode(motor2_ALI, OUTPUT);
  pinMode(motor2_AHI, OUTPUT);
  pinMode(motor2_BLI, OUTPUT);
  pinMode(motor2_BHI, OUTPUT);  

  //led's
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);

  //PPM inputs from RC receiver
  pinMode(ppm1, INPUT); //Pin 2 as input
  pinMode(ppm2, INPUT); //Pin 3 as input

  digitalWrite(DIS, HIGH);
  delay(1000);

  attachInterrupt(0, ISR1_begin, RISING);    // catch interrupt 0 (digital pin 2) going HIGH and send to rc1()
  attachInterrupt(1, ISR2_begin, RISING);    // catch interrupt 1 (digital pin 3) going HIGH and send to rc2()

  digitalWrite(DIS, LOW);

}

void ISR1_begin() {

  servo1_start = micros();

  detachInterrupt(0);

  attachInterrupt(0, ISR1_end, FALLING);

}

void ISR1_end() {

  servo1_val = micros() - servo1_start;

  detachInterrupt(0);

  if (servo1_val < 600 || servo1_val > 2400) {
    servo1_Ready = false; 
    servo1_val = 1500;
  }
  else {
    servo1_Ready = true; 
  }

  attachInterrupt(0, ISR1_begin, RISING); 

}


void ISR2_begin() {

  servo2_start = micros();

  detachInterrupt(1);

  attachInterrupt(1, ISR2_end, FALLING);

}

void ISR2_end() {

  servo2_val = micros() - servo2_start;

  detachInterrupt(1);

  if (servo2_val < 600 || servo2_val > 2400) {
    servo2_Ready = false; 
    servo2_val = 1500;
  }
  else {
    servo2_Ready = true; 
  }

  attachInterrupt(1, ISR2_begin, RISING); 

}


/////////////////////

void loop() {

  if (servo1_Ready) {

    servo1_Ready = false;  

    adj_val1 = map(servo1_val, low1, high1, 0, 511); 
    adj_val1 = constrain(adj_val1, 0, 511);

    x = adj_val1;

  }
  if (servo2_Ready) {

    servo2_Ready = false;

    adj_val2 = map(servo2_val ,low2, high2, 0, 511); 
    adj_val2 = constrain(adj_val2, 0, 511);

    y = adj_val2;

  }



  if (y > deadband_high) {  // go forward

    if (x > deadband_high) { // turn right
      a = y - pwm_ceiling;
      b = (y - pwm_ceiling) - (x - pwm_ceiling);
      test();
      motor1_forward();
      motor2_forward();
    }

    else if (x < deadband_low) {   // turn left
      a = (y - pwm_ceiling) - (pwm_floor - x);
      b = y - pwm_ceiling;
      test();
      motor1_forward();
      motor2_forward();
    }

    else {
      a = y - pwm_ceiling;
      b = y - pwm_ceiling;
      test();
      motor1_forward();
      motor2_forward();
    }
  }

  else if (y < deadband_low) {    // go backwards

    if (x > deadband_high) { // turn right
      a = pwm_floor - y;
      b = (pwm_floor - y) - (x - pwm_ceiling);
      test();
      motor1_reverse();
      motor2_reverse();
    }

    else if (x < deadband_low) {   // turn left
      a = (pwm_floor - y) - (pwm_floor - x);
      b = pwm_floor - y;
      test();
      motor1_reverse();
      motor2_reverse();   
    }			

    else {
      a = pwm_floor - y;
      b = pwm_floor - y;
      test();
      motor1_reverse();
      motor2_reverse();
    }

  }

  else {     // neutral, with a chance of donuts.

    if (x > deadband_high) {

      a = (x - pwm_ceiling) / 2;
      b = a;

      motor2_forward();
      motor1_reverse();

    }  

    else if (x < deadband_low) {

      a = (pwm_floor - x) / 2;
      b = a;

      motor2_reverse();
      motor1_forward();

    }  

    else {
      stop();
    }    

  }

/*
  Serial.print("ch1:  ");  //display the microsecond value of each pulse and it's adjusted value.
  Serial.print(a);
  Serial.print("  ");
  Serial.print("rc1:  ");
  Serial.print(servo1_val);
  Serial.print("  ");
  Serial.print("ch2:  ");
  Serial.print(b);
  Serial.print("  ");
  Serial.print("rc2:  ");
  Serial.print(servo2_val);
  Serial.print("  ");

  Serial.print("1:  "); 
  Serial.print(adj_val1);
  Serial.print("  ");    
  Serial.print("2:  "); 
  Serial.print(adj_val2);
  Serial.println("  ");    
*/


}



int test() {

  // make sure we don't try to write any invalid PWM values to the h-bridge, ie. above 255 or below 0.

  if (a > 254) {
    a = 255;
  }
  if (a < 1) {
    a = 0; 
  }
  if (b > 254) {
    b = 255;
  }
  if (b < 1) {
    b = 0; 
  } 

}


void motor1_forward() {
  digitalWrite(motor1_AHI, LOW);
  digitalWrite(motor1_BLI, LOW);
  digitalWrite(motor1_BHI, HIGH);
  analogWrite(motor1_ALI, adj_val1 - pwm_ceiling);
  digitalWrite(ledPin1, LOW);    
}

void motor2_forward() {
  digitalWrite(motor2_AHI, LOW);
  digitalWrite(motor2_BLI, LOW);
  digitalWrite(motor2_BHI, HIGH);
  analogWrite(motor2_ALI, adj_val2 - pwm_ceiling);   
  digitalWrite(ledPin2, LOW);     
}


void motor1_reverse() {
  digitalWrite(motor1_BHI, LOW);
  digitalWrite(motor1_ALI, LOW);
  digitalWrite(motor1_AHI, HIGH);
  analogWrite(motor1_BLI, pwm_floor - adj_val1); 
  digitalWrite(ledPin1, LOW);   
}

void motor2_reverse() {
  digitalWrite(motor2_BHI, LOW);
  digitalWrite(motor2_ALI, LOW);
  digitalWrite(motor2_AHI, HIGH);
  analogWrite(motor2_BLI, pwm_floor - adj_val2);  
  digitalWrite(ledPin2, LOW);  
}

void motor1_stop() {
  digitalWrite(motor1_BHI, LOW);
  digitalWrite(motor1_ALI, LOW);
  digitalWrite(motor1_AHI, LOW);
  digitalWrite(motor1_BLI, LOW);
  digitalWrite(ledPin1, HIGH);    

}

void motor2_stop() {

  digitalWrite(motor2_BHI, LOW);
  digitalWrite(motor2_ALI, LOW);
  digitalWrite(motor2_AHI, LOW);
  digitalWrite(motor2_BLI, LOW);
  digitalWrite(ledPin2, HIGH); 
}

void stop() {

  digitalWrite(motor1_BHI, LOW);
  digitalWrite(motor1_ALI, LOW);
  digitalWrite(motor1_AHI, LOW);
  digitalWrite(motor1_BLI, LOW);

  digitalWrite(motor2_BHI, LOW);
  digitalWrite(motor2_ALI, LOW);
  digitalWrite(motor2_AHI, LOW);
  digitalWrite(motor2_BLI, LOW);

  digitalWrite(ledPin1, HIGH);
  digitalWrite(ledPin2, HIGH); 

}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

