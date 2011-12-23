#include <AFMotor.h>

AF_Stepper motor(48, 1);

void setup() {
  Serial.begin(9600);   

  motor.setSpeed(100); 


  // begin the serial communication
  Serial.begin(9600);
}

void loop()
{
  byte val;

  // check if data has been sent from the computer
  if (Serial.available()) {
    // read the most recent byte (which will be from 0 to 255)
    val = Serial.read();
    // set the brightness of the LED
    motor.step(1, FORWARD, SINGLE); 
    delay(val);
  }
}
