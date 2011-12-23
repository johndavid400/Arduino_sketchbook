/*
 * MotorKnob
 *
 * A stepper motor follows the turns of a potentiometer
 * (or other sensor) on analog input 0.
 *
 * http://www.arduino.cc/en/Reference/Stepper
 */

#include <Stepper.h>

// change this to the number of steps on your motor
#define STEPS 48

// create an instance of the stepper class, specifying
// the number of steps of the motor and the pins it's
// attached to
#include "WProgram.h"
void setup();
void loop();
Stepper stepper(STEPS, 5, 6, 9, 10);

int fx = 7;
int val;
// the previous reading from the analog input
int previous = 0;

void setup()
{

  Serial.begin(9600);

  // set the speed of the motor to 30 RPMs
  stepper.setSpeed(30);

  pinMode(fx, INPUT);

}

void loop()
{

  // get the sensor value
  val = analogRead(1) / 2;

  if (digitalRead(fx) == HIGH) {

    // move a number of steps equal to the change in the
    // sensor reading
    stepper.step(val - previous);

    // remember the previous value of the sensor
    previous = val;
  }

  else {
    if (val > 260) {
      stepper.step(1);
      delay(255 - (val - 260));
    }
    else if (val < 250) {
      stepper.step(-1);
      delay(val);
    }
    else {
    }
  }


  Serial.print("val: ");
  Serial.print(val);
  Serial.print("        ");
  Serial.print("previous:");
  Serial.print(previous);
  Serial.println("          ");

}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

