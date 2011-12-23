
int back_right_sensor = 0;
int center_sensor = 0;
int front_right_sensor = 0;

int m2_AHS = 4;
int m2_ALS = 9;  // 5 or 9
int m2_BLS = 10;  // 6 or 10
int m2_BHS = 7;

int m1_AHS = 8;
int m1_ALS = 11;  // 9 or 11
int m1_BLS = 12; // 10 or 12
int m1_BHS = 13; // 11 or 13

int threshold = 20;

int speed1 = 64;
int speed2 = 108;
int speed3 = 144;
int speed4 = 192;
int speed5 = 255;

void setup(){

  TCCR1B = TCCR1B & 0b11111000 | 0x01;
  TCCR2B = TCCR2B & 0b11111000 | 0x01;


  Serial.begin(9600);

  pinMode(m1_AHS, OUTPUT);
  pinMode(m1_ALS, OUTPUT);
  pinMode(m1_BHS, OUTPUT);
  pinMode(m1_BLS, OUTPUT);

  pinMode(m2_AHS, OUTPUT);
  pinMode(m2_ALS, OUTPUT);
  pinMode(m2_BHS, OUTPUT);
  pinMode(m2_BLS, OUTPUT);

}


void loop(){

  gather();

  if (center_sensor <= 12) {
    m1_stop();
    m2_stop();
    delay(1000);
    m1_reverse(speed4);
    m2_forward(speed4);
    delay(700);
    m1_stop();
    m2_stop();
    delay(1000);
  }



  else {    

    if (front_right_sensor < 8){
      if (back_right_sensor < 8){
        m1_stop();
        m2_forward(speed3);

      }
      else if (back_right_sensor > 10){
        m1_stop();
        m2_forward(speed3);
      }
      else{
        m1_forward(speed2);
        m2_forward(speed4);
      }
    }

    else if (front_right_sensor > 10){
      if (back_right_sensor < 8){
        m1_forward(speed3);        
        m2_stop();
      }
      else if (back_right_sensor > 10){
        m1_forward(speed4);
        m2_stop();
      }
      else{
        m1_forward(speed4);        
        m2_forward(speed2);
      }
    }

    else {
      if (back_right_sensor > 10){
        m1_forward(speed2);
        m2_forward(speed3); 
      }
      else if (back_right_sensor < 8) {
        m1_forward(speed3);
        m2_forward(speed2);
      }
      else {
        m1_forward(speed4);
        m2_forward(speed4);
      }
    }

  }
  Serial.print(back_right_sensor);  
  Serial.print("          ");
  Serial.print(front_right_sensor);
  Serial.print("          ");
  Serial.print(center_sensor);
  Serial.println("          ");


}


void end_of_wall(){
  Serial.println("stopping");

  m1_stop();
  m2_stop();

  delay(100);

  Serial.println("blinking");

  digitalWrite(14, HIGH);
  delay(100);
  digitalWrite(14, LOW);
  delay(100);
  digitalWrite(14, HIGH);
  delay(100);
  digitalWrite(14, LOW);
  delay(100);
  digitalWrite(14, HIGH);
  delay(1000);
  digitalWrite(14, LOW);

  Serial.println("turning");

  m1_reverse(speed4);
  m2_forward(speed4);

  delay(750);

  Serial.println("updating sensors");

  gather();

  delay(100);

  Serial.println("exiting");
}


void gather(){

  back_right_sensor = analogRead(0) / 2.54;
  front_right_sensor = analogRead(1) / 2.54;
  center_sensor = analogRead(2) / 2.54;

}

void m1_reverse(int x){
  digitalWrite(m1_BHS, LOW);
  digitalWrite(m1_ALS, LOW);
  digitalWrite(m1_AHS, HIGH);
  analogWrite(m1_BLS, x);  
}

void m1_forward(int x){
  digitalWrite(m1_AHS, LOW);
  digitalWrite(m1_BLS, LOW);
  digitalWrite(m1_BHS, HIGH);
  analogWrite(m1_ALS, x);  
}

void m1_stop(){
  digitalWrite(m1_ALS, LOW);
  digitalWrite(m1_BLS, LOW);  
  digitalWrite(m1_AHS, HIGH);  // set A high-side HIGH 
  digitalWrite(m1_BHS, HIGH);  // also set B high-side HIGH to complete electric braking
}

void m2_forward(int y){
  digitalWrite(m2_AHS, LOW);
  digitalWrite(m2_BLS, LOW);
  digitalWrite(m2_BHS, HIGH);
  analogWrite(m2_ALS, y);
}

void m2_reverse(int y){
  digitalWrite(m2_BHS, LOW);
  digitalWrite(m2_ALS, LOW);
  digitalWrite(m2_AHS, HIGH);
  analogWrite(m2_BLS, y);  
}

void m2_stop(){
  digitalWrite(m2_ALS, LOW);
  digitalWrite(m2_BLS, LOW);  
  digitalWrite(m2_AHS, HIGH);  // set A high-side HIGH 
  digitalWrite(m2_BHS, HIGH);  // also set B high-side HIGH to complete electric braking
}

void motors_release(){

  // release all motors by opening every switch. The bot will coast or roll if on a hill.

  digitalWrite(m1_AHS, LOW);
  digitalWrite(m1_ALS, LOW);
  digitalWrite(m1_BHS, LOW);
  digitalWrite(m1_BLS, LOW); 

  digitalWrite(m2_AHS, LOW);
  digitalWrite(m2_ALS, LOW);
  digitalWrite(m2_BHS, LOW);
  digitalWrite(m2_BLS, LOW);  

}






















