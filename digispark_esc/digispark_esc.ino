
// declare inputs
int rc1 = 3;
int rc2 = 5;
int m1_dir = 0;
int m1_pwm = 1;
int m2_dir = 2;
int m2_pwm = 4;

// some extra stuff

int rc1_val = 0;
int rc2_val = 0;
int rc1_raw = 0;
int rc2_raw = 0;

int deadband = 20;
int max_spd = 255;
int rc_min = 1000;
int rc_max = 2000;

void setup(){
  Serial.begin(9600);
  pinMode(INPUT, rc1);
  pinMode(INPUT, rc2);
  pinMode(OUTPUT, m1_dir);
  pinMode(OUTPUT, m1_pwm);
  pinMode(OUTPUT, m2_dir);
  pinMode(OUTPUT, m2_pwm);
}

void loop(){
  read_pulses();
  set_motors();
}

void read_pulses(){
  rc1_raw = pulseIn(rc1, HIGH, 20000);
  rc2_raw = pulseIn(rc2, HIGH, 20000);
  rc1_val = map(rc1_raw, rc_min, rc_max, -max_spd, max_spd);
  rc2_val = map(rc2_raw, rc_min, rc_max, -max_spd, max_spd);
  if (rc1_val > 255){ rc1_val = 255; }
  else if (rc1_val < -255){ rc1_val = -255; }
  if (rc2_val > 255){ rc2_val = 255; }
  else if (rc2_val < -255){ rc2_val = -255; }
}

void set_motors(){
  if (rc1_val > deadband){ m1_forward(rc1_val); }
  else if (rc1_val < -deadband){ m1_reverse(-rc1_val); }
  else { m1_stop(); }

  if (rc2_val > deadband){ m2_forward(rc2_val); }
  else if (rc2_val < -deadband){ m2_reverse(-rc2_val); }
  else { m2_stop(); }
}

void m1_forward(int x){
  digitalWrite(m1_dir, HIGH);
  analogWrite(m1_pwm, x);
}
void m1_reverse(int x){
  digitalWrite(m1_dir, LOW);
  analogWrite(m1_pwm, x);
}
void m1_stop(){
  digitalWrite(m1_pwm, LOW);
}

void m2_forward(int x){
  digitalWrite(m2_dir, HIGH);
  analogWrite(m2_pwm, x);
}
void m2_reverse(int x){
  digitalWrite(m2_dir, LOW);
  analogWrite(m2_pwm, x);
}
void m2_stop(){
  digitalWrite(m2_pwm, LOW);
}

void serial_print_stuff(){
 Serial.print("  RC1 Raw: ");
 Serial.print(rc1_val);
 Serial.print("  RC2 Raw: ");
 Serial.print(rc2_val);
 Serial.println("");
}

