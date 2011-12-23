#include <Stepper.h>

// change this to the number of steps on your motor
#define STEPS 100

// create an instance of the stepper class, specifying
// the number of steps of the motor and the pins it's
// attached to
#include "WProgram.h"
void setup();
void loop();
Stepper stepper(STEPS, 3, 4, 5, 6);

int disable_a = 10;
int disable_b = 9;

int previous = 10;
int val = 0;

void setup()
{
  
  Serial.begin(9600);
  
  // set the speed of the motor to 30 RPMs
  stepper.setSpeed(30);
  
  pinMode(disable_a, OUTPUT);
  pinMode(disable_b, OUTPUT);
  
}

/*
void loop()
{
  // get the sensor value
  int val = analogRead(0);

  // move a number of steps equal to the change in the
  // sensor reading
  stepper.step(val - previous);

  // remember the previous value of the sensor
  previous = val;
}
*/

void loop()
{
 
{
  byte val;

  // check if data has been sent from the computer
  if (Serial.available()) {
    // read the most recent byte (which will be from 0 to 255)
    val = Serial.read();
    // set the brightness of the LED
    stepper.step(1); 
    delay(val);
  }
    
    Serial.print("val :    ");
    Serial.print(val);
    Serial.println("          ");
    
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

