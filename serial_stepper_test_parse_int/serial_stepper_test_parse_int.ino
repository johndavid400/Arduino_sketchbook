// Drive a unipolar stepper motor using (4) Tip122 BJT transistors and (4) 1k resistors.
// instead of using the standard digitalWrite, I used port manipulation for the increased switching speed times.
// 

int s1 = 4;
int s3 = 5;
int s2 = 6;
int s4 = 7;

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
      digitalWrite(s1, HIGH);
      digitalWrite(s2, LOW);
      digitalWrite(s3, LOW);
      digitalWrite(s4, LOW);
      delay(deadtime);
      digitalWrite(s1, LOW);
      digitalWrite(s2, HIGH);
      digitalWrite(s3, LOW);
      digitalWrite(s4, LOW);
      delay(deadtime);
      digitalWrite(s1, LOW);
      digitalWrite(s2, LOW);
      digitalWrite(s3, HIGH);
      digitalWrite(s4, LOW);
      delay(deadtime);
      digitalWrite(s1, LOW);
      digitalWrite(s2, LOW);
      digitalWrite(s3, LOW);
      digitalWrite(s4, HIGH);
      delay(deadtime);
      Serial.println(x);
    }
    delay(delayTime);
    Serial.print("Forward: ");
  }
  else {
    for (int x = 0; x > steps; x--){
      digitalWrite(s4, HIGH);
      digitalWrite(s3, LOW);
      digitalWrite(s2, LOW);
      digitalWrite(s1, LOW);
      delay(deadtime);
      digitalWrite(s4, LOW);
      digitalWrite(s3, HIGH);
      digitalWrite(s2, LOW);
      digitalWrite(s1, LOW);
      delay(deadtime);
      digitalWrite(s4, LOW);
      digitalWrite(s3, LOW);
      digitalWrite(s2, HIGH);
      digitalWrite(s1, LOW);
      delay(deadtime);
      digitalWrite(s4, LOW);
      digitalWrite(s3, LOW);
      digitalWrite(s2, LOW);
      digitalWrite(s1, HIGH);
      delay(deadtime);
      Serial.println(x);
    }
    delay(delayTime);
    Serial.print("Reverse: ");
  }
  Serial.println(x_steps);
}    

void motor_stop(){
  digitalWrite(s4, LOW);
  digitalWrite(s3, LOW);
  digitalWrite(s2, LOW);
  digitalWrite(s1, LOW);
}



