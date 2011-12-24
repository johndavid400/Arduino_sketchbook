// RC Tank fast
// JDW 2011

int rc1 = 4;
int rc2 = 5;

int rc1_val = 0;
int rc2_val = 0;

int m1_val = 0;
int m2_val = 0;

int m2_A = 3;  // 9 on Arduino Mega
int m2_B = 11;  // 10 on Arduino Mega
int m1_A = 9;  // 11 on Arduino Mega
int m1_B = 10; // 12 on Ardiuno Mega

int deadband = 30;

void setup(){
  Serial.begin(9600);
  // IR signal from helicopter controller
  pinMode(rc1, INPUT);
  pinMode(rc2, INPUT);
  // set motor pins as outputs
  pinMode(m1_A, OUTPUT);
  pinMode(m1_B, OUTPUT);
  pinMode(m2_A, OUTPUT);
  pinMode(m2_B, OUTPUT);
}

void pulse(){
  rc2_val = pulseIn(rc2, HIGH, 20000);
  if (rc2_val > 2000 || rc2_val < 1000){
    rc2_val = 1500;
  }
  rc2_val = map(rc2_val, 1150, 1850, -255, 255);

  rc1_val = pulseIn(rc1, HIGH, 20000);
  if (rc1_val > 2000 || rc1_val < 1000){
    rc1_val = 1500;
  }
  rc1_val = map(rc1_val, 1150, 1850, -255, 255);

}

void check_pulses(){
  if (rc1_val > 255){
    rc1_val = 255;
  }
  else if (rc1_val < -255){
    rc1_val = -255;
  }
  if (rc2_val > 255){
    rc2_val = 255;
  }
  else if (rc2_val < -255){
    rc2_val = -255;
  }
}

void loop(){
  pulse();
  check_pulses();

  if (rc1_val > deadband){
    m1_forward(rc1_val);
  }
  else if (rc1_val < -deadband){
    m1_reverse(-rc1_val);
  }
  else {
    m1_stop();
  }

  if (rc2_val > deadband){
    m2_forward(rc2_val);
  }
  else if (rc2_val < -deadband){
    m2_reverse(-rc2_val);
  }
  else {
    m2_stop();
  }
  Serial.print(rc2_val);
  Serial.print("  ");
  Serial.println(rc1_val);
}


void m1_reverse(int x){
  digitalWrite(m1_B, LOW);
  analogWrite(m1_A, x);
}
void m1_forward(int x){
  digitalWrite(m1_A, LOW);
  analogWrite(m1_B, x);
}
void m1_stop(){
  digitalWrite(m1_A, LOW);
  digitalWrite(m1_B, LOW);
}
void m2_forward(int y){
  digitalWrite(m2_A, LOW);
  analogWrite(m2_B, y);
}
void m2_reverse(int y){
  digitalWrite(m2_B, LOW);
  analogWrite(m2_A, y);
}
void m2_stop(){
  digitalWrite(m2_A, LOW);
  digitalWrite(m2_B, LOW);
}



