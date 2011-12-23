#include <Stepper.h>

#define motorSteps 48     // change this depending on the number of steps
                           // per revolution of your motor
#define motorPin1 3
#define motorPin2 4
#define motorPin3 5
#define motorPin4 6
#define ledPin 13

// initialize of the Stepper library:
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

