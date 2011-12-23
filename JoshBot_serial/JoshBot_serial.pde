

int M1_A = 12;
int M1_PWM = 11;
int M1_B = 10;

int M2_A = 4;
int M2_PWM = 3;
int M2_B = 2;

int LED = 13;

int incomingByte = 0;

void setup(){

  //TCCR2B = TCCR2B & 0b11111000 | 0x01; // set PWM frequency for pins 3 and 11 to 32kHz (pins 9 and 10 on Arduino Mega).

  Serial.begin(9600);

  pinMode(LED, OUTPUT);

  pinMode(M1_A, OUTPUT);
  pinMode(M1_PWM, OUTPUT);
  pinMode(M1_B, OUTPUT);

  pinMode(M2_A, OUTPUT);
  pinMode(M2_PWM, OUTPUT);
  pinMode(M2_B, OUTPUT);

  M1_stop();
  M2_stop();

  delay(500);

}

////////////////////////////////////

void loop(){

  if (Serial.available() > 0) {
    // read the incoming byte:
    incomingByte = Serial.read();

    digitalWrite(LED, HIGH);
    // say what you got:
    Serial.print("I received: ");
    Serial.println(incomingByte);
    delay(10);


    if (incomingByte == 105){
      M1_forward(255);
      M2_forward(255); 
      delay(25);
    }
    else if (incomingByte == 106){
      M1_reverse(255);
      M2_forward(255); 
      delay(25);
    }
    else if (incomingByte == 108){
      M1_forward(255);
      M2_reverse(255); 
      delay(25);
    }
    else if (incomingByte == 107){
      M1_reverse(255);
      M2_reverse(255); 
      delay(25);
    }
    else {
      M1_stop();
      M2_stop();
    }
  }

  else {
    M1_stop();
    M2_stop();
    digitalWrite(LED, LOW);
  }
}

/////////// motor functions ////////////////

void M1_reverse(int x){
  digitalWrite(M1_B, LOW);
  digitalWrite(M1_A, HIGH);
  analogWrite(M1_PWM, x); 
}

void M1_forward(int x){
  digitalWrite(M1_A, LOW);
  digitalWrite(M1_B, HIGH);
  analogWrite(M1_PWM, x); 
}

void M1_stop(){
  digitalWrite(M1_B, LOW);
  digitalWrite(M1_A, LOW);
  digitalWrite(M1_PWM, LOW); 
}

void M2_forward(int y){
  digitalWrite(M2_B, LOW);
  digitalWrite(M2_A, HIGH);
  analogWrite(M2_PWM, y); 
}

void M2_reverse(int y){
  digitalWrite(M2_A, LOW);
  digitalWrite(M2_B, HIGH);
  analogWrite(M2_PWM, y);  
}

void M2_stop(){
  digitalWrite(M2_B, LOW);
  digitalWrite(M2_A, LOW);
  digitalWrite(M2_PWM, LOW);
}







