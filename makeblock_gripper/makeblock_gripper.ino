
// declare inputs/outputs
int rc1 = 14;
int rc2 = 15;
int rc3 = 16;

int rc1_raw = 0;
int rc2_raw = 0;
int rc3_raw = 0;

int rc1_val = 0;
int rc2_val = 0;
int rc3_val = 0;

int m1_out = 0;
int m2_out = 0;
int m3_out = 0;
int m4_out = 0;

int M1L = 13;
int M1R = 12;
int M1P = 10;

int M2L = 8;
int M2R = 7;
int M2P = 9;

int M3L = 4;
int M3R = 2;
int M3P = 3;

int M4L = 6;
int M4R = 5;
int M4P = 11;

// some extra stuff
int deadband = 20;
int max_spd = 255;
int rc_min = 1500;
int rc_max = 2600;
int motor_speed = 0;
int motor_bias = 0;

void setup(){
  Serial.begin(9600);
  // inputs from 3ch R/C system
  pinMode(rc1, INPUT);
  pinMode(rc2, INPUT);
  pinMode(rc3, INPUT);
  // motor 1 - left drive motor
  pinMode(M1L, OUTPUT);
  pinMode(M1R, OUTPUT);
  pinMode(M1P, OUTPUT);
  // motor 2 - right drive motor
  pinMode(M2L, OUTPUT);
  pinMode(M2R, OUTPUT);
  pinMode(M2P, OUTPUT);
  // motor 3 - lift arm motor
  pinMode(M3L, OUTPUT);
  pinMode(M3R, OUTPUT);
  pinMode(M3P, OUTPUT);
  // motor 4 - gripper claw motor
  pinMode(M4L, OUTPUT);
  pinMode(M4R, OUTPUT);
  pinMode(M4P, OUTPUT);
}

void loop(){
  read_inputs();
  write_motors();
  print_stuff();
}

void read_inputs(){
  rc1_raw = pulseIn(rc1, HIGH, 20000);
  rc2_raw = pulseIn(rc2, HIGH, 20000);
  rc3_raw = pulseIn(rc3, HIGH, 20000);
  rc1_val = map(rc1_raw, rc_min, rc_max, -max_spd, max_spd);
  rc2_val = map(rc2_raw, rc_min, rc_max, -max_spd, max_spd);
  rc3_val = map(rc3_raw, 1300, 2600, -max_spd, max_spd);
}

void set_motors(){
  if (rc3_val > 0) {
    m1_out = rc1_val - rc2_val;
    m2_out = rc1_val + rc2_val;
    m3_out = 0;
    m4_out = 0;
  }
  else {
    m1_out = 0;
    m2_out = 0;
    m3_out = rc1_val;
    m4_out = rc2_val;
  }
}

void limit(){
  if (m1_out > max_spd){m1_out = max_spd;}
  else if (m1_out < -max_spd){m1_out = -max_spd;}
  if (m2_out > max_spd){m2_out = max_spd;}
  else if (m2_out < -max_spd){m2_out = -max_spd;}
  if (m3_out > max_spd){m3_out = max_spd;}
  else if (m3_out < -max_spd){m3_out = -max_spd;}
  if (m4_out > max_spd){m4_out = max_spd;}
  else if (m4_out < -max_spd){m4_out = -max_spd;}
} 

void write_motors(){
  set_motors();
  limit();
  if (rc3_val > 0) {
    if (m1_out > deadband) {left_forward();}
    else if (m1_out < -deadband) {left_reverse();}
    else {left_stop();}
    if (m2_out > deadband) {right_forward();}
    else if (m2_out < -deadband) {right_reverse();}
    else {right_stop();}
  }
  else {
    if (m3_out > deadband) {lift_forward();}
    else if (m3_out < -deadband) {lift_reverse();}
    else {lift_stop();}
    if (m4_out > deadband) {claw_forward();}
    else if (m4_out < -deadband) {claw_reverse();}
    else {claw_stop();}
  }
}

void print_stuff(){
 Serial.print("  RC 1: ");
 Serial.print(rc1_val);
 Serial.print("  RC 2: ");
 Serial.print(rc2_val);
 Serial.print("  RC 3: ");
 Serial.print(rc3_val);
 Serial.print("  Left: ");
 Serial.print(m1_out);
 Serial.print("  Right: ");
 Serial.print(m2_out);
 Serial.print("  Lift: ");
 Serial.print(m3_out);
 Serial.print("  Claw: ");
 Serial.print(m4_out);
 Serial.println("");
}

void left_forward(){
  digitalWrite(M1L, LOW);
  digitalWrite(M1R, HIGH);
  analogWrite(M1P, m1_out);
}
void left_reverse(){
  digitalWrite(M1R, LOW);
  digitalWrite(M1L, HIGH);
  analogWrite(M1P, -m1_out);
}
void left_stop(){
  digitalWrite(M1P, LOW);
}

void right_forward(){
  digitalWrite(M2L, LOW);
  digitalWrite(M2R, HIGH);
  analogWrite(M2P, m2_out);
}
void right_reverse(){
  digitalWrite(M2R, LOW);
  digitalWrite(M2L, HIGH);
  analogWrite(M2P, -m2_out);
}
void right_stop(){
  digitalWrite(M2P, LOW);
}

void lift_forward(){
  digitalWrite(M3L, LOW);
  digitalWrite(M3R, HIGH);
  analogWrite(M3P, m3_out);
}
void lift_reverse(){
  digitalWrite(M3R, LOW);
  digitalWrite(M3L, HIGH);
  analogWrite(M3P, -m3_out);
}
void lift_stop(){
  digitalWrite(M3P, LOW);
}

void claw_forward(){
  digitalWrite(M4L, LOW);
  digitalWrite(M4R, HIGH);
  analogWrite(M4P, m4_out);
}
void claw_reverse(){
  digitalWrite(M4R, LOW);
  digitalWrite(M4L, HIGH);
  analogWrite(M4P, -m4_out);
}
void claw_stop(){
  digitalWrite(M4P, LOW);
}

