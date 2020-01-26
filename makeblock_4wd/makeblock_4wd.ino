
// declare R/C inputs
int rc_left = 14;
int rc_right = 15;
int rc_left_val = 0;
int rc_right_val = 0;

int deadband = 20;
int right_spd = 0;
int left_spd = 0;
int max_spd = 255;
int rc_min = 1100;
int rc_max = 1900;

// motor left rear
int motor_left_a_pwm = 3;
int motor_left_a1 = 2;
int motor_left_a2 = 4;

// motor left front
int motor_left_b1 = 8;
int motor_left_b2 = 7;
int motor_left_b_pwm = 9;

// motor right rear
int motor_right_a_pwm = 11;
int motor_right_a1 = 5;
int motor_right_a2 = 6;

// motor right front
int motor_right_b1 = 13;
int motor_right_b2 = 12;
int motor_right_b_pwm = 10;

void setup() {
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

void loop() {
  read_inputs();
  interpolate();
  write_motors();
  print_stuff();
}

void read_inputs() {
  rc_left_val = pulseIn(rc_left, HIGH);
  rc_right_val = pulseIn(rc_right, HIGH);
}

void interpolate() {
  if (rc_left_val > 500 && rc_right_val > 500) {
    left_spd = map(rc_left_val, rc_min, rc_max, -max_spd, max_spd);
    right_spd = map(rc_right_val, rc_min, rc_max, -max_spd, max_spd);
    limit();
  }
  else {
    left_spd = 0;
    right_spd = 0;
  }
}

void limit() {
  if (left_spd > max_spd) {
    left_spd = max_spd;
  }
  else if (left_spd < -max_spd) {
    left_spd = -max_spd;
  }
  if (right_spd > max_spd) {
    right_spd = max_spd;
  }
  else if (right_spd < -max_spd) {
    right_spd = -max_spd;
  }
}

void write_motors() {
  if (left_spd > deadband) {
    left_forward();
  }
  else if (left_spd < -deadband) {
    left_reverse();
  }
  else {
    left_stop();
  }
  if (right_spd > deadband) {
    right_forward();
  }
  else if (right_spd < -deadband) {
    right_reverse();
  }
  else {
    right_stop();
  }
}

void print_stuff() {
  //Serial.print("  Left: ");
  //Serial.print(rc_left_val);
  Serial.print(left_spd);
  //Serial.print("  Right: ");
  Serial.print("   :    ");
  //Serial.print(rc_right_val);
  Serial.print(right_spd);
  Serial.println("");
}

void left_forward() {
  digitalWrite(motor_left_a1, LOW);
  digitalWrite(motor_left_a2, HIGH);
  digitalWrite(motor_left_b1, HIGH);
  digitalWrite(motor_left_b2, LOW);
  analogWrite(motor_left_a_pwm, left_spd);
  analogWrite(motor_left_b_pwm, left_spd);
}
void left_reverse() {
  digitalWrite(motor_left_a1, HIGH);
  digitalWrite(motor_left_a2, LOW);
  digitalWrite(motor_left_b1, LOW);
  digitalWrite(motor_left_b2, HIGH);
  analogWrite(motor_left_a_pwm, -left_spd);
  analogWrite(motor_left_b_pwm, -left_spd);
}
void left_stop() {
  digitalWrite(motor_left_a_pwm, LOW);
  digitalWrite(motor_left_b_pwm, LOW);
}

void right_forward() {
  digitalWrite(motor_right_a1, LOW);
  digitalWrite(motor_right_a2, HIGH);
  digitalWrite(motor_right_b1, HIGH);
  digitalWrite(motor_right_b2, LOW);
  analogWrite(motor_right_a_pwm, right_spd);
  analogWrite(motor_right_b_pwm, right_spd);
}
void right_reverse() {
  digitalWrite(motor_right_a1, HIGH);
  digitalWrite(motor_right_a2, LOW);
  digitalWrite(motor_right_b1, LOW);
  digitalWrite(motor_right_b2, HIGH);
  analogWrite(motor_right_a_pwm, -right_spd);
  analogWrite(motor_right_b_pwm, -right_spd);
}
void right_stop() {
  digitalWrite(motor_right_a_pwm, LOW);
  digitalWrite(motor_right_b_pwm, LOW);
}
