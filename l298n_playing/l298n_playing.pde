#include <Stepper.h>

// change this to the number of steps on your motor
#define STEPS 100

// create an instance of the stepper class, specifying
// the number of steps of the motor and the pins it's
// attached to
Stepper stepper(STEPS, 3, 4, 5, 6);

int m1 = 3;
int m2 = 4;
int m3 = 5;
int m4 = 6;
int led = 13;

// the previous reading from the analog input
int previous = 0;

void setup()
{

  // begin the serial communication
  Serial.begin(9600);

  pinMode(m1, OUTPUT);
  pinMode(m2, OUTPUT);
  pinMode(m3, OUTPUT);
  pinMode(m4, OUTPUT);
  pinMode(led, OUTPUT);

  // set the speed of the motor to 30 RPMs
  stepper.setSpeed(30);
}

void loop()
{

  Serial.print("on ");
  Serial.println("    ");

  digitalWrite(m1, HIGH);
  digitalWrite(m2, LOW);
  digitalWrite(m3, HIGH);
  digitalWrite(m4, LOW);
  digitalWrite(led, HIGH);

  delay(5000);

  Serial.print("off ");
  Serial.println("    ");

  digitalWrite(m1, LOW);
  digitalWrite(m2, HIGH);
  digitalWrite(m3, LOW);
  digitalWrite(m4, HIGH);
  digitalWrite(led, LOW);

  delay(5000);

}
