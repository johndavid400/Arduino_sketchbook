// Drive a unipolar stepper motor using (4) Tip122 BJT transistors and (4) 1k resistors.
// instead of using the standard digitalWrite, I used port manipulation for the increased switching speed times.
// 
int delayTime = 100;
int deadtime = 10;
int x_steps;

void setup(){
  Serial.begin(9600);
  pinMode(4,OUTPUT);
  pinMode(5,OUTPUT);
  pinMode(6,OUTPUT);
  pinMode(7,OUTPUT);
}

void loop() {
  while (Serial.available() > 0) {
    x_steps = Serial.parseInt();
    //Serial.print("x: ");
    //Serial.println(x_steps);
    motor_steps(x_steps); 
  }
  motor_stop();
}

void motor_steps(int steps){
  if (steps > 0){
    for (int x = 0; x < steps; x++){
      // turn on pin 7 
      PORTD = B10000000;
      delay(deadtime);
      // turn on pin 6    
      PORTD = B01000000;
      delay(deadtime);
      // turn on pin 5  
      PORTD = B00100000;
      delay(deadtime);
      // turn on pin 4
      PORTD = B00010000;
      Serial.println(x);
    }
    delay(delayTime);
    Serial.print("Forward: ");
  }
  else {
    for (int x = 0; x > steps; x--){
      // turn on pin 4
      PORTD = B00010000;
      delay(deadtime);
      // turn on pin 5  
      PORTD = B00100000;
      delay(deadtime);
      // turn on pin 6  
      PORTD = B01000000;
      delay(deadtime);
      // turn on pin 7  
      PORTD = B10000000;
      Serial.println(x);
    }
    delay(delayTime);
    Serial.print("Reverse: ");
  }
  Serial.println(x_steps);
}    

void motor_stop(){
  // turn all ports OFF
  PORTD = B00000000;
}



