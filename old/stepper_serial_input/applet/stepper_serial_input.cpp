#include <Stepper.h>

#define motorSteps 48     // change this depending on the number of steps
                           // per revolution of your motor
#define motorPin1 5
#define motorPin2 6
#define motorPin3 9
#define motorPin4 10
#define ledPin 13

#include "WProgram.h"
void setup();
void loop();
int val;

// initialize of the Stepper library:
Stepper myStepper(motorSteps, motorPin1,motorPin2,motorPin3,motorPin4);

void setup() {
  // set the motor speed at 60 RPMS:
  myStepper.setSpeed(60);

  // Initialize the Serial port:
  Serial.begin(9600);

  // set up the LED pin:
  pinMode(ledPin, OUTPUT);

}

void loop() {  

  // check if data has been sent from the computer
  if (Serial.available()) {
    // read the most recent byte (which will be from 0 to 255)
    val = Serial.read();
    // set the brightness of the LED
    myStepper.step(val); 
    
  }

}


int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

