#include <Stepper.h>

#define motorSteps 200     // change this depending on the number of steps
                           // per revolution of your motor
#define motorPin1 5
#define motorPin2 6
#define motorPin3 9
#define motorPin4 10
#define ledPin 13
#define potPin 0

int potVal = 0;

Stepper motor1(motorSteps, motorPin1,motorPin2,motorPin3,motorPin4); 

void setup() {

  motor1.setSpeed(750);

  // Initialize the Serial port:
  Serial.begin(9600);

  pinMode(potPin, INPUT);

}

void loop()
{

  potVal = analogRead(potPin) / 4;
  

  if (potVal < 118) {
    digitalWrite(ledPin, LOW);
    motor1.step(1);
    delay(potVal);
  }
  else if (potVal > 138) {
    digitalWrite(ledPin, LOW);    
    motor1.step(-1);
    delay(256 - potVal);
  }
  else {
    digitalWrite(ledPin, HIGH);
  }

  Serial.print ("potVal: ");
  Serial.print (potVal);  // if you turn on your serial monitor you can see the readings.
  Serial.println ("      "); 

}

