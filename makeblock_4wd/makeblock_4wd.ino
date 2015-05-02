
// declare R/C inputs
int rc_left = 16;
int rc_right = 17;
int rc_left_val = 0;
int rc_right_val = 0;

int deadband = 20;
int right_spd = 0;
int left_spd = 0;
int max_spd = 255;
int rc_min = 1000;
int rc_max = 2000;

int motor_left_a_pwm = 3;
int motor_left_a1 = 2;
int motor_left_a2 = 4;
int motor_left_b1 = 5;
int motor_left_b2 = 6;
int motor_left_b_pwm = 11;

int motor_right_a_pwm = 9;
int motor_right_a1 = 7;
int motor_right_a2 = 8;
int motor_right_b1 = 12;
int motor_right_b2 = 13;
int motor_right_b_pwm = 10;

void setup(){
  Serial.begin(9600);
  pinMode(INPUT, rc_left);
  pinMode(INPUT, rc_right);
  pinMode(OUTPUT, motor_left_a_pwm);
  pinMode(OUTPUT, motor_left_a1);
  pinMode(OUTPUT, motor_left_a2);
  pinMode(OUTPUT, motor_left_b1);
  pinMode(OUTPUT, motor_left_b2);
  pinMode(OUTPUT, motor_left_b_pwm);
  pinMode(OUTPUT, motor_right_a_pwm);
  pinMode(OUTPUT, motor_right_a1);
  pinMode(OUTPUT, motor_right_a2);
  pinMode(OUTPUT, motor_right_b1);
  pinMode(OUTPUT, motor_right_b2);
  pinMode(OUTPUT, motor_right_b_pwm);
  delay(1500);
}

void loop(){
  read_inputs();
  interpolate();
  write_motors();
  print_stuff();
}

void read_inputs(){
  rc_left_val = pulseIn(rc_left, HIGH, 20000);
  rc_right_val = pulseIn(rc_right, HIGH, 20000);
}

void interpolate(){
  left_spd = map(rc_left_val, rc_min, rc_max, -max_spd, max_spd);
  right_spd = map(rc_right_val, rc_min, rc_max, -max_spd, max_spd);
  limit();
}

void limit(){
  if (left_spd > max_spd){left_spd = max_spd;}
  else if (left_spd < -max_spd){left_spd = -max_spd;}
  if (right_spd > max_spd){right_spd = max_spd;}
  else if (right_spd < -max_spd){right_spd = -max_spd;}
}

void write_motors(){
  if (left_spd > deadband) {left_forward();}
  else if (left_spd < -deadband) {left_reverse();}
  else {left_stop();}
  if (right_spd > deadband) {right_forward();}
  else if (right_spd < -deadband) {right_reverse();}
  else {right_stop();}
}

void print_stuff(){
 Serial.print("  Left: ");
 Serial.print(rc_left_val);
 Serial.print("  Right: ");
 Serial.print(rc_right_val);
 Serial.println("");
}

void left_forward(){
  digitalWrite(motor_left_a1, LOW);
  digitalWrite(motor_left_a2, HIGH);
  digitalWrite(motor_left_b1, HIGH);
  digitalWrite(motor_left_b2, LOW);
  analogWrite(motor_left_a_pwm, left_spd);
  analogWrite(motor_left_b_pwm, left_spd);
}
void left_reverse(){
  digitalWrite(motor_left_a1, HIGH);
  digitalWrite(motor_left_a2, LOW);
  digitalWrite(motor_left_b1, LOW);
  digitalWrite(motor_left_b2, HIGH);
  analogWrite(motor_left_a_pwm, -left_spd);
  analogWrite(motor_left_b_pwm, -left_spd);
}
void left_stop(){
  digitalWrite(motor_left_a_pwm, LOW);
  digitalWrite(motor_left_b_pwm, LOW);
}

void right_forward(){
  digitalWrite(motor_right_a1, LOW);
  digitalWrite(motor_right_a2, HIGH);
  digitalWrite(motor_right_b1, HIGH);
  digitalWrite(motor_right_b2, LOW);
  analogWrite(motor_right_a_pwm, right_spd);
  analogWrite(motor_right_b_pwm, right_spd);
}
void right_reverse(){
  digitalWrite(motor_right_a1, HIGH);
  digitalWrite(motor_right_a2, LOW);
  digitalWrite(motor_right_b1, LOW);
  digitalWrite(motor_right_b2, HIGH);
  analogWrite(motor_right_a_pwm, -right_spd);
  analogWrite(motor_right_b_pwm, -right_spd);
}
void right_stop(){
  digitalWrite(motor_right_a_pwm, LOW);
  digitalWrite(motor_right_b_pwm, LOW);
}
