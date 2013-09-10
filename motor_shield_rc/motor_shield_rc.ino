// Connect RC 1 to A0 and RC 2 to A1.
// Mount Arduino Motor Controller Shield


// declare motor pins
int dir_1 = 12;
int pwm_1 = 3;
int disable_1 = 9;

int dir_2 = 13;
int pwm_2 = 11;
int disable_2 = 8;

// create a threshold for neutral values - the higher this value, the larger the neutral band will be
int threshold = 20;

// set values for high and low R/C raw values
int rc1_low = 1250;
int rc1_high = 1730;
int rc2_low = 1250;
int rc2_high = 1750;

// declare R/C inputs
int rc1 = 16;  // use A2
int rc2 = 17;  // use A3

int rc1_val = 0;
int rc2_val = 0;

int rc1_speed = 0;
int rc2_speed = 0;

void setup(){
  Serial.begin(9600);
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
 limit_speed();
 write_motors();
 serial_print_stuff();
}

void read_rc(){
 // read and map rc1
 rc1_val = pulseIn(rc1, HIGH, 20000);
 if(rc1_val > 0){
   rc1_speed = map(rc1_val, rc1_low, rc1_high, -255, 255);
 }
 else{
   rc1_speed = 0;
 }
 // read and map rc2
 rc2_val = pulseIn(rc2, HIGH, 20000);
 if(rc2_val > 0){
   rc2_speed = map(rc2_val, rc2_low, rc2_high, -255, 255);
 }
 else{
   rc2_speed = 0;
 }
}

void serial_print_stuff(){
 // print values for rc1
 Serial.print(" RC1 Raw: ");
 Serial.print(rc1_val);
 Serial.print(" RC1 Adj: ");
 Serial.print(rc1_speed);
 // print values for rc1
 Serial.print(" RC2 Raw: ");
 Serial.print(rc2_val);
 Serial.print(" RC2 Adj: ");
 Serial.print(rc2_speed);
 // print new line
 Serial.println("");
}

void limit_speed(){
 if(rc1_speed > 255){
   rc1_speed = 255;
 }
 else if(rc1_speed < -255){
   rc1_speed = -255; 
 }
 if(rc2_speed > 255){
   rc2_speed = 255;
 }
 else if(rc2_speed < -255){
   rc2_speed = -255; 
 }
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
  digitalWrite(dir_1, LOW);
  analogWrite(pwm_1, rc1_speed);
}

void m1_reverse(){
  digitalWrite(dir_1, HIGH);
  analogWrite(pwm_1, -rc1_speed);
}

void m1_stop(){
  digitalWrite(pwm_1, LOW);
}

void m2_forward(){
  digitalWrite(dir_2, LOW);
  analogWrite(pwm_2, rc2_speed);
}
void m2_reverse(){ 
  digitalWrite(dir_2, HIGH);
  analogWrite(pwm_2, -rc2_speed);
}

void m2_stop(){
  digitalWrite(pwm_2, LOW);
}


