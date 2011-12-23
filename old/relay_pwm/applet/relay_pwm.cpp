//read PPM signals from 2 channels of an RC reciever and convert the values to PWM in either direction.
// DP 12 and 13 are neutral indicator lights. DP 2 and 3 are inputs from the R/C receiver using the two external interrupts on digital pins 2 and 3. All analog pins are open.


// this code is for RELAY control. The relays have 2 poles controlled by motorX_a/b. If LOW, both motor terminals are grounded. If HIGH, both motor terminals are at VSS (positive).
// This code will turn them both OFF in neutral, A = ON and = B OFF in FORWARD, and B = ON and A = OFF in REVERSE.
// PWM speed control comes from the Relay's supply to Ground. Instead of going directly to ground, the ground supply goes through several N-channel mosfets in parallel, driven by a tc4427 mosfet driver IC via digital pins 9 & 10 which are set to run at 32kHz.


#include "WProgram.h"
void setup();
void rc1();
void rc2();
void loop();
int motor1_a = 4;
int motor1_b = 7;
int motor1_pwm = 9;

int motor2_pwm = 10;
int motor2_b = 8;
int motor2_a = 11;


//Neutral indicator LED's (FWD and REV LED's are on the motor driver board.
int ledPin1 = 12;
int ledPin2 = 13;

int ppm1 = 2;  // connect the desired channel (PPM signal) from your RC receiver to digital pin 2 on Arduino.
int ppm2 = 3;

unsigned long rc1_PulseStartTicks;
volatile int rc1_val;  // store RC signal pulse length
int lastgood1;
int adj_val1;  // mapped value to be between 0-511
int rc1_InputReady;

unsigned long rc2_PulseStartTicks;
volatile int rc2_val;  // store RC signal pulse length
int lastgood2;
int adj_val2;  // mapped value to be between 0-511
int rc2_InputReady;

int deadband_high = 285; // set the desired deadband ceiling (ie. if adj_val is above this, you go forward)
int deadband_low = 225;  // set deadband floor (ie. below this, go backward)

int pwm_ceiling = 256; // adjusts speed of the PWM signal when it goes above the forward threshold (deadband_high). f(x) = adj_value1 (let's say it is max 511) - pwm_ceiling (256) = PWM write value (255)
int pwm_floor = 255;  // adjusts speed of the PWM signal when it goes below the reverese threshold (deadband_low). f(x) = pwm_floor (255) - adj_value1 (let's say it is min 0) = PWM write value (255)
 
int delta_val = 400; //this value sets the range for discarding unwanted signals.

void setup() {

	/*
	thanks to macegr
	Pins 9 and 10: controlled by timer 1

	Setting 	Divisor 	Frequency
	0x01 	 	1 	 	31250
	0x02 	 	8 	 	3906.25
	0x03  		64 	 	488.28125
	0x04  		256 	 	122.0703125
	0x05 	 	1024 	 	30.517578125

	TCCR1B = TCCR1B & 0b11111000 | <setting>;
	*/

	//TCCR1B = TCCR1B & 0b11111000 | 0x01;  // set the timer for PWM pins 9 & 10 to run at 32kHz

  Serial.begin(9600);

  // set all the other pins you're using as outputs:


  //motor1 pins
  pinMode(motor1_a, OUTPUT);
  pinMode(motor1_b, OUTPUT);
  pinMode(motor1_pwm, OUTPUT);
  
  pinMode(motor2_a, OUTPUT);
  pinMode(motor2_b, OUTPUT);
  pinMode(motor2_pwm, OUTPUT);

  //led's
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);

  //PPM inputs from RC receiver
  pinMode(ppm1, INPUT); //Pin 2 as input
  pinMode(ppm2, INPUT); //Pin 3 as input

  attachInterrupt(0, rc1, CHANGE);    // catch interrupt 0 (digital pin 2) going HIGH and send to rc1()
  attachInterrupt(1, rc2, CHANGE);    // catch interrupt 1 (digital pin 3) going HIGH and send to rc2()

 
  lastgood1 = 255; // default to neutral
  lastgood2 = 255;
  
}


void rc1()
{
  
  if (digitalRead( ppm1 ) == HIGH) // did the interrupt pin change to high or low?
  {
    rc1_PulseStartTicks = micros(); // store the current micros() value
  }
  else
  {
    rc1_val = micros() - rc1_PulseStartTicks; // Pin transitioned low, calculate the duration of the pulse
    rc1_InputReady = true; // Set flag for main loop to process the pulse
  }
}

void rc2()
{
  
  if (digitalRead( ppm2 ) == HIGH) // did the interrupt pin change to high or low?
  {
    rc2_PulseStartTicks = micros(); // store the current micros() value
  }
  else
  {
    rc2_val = micros() - rc2_PulseStartTicks;  // Pin transitioned low, calculate the duration of the pulse
    rc2_InputReady = true;   // Set flag for main loop to process the pulse
  }
}


void loop() {



//////////////////////////////////signal1
    if (rc1_InputReady)
  {
    // reset input flag
    rc1_InputReady = false;

    // constrain and map the pulse length
    adj_val1 = map(constrain(rc1_val, 1000, 2000), 1000, 2000, 0, 511);

    if (adj_val1 == 0){	    // if value is 0, use last good value
	adj_val1 = lastgood1;
    }
    else if (adj_val1 == 511){   // if value is 511, use last good value
	adj_val1 = lastgood1;
    }
    else if (((adj_val1 - lastgood1) * 2) > delta_val){   // make sure the new value is within a reasonable range of the last known good value.
	adj_val1 = lastgood1;
    }
    else {
	lastgood1 = adj_val1;   // if all conditions are met, use new value and set it as lastgood1 value.
    }

    // Update motor outputs.


///////// MOTOR1 /////////

  if (adj_val1 > deadband_high) {
    //Forward
    digitalWrite(motor1_b, LOW);
    digitalWrite(motor1_a, HIGH); //set relay to forward
    analogWrite(motor1_pwm, adj_val1 - pwm_ceiling); 
    digitalWrite(ledPin1, LOW);
  }
  else if (adj_val1 < deadband_low) {
    //REVERSE
    digitalWrite(motor1_a, LOW);
    digitalWrite(motor1_b, HIGH); //set relay to reverse
    analogWrite(motor1_pwm, pwm_floor - adj_val1); 
    digitalWrite(ledPin1, LOW);
  }
  else {
  //STOP
  digitalWrite(motor1_a, LOW);
  digitalWrite(motor1_b, LOW);
  digitalWrite(motor1_pwm, LOW);
  digitalWrite(ledPin1, HIGH); // turn on neutral light, turn motor pins off
 }


}

//////////////////////////////////signal2
    if (rc2_InputReady)
  {
    // reset input flag
    rc2_InputReady = false;

    // constrain and map the pulse length
    adj_val2 = map(constrain(rc2_val, 1000, 2000), 1000, 2000, 0, 511);

    if (adj_val2 == 0){	    // if value is 0, use last good value
	adj_val2 = lastgood2;
    }
    else if (adj_val2 == 511){   // if value is 511, use last good value
	adj_val2 = lastgood2;
    }
    else if (((adj_val2 - lastgood2) * 2) > delta_val){   // make sure the new value is within a reasonable range of the last known good value.
	adj_val2 = lastgood2;
    }
    else {
	lastgood2 = adj_val2;   // if all conditions are met, use new value and set it as lastgood1 value.
    }

    // Update motor outputs.

///////// MOTOR2 /////////
  if (adj_val2 > deadband_high) {
    //Forward
    digitalWrite(motor2_b, LOW);
    digitalWrite(motor2_a, HIGH); //set relay to forward
    analogWrite(motor2_pwm, adj_val2 - pwm_ceiling); 
    digitalWrite(ledPin2, LOW);
  }
  else if (adj_val2 < deadband_low) {
    //REVERSE
    digitalWrite(motor2_a, LOW);
    digitalWrite(motor2_b, HIGH); //set relay to reverse
    analogWrite(motor2_pwm, pwm_floor - adj_val2); 
    digitalWrite(ledPin2, LOW);
  }
  else {
  //STOP
  digitalWrite(motor2_a, LOW);
  digitalWrite(motor2_b, LOW);
  digitalWrite(motor2_pwm, LOW);
  digitalWrite(ledPin2, HIGH); // turn on neutral light, turn motor pins off
 }

}

/*
  //print values
  Serial.print("channel 1:  ");
  Serial.print(adj_val1);
  Serial.print("	  ");
  Serial.print("rc1_val raw:  ");
  Serial.print(rc1_val);
  Serial.print("	  ");
  Serial.print("channel 2:  ");
  Serial.print(adj_val2);
  Serial.print("	  ");
  Serial.print("rc2_val raw:  ");
  Serial.print(rc2_val);
  Serial.println("	  ");
*/

}


int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

