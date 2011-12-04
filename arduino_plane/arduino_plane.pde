// Arduino plane
// JD Warren 2011
// r/c airplane glider made from poster foam-board, 2 micro-servos, 1 dc motor with propeller, an ardupilot, and 2.4ghz r/c rx.

// airplane is a 2 flap setup (elevons, I think?) where the two flaps can be operated opposite each other like ailerons, or in unison
with each other as the elevator. 
// this code seeks to work elevator and ailerons into 2 control inputs on the r/c transmitter.

// inputs
int rc1 = 2;
int rc2 = 3;
int rc3 = 4;

// outputs
int servo_left = 5;
int servo_right = 6;
int prop_motor = 7;

// variables
int rc1_val;
int rc2_val;
int rc3_val;

int servo_left_val;
int servo_right_val;

int prop;
int prop_speed;
int prop_threshold;

int aileron;
int elevator;
int neutral = 1500;

void setup() {
  Serial.begin(9600);

  pinMode(rc1, INPUT);
  pinMode(rc2, INPUT); 
  pinMode(rc3, INPUT);

  pinMode(servo_left, OUTPUT);
  pinMode(servo_right, OUTPUT);
  pinMode(prop_motor, OUTPUT);
}


void read_rc() {
  prop = pulseIn(rc1, HIGH, 20000);
  prop_speed = map(prop, 1000, 2000, 0, 255);
  if (prop_speed < 0){
    prop_speed = 0;
  }
  else if (prop_speed > 255){
    prop_speed = 255;
  }

  aileron = pulseIn(rc2, HIGH, 20000);
  elevator = pulseIn(rc3, HIGH, 20000);
}

void loop() {

  // read r/c signals
  read_rc();

  // set Propeller speed
  if (prop_speed > prop_threshold){
    analogWrite(prop_motor, prop_speed);
  }
  else {
    digitalWrite(prop_motor, LOW);
  }

  // mix servos for aileron and elevator
  if (elevator > 1700 || elevator < 1200){
    servo_left_val = elevator;
    servo_right_val = elevator;
  }
  else {
    if (aileron > neutral) {
      servo_left_val = neutral - (aileron - neutral);
      servo_right_val = aileron;
    }
    else if (aileron < neutral){
      servo_left_val = (neutral - aileron) - neutral;
      servo_right_val = aileron;
    }
    else {
      servo_left_val = neutral;
      servo_right_val = neutral;
    }
  }
  write_servos();
}

void write_servos(){
  digitalWrite(servo_left, HIGH);
  delayMicroseconds(servo_left_val);
  digitalWrite(servo_left, LOW);

  digitalWrite(servo_right, servo_right_val);
  delayMicroseconds(servo_right_val);
  digitalWrite(servo_right, LOW);
}

