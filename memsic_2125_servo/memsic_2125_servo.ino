// www.prototyperobotics.com  -  JD Warren 2016
// Arduino Uno
// This code is for using the accelerometer and gyroscope sensors sold at Radio Shack
// Accelerometer - Memsic 2125 Dual-axis Accelerometer

// servo vals
int servo_pin = 4;
int servo_val = 1500;

// declare input pin for accelerometer
int accel = 7;

// variables for accelerometer
long accel_raw = 0;
int accel_low = 3500;
int accel_high = 6100;
int accel_avg = 0;
int accel_adj = 0;
int accel_angle = 0;

void setup(){
  Serial.begin(9600);
  pinMode(accel, INPUT);
  pinMode(servo_pin, OUTPUT);
}

void loop(){
  read_accel();
  write_servo();
}

void write_servo(){
  digitalWrite(servo_pin, HIGH);
  delayMicroseconds(accel_angle);
  digitalWrite(servo_pin, LOW);
}

void read_accel(){
  int sample_val = 7;
  accel_raw = 0;
  for (int x = 0; x < sample_val; x++){
    accel_raw = accel_raw + pulseIn(accel, HIGH);
  }
  accel_adj = accel_raw / sample_val;
  accel_angle = map(accel_adj, accel_low, accel_high, 2400, 600);
  Serial.print("Accel:  ");
  Serial.print(accel_raw);
  Serial.print("  ");
  Serial.println(accel_angle);
}


