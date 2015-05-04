
// declare R/C inputs
int rc_speed = 16;
int rc_turn = 17;

int rc_speed_val = 0;
int rc_turn_val = 0;

int deadband = 20;
int right_spd = 0;
int left_spd = 0;
int max_spd = 255;
int rc_min = 1050;
int rc_max = 1950;

int motor_speed = 0;
int motor_bias = 0;

int motor_left_pwm = 9;
int motor_left_dir_a = 7;
int motor_left_dir_b = 8;

int motor_right_pwm = 10;
int motor_right_dir_a = 11;
int motor_right_dir_b = 12;

void setup(){
  Serial.begin(9600);
  pinMode(INPUT, rc_speed);
  pinMode(INPUT, rc_turn);
  pinMode(OUTPUT, motor_left_pwm);
  pinMode(OUTPUT, motor_left_dir_a);
  pinMode(OUTPUT, motor_left_dir_b);
  pinMode(OUTPUT, motor_right_pwm);
  pinMode(OUTPUT, motor_right_dir_a);
  pinMode(OUTPUT, motor_right_dir_b);
  delay(500);
}

void loop(){
  read_inputs();
  interpolate();
  limit();
  write_motors();
  print_stuff();
}

void read_inputs(){
  rc_speed_val = pulseIn(rc_speed, HIGH, 20000);
  rc_turn_val = pulseIn(rc_turn, HIGH, 20000);
}

void interpolate(){
  motor_speed = map(rc_speed_val, rc_min, rc_max, -max_spd, max_spd);
  motor_bias = map(rc_turn_val, rc_min, rc_max, -max_spd, max_spd);
  left_spd = motor_speed - motor_bias;
  right_spd = motor_speed + motor_bias;
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
 Serial.print("  RC Speed: ");
 Serial.print(rc_speed_val);
 Serial.print("  RC Turn: ");
 Serial.print(rc_turn_val);
 Serial.print("  Left: ");
 Serial.print(left_spd);
 Serial.print("  Right: ");
 Serial.print(right_spd);
 Serial.println("");
}

void left_forward(){
  digitalWrite(motor_left_dir_a, LOW);
  digitalWrite(motor_left_dir_b, HIGH);
  analogWrite(motor_left_pwm, left_spd);
}
void left_reverse(){
  digitalWrite(motor_left_dir_a, HIGH);
  digitalWrite(motor_left_dir_b, LOW);
  analogWrite(motor_left_pwm, -left_spd);
}
void left_stop(){
  digitalWrite(motor_left_pwm, LOW);
}

void right_forward(){
  digitalWrite(motor_right_dir_a, LOW);
  digitalWrite(motor_right_dir_b, HIGH);
  analogWrite(motor_right_pwm, right_spd);
}
void right_reverse(){
  digitalWrite(motor_right_dir_a, HIGH);
  digitalWrite(motor_right_dir_b, LOW);
  analogWrite(motor_right_pwm, -right_spd);
}
void right_stop(){
  digitalWrite(motor_right_pwm, LOW);
}
