#include <Stepper.h>

#define motorSteps 48     // change this depending on the number of steps
                           // per revolution of your motor
#define motorPin1 5
#define motorPin2 6
#define motorPin3 9
#define motorPin4 10
#define ledPin 13

// initialize of the Stepper library:
#include "WProgram.h"
void setup();
void loop();
void blink(int howManyTimes);
Stepper myStepper(motorSteps, motorPin1,motorPin2,motorPin3,motorPin4);

void setup() {
  // set the motor speed at 60 RPMS:
  myStepper.setSpeed(60);

  // Initialize the Serial port:
  Serial.begin(9600);

  // set up the LED pin:
  pinMode(ledPin, OUTPUT);
  // blink the LED:
  blink(3);
}

void loop() {
  // Step forward 100 steps:
  Serial.println("Forward");
  myStepper.step(100);
  delay(500);

  // Step backward 100 steps:
  Serial.println("Backward");
  myStepper.step(-100);
  delay(500); 

}

// Blink the reset LED:
void blink(int howManyTimes) {
  int i;
  for (i=0; i< howManyTimes; i++) {
    digitalWrite(ledPin, HIGH);
    delay(200);
    digitalWrite(ledPin, LOW);
    delay(200);
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

