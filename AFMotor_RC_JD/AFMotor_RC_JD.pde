

#include <AFMotor.h>

// DC motor on M2
AF_DCMotor motor(2);

int servo1 = 10;

int pulse_val1;  

int ledPin1 = 13;

void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps

  pinMode(servo1, INPUT); //Pin 2 as input
  pinMode(ledPin1, OUTPUT); //Pin 2 as input 

  // turn on motor #2
  motor.setSpeed(200);
  motor.run(RELEASE);
}

// Test the DC motor, stepper and servo ALL AT ONCE!
void loop() {

  pulse_val1 = pulseIn(servo1, HIGH);

    if (pulse_val1 > 1600) {
      //Forward
      motor.run(FORWARD);
      motor.setSpeed(255); 
      digitalWrite(ledPin1, LOW);
    }
    else if (pulse_val1 < 1400) {
      //REVERSE
      motor.run(BACKWARD);
      motor.setSpeed(255); 
      digitalWrite(ledPin1, LOW);
    }
    else {
      //STOP
      motor.run(RELEASE);
      motor.setSpeed(0); 
      digitalWrite(ledPin1, HIGH); // turn on neutral light, turn motor pins off
    }


    Serial.print("Pulse - ");
    Serial.print(pulse_val1);
    Serial.println("  "); 


}



