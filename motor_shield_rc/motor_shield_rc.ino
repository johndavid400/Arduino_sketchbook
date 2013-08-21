
// Connect RC 1 to D2 and RC 2 to D4.
// Mount Arduino Motor Controller Shield


// declare motor pins
int dir_1 = 12;
int pwm_1 = 3;
int disable_1 = 9;

int dir_2 = 13;
int pwm_2 = 11;
int disable_2 = 8;

// create a threshold for neutral values - the higher this value, the larger the neutral band will be
int threshold = 10;

// declare R/C inputs
int rc1 = 2;
int rc2 = 4;

int rc1_val = 0;
int rc2_val = 0;

int rc1_speed = 0;
int rc2_speed = 0;

void setup(){
  // setup pins for motor controller
  pinMode(OUTPUT, dir_1);
  pinMode(OUTPUT, dir_2);
  pinMode(OUTPUT, pwm_1);
  pinMode(OUTPUT, pwm_2);
  pinMode(OUTPUT, disable_1);
  pinMode(OUTPUT, disable_2);
  // write the brake pins LOW so that we can control the motors
  digitalWrite(disable_1, LOW);
  digitalWrite(disable_2, LOW);
  // setup input pins for R/C
  pinMode(INPUT, rc1);
  pinMode(INPUT, rc2);
}

void loop(){
 read_rc();
 write_motors();
}

void read_rc(){
 // read and map rc1
 rc1_val = pulseIn(rc1, HIGH, 20000);
 rc1_speed = map(rc1_val, 1000, 2000, -255, 255);
 // read and map rc2
 rc2_val = pulseIn(rc1, HIGH, 20000);
 rc2_speed = map(rc2_val, 1000, 2000, -255, 255);
}

void write_motors(){
  if(rc1_speed > threshold){
    m1_forward();
  }
  else if(rc1_speed < -threshold){
    m1_reverse();
  }
  else{
    m1_stop(); 
  }
  
  if(rc2_speed > threshold){
    m2_forward();
  }
  else if(rc2_speed < -threshold){
    m2_reverse();
  }
  else{
    m2_stop(); 
  }  
}

void m1_forward(){
  digitalWrite(disable_1, LOW);
  digitalWrite(dir_1, LOW);
  analogWrite(pwm_1, rc1_speed);
}

void m1_reverse(){
  digitalWrite(disable_1, LOW);
  digitalWrite(dir_1, HIGH);
  analogWrite(pwm_1, -rc1_speed);
}

void m1_stop(){
  digitalWrite(pwm_1, LOW);
  digitalWrite(disable_1, HIGH);
}

void m2_forward(){
  digitalWrite(disable_2, LOW);
  digitalWrite(dir_2, LOW);
  analogWrite(pwm_2, rc2_speed);
}

void m2_reverse(){
  digitalWrite(disable_2, LOW);
  digitalWrite(dir_2, HIGH);
  analogWrite(pwm_2, -rc2_speed);
}

void m2_stop(){
  digitalWrite(pwm_2, LOW);
  digitalWrite(disable_2, HIGH);
}
