// Arduino plane
// JD Warren 2011
// r/c airplane glider made from poster foam-board, 2 micro-servos, 1 dc motor with propeller, an ardupilot, and 2.4ghz r/c rx.

// airplane is a 2 flap setup (elevons, I think?) where the two flaps can be operated opposite each other like ailerons, or in unison with each other as the elevator. 
// this code seeks to work elevator and ailerons into 2 control inputs on the r/c transmitter.

// inputs
int rc1 = 2;
int rc2 = 3;

// outputs
int servo_left = 9;
int servo_right = 10;

int mode_pin = 5;

// variables
int rc1_val;
int rc2_val;

int servo_left_val;
int servo_right_val;

int aileron;
int elevator;
int neutral = 1500;

void setup() {
  Serial.begin(9600);

  pinMode(rc1, INPUT);
  pinMode(rc2, INPUT);

  pinMode(servo_left, OUTPUT);
  pinMode(servo_right, OUTPUT);
  
  pinMode(mode_pin, OUTPUT);
  digitalWrite(mode_pin, LOW);
}


void read_rc() {
  elevator = pulseIn(rc2, HIGH, 20000);
  aileron = pulseIn(rc1, HIGH, 20000);
  
//  Serial.print(aileron);
//  Serial.print(" / ");
//  Serial.println(elevator);
}

void loop() {

  // read r/c signals
  read_rc();

  // mix servos for aileron and elevator
  if (elevator > 1700 || elevator < 1200){
    servo_left_val = 3000 - elevator;
    servo_right_val = elevator;
  }
  else {
    servo_left_val = aileron;
    servo_right_val = aileron;
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

