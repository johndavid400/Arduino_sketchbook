// Decode 2 r/c signals using interrupts and 1 failsafe channel using pulseIn.
// The 2 motor channels have full 0-100% high-resolution pwm speed control
// The failsafe channel is polled, and outputs a digital HIGH/LOW. Suitable as a failsafe or auxillary channel.
// 
//  JD Warren 1-8-2010
//  www.rediculouslygoodlooking.com
// failsafe channel is currently used to toggle speed mode fast/slow.
// THIS CODE USES CHANNEL MIXING -- you need to use channel 1 up/down, and channel 2 left/right.

int ppm1 = 2; 
int ppm2 = 6;
int ppm3 = 14;

int motor1_BHI = 7; 
int motor1_BLI = 3;  // PWM pin
int motor1_ALI = 11;  // PWM pin
int motor1_AHI = 8; 

int motor2_BHI = 5; 
int motor2_BLI = 10;   //PWM pin
int motor2_ALI = 9;  //PWM pin
int motor2_AHI = 4;

int ledPin1 = 12;
int ledPin2 = 13;

int current_sense_1;
int current_sense_2;

int current_limit = 25;  // sets the amperage limit that when exceeded on either motor, tells the motor driver to cut power to both motors for 1 second.

unsigned int servo1_val; 
int adj_val1;  
int servo1_Ready;

unsigned int servo2_val; 
int adj_val2;  
int servo2_Ready;

unsigned int servo3_val; 
int adj_val3;  
int servo3_Ready;

////////////////////////////////

int deadband_high = 275; 
int deadband_low = 235;  

int pwm_ceiling = 256; 
int pwm_floor = 255;  

// You can adjust these values to calibrate the code to your specific radio - check the Serial Monitor to see your values.
int low1 = 1100;
int high1 = 1900;
int low2 = 1100;
int high2 = 1900;

int x;
int y;

int a;
int b;

int speed_low;
int speed_high;

int incomingByte = 0;


void setup() {

  TCCR1B = TCCR1B & 0b11111000 | 0x01; // change PWM frequency on pins 9 and 10 to 32kHz
  TCCR2B = TCCR2B & 0b11111000 | 0x01; // change PWM frequency on pins 3 and 11 to 32kHz

  Serial.begin(9600);

  //motor1 pins
  pinMode(motor1_ALI, OUTPUT);
  pinMode(motor1_AHI, OUTPUT);
  pinMode(motor1_BLI, OUTPUT);
  pinMode(motor1_BHI, OUTPUT);

  //motor2 pins
  pinMode(motor2_ALI, OUTPUT);
  pinMode(motor2_AHI, OUTPUT);
  pinMode(motor2_BLI, OUTPUT);
  pinMode(motor2_BHI, OUTPUT);  

  //led's
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);

  //PPM inputs from RC receiver
  pinMode(ppm1, INPUT);
  pinMode(ppm2, INPUT); 
  pinMode(ppm3, INPUT);

}


void pulse(){

  servo1_val = pulseIn(ppm1, HIGH, 20000);

  if (servo1_val > 800 && servo1_val < 2200){	
    servo1_Ready = true;
  }
  else {
    servo1_Ready = false;
    servo1_val = 1500;
  }

  servo2_val = pulseIn(ppm2, HIGH, 20000);

  if (servo2_val > 800 && servo2_val < 2200){	
    servo2_Ready = true;
  }
  else {
    servo2_Ready = false;
    servo2_val = 1500;
  }

  servo3_val = pulseIn(ppm3, HIGH, 20000);

  if (servo3_val > 1600){
    speed_low = 0;
    speed_high = 511;
  }
  else{
    speed_low = 128;
    speed_high = 384; 
  }

}

void loop() {

  // read current sensors on motor-controller
  current_sense_1 = analogRead(1);
  current_sense_2 = analogRead(2);

  //////// determine which direction each motor is spinning

  if (current_sense_1 > 512){
    current_sense_1 = current_sense_1 - 512; 
  }
  else {
    current_sense_1 = 512 - current_sense_1;
  }

  if (current_sense_2 > 512){
    current_sense_2 = current_sense_2 - 512; 
  }
  else {
    current_sense_2 = 512 - current_sense_2;
  }  

  //////// adjust the directional value into Amperes

  current_sense_1 = current_sense_1 / 13.5;
  current_sense_2 = current_sense_2 / 13.5;

  //////// if either Ampere value is above the threshold, stop both motors for 1 second

  if (current_sense_1 > current_limit || current_sense_2 > current_limit){
    m1_stop();
    m2_stop();
    delay(1000);
  }

  ///////////////////////////////

  pulse();

  ///////////////////////////////

  if (servo1_Ready) {  

    // channel 1 

    adj_val1 = map(servo1_val, low1, high1, speed_low, speed_high);
    adj_val1 = constrain(adj_val1, speed_low, speed_high);

    if (adj_val1 > 511) {
      adj_val1 = 511; 
    }
    else if (adj_val1 < 0) {
      adj_val1 = 0; 
    }
    else {
    }

    x = adj_val1;

  }

  ///////////////////////////////

  if (servo2_Ready) {

    // channel 2 
    adj_val2 = map(servo2_val, low2, high2, speed_low, speed_high);
    adj_val2 = constrain(adj_val2, speed_low, speed_high);

    if (adj_val2 > 511) {
      adj_val2 = 511; 
    }
    else if (adj_val2 < 0) {
      adj_val2 = 0; 
    }
    else {
    }

    y = adj_val2;

  }

  //////////////////////////////

  // Process signals

  //////////////////////////////

  if (y > deadband_high) {  // go forward

    if (x > deadband_high) { // turn right
      a = y - pwm_ceiling;
      b = (y - pwm_ceiling) - (x - pwm_ceiling);
      test();
      m1_forward(a);
      m2_forward(b);
    }

    else if (x < deadband_low) {   // turn left
      a = (y - pwm_ceiling) - (pwm_floor - x);
      b = y - pwm_ceiling;
      test();
      m1_forward(a);
      m2_forward(b);
    }

    else {
      a = y - pwm_ceiling;
      b = y - pwm_ceiling;
      test();
      m1_forward(a);
      m2_forward(b);
    }
  }

  else if (y < deadband_low) {    // go backwards

    if (x > deadband_high) { // turn right
      a = pwm_floor - y;
      b = (pwm_floor - y) - (x - pwm_ceiling);
      test();
      m1_reverse(a);
      m2_reverse(b);
    }

    else if (x < deadband_low) {   // turn left
      a = (pwm_floor - y) - (pwm_floor - x);
      b = pwm_floor - y;
      test();
      m1_reverse(a);
      m2_reverse(b);   
    }			

    else {
      a = pwm_floor - y;
      b = pwm_floor - y;
      test();
      m1_reverse(a);
      m2_reverse(b);
    }

  }

  else {     // neutral, with a chance of donuts.

    if (x > deadband_high) {

      a = (x - pwm_ceiling);
      b = a;
      test();
      m2_forward(a);
      m1_reverse(b);

    }  

    else if (x < deadband_low) {

      a = (pwm_floor - x);
      b = a;
      test();
      m2_reverse(a);
      m1_forward(b);

    }  

    else {
      m1_stop();
      m2_stop();
    }


  }
}


void test() {
  // make sure we don't try to write any invalid PWM values to the h-bridge, ie. above 255 or below 0.
  if (a > 254) {
    a = 255;
  }
  if (a < 1) {
    a = 0; 
  }
  if (b > 254) {
    b = 255;
  }
  if (b < 1) {
    b = 0; 
  } 
}


void m1_forward(int m1_speed){
  digitalWrite(motor1_AHI, LOW);
  digitalWrite(motor1_BLI, LOW);
  digitalWrite(motor1_BHI, HIGH);
  analogWrite(motor1_ALI, m1_speed);
  digitalWrite(ledPin1, LOW);    
}

void m1_reverse(int m1_speed){
  digitalWrite(motor1_BHI, LOW);
  digitalWrite(motor1_ALI, LOW);
  digitalWrite(motor1_AHI, HIGH);
  analogWrite(motor1_BLI, m1_speed); 
  digitalWrite(ledPin1, LOW);
}

void m2_forward(int m2_speed){
  digitalWrite(motor2_AHI, LOW);
  digitalWrite(motor2_BLI, LOW);
  digitalWrite(motor2_BHI, HIGH);
  analogWrite(motor2_ALI, m2_speed);   
  digitalWrite(ledPin2, LOW); 
}

void m2_reverse(int m2_speed){
  digitalWrite(motor2_BHI, LOW);
  digitalWrite(motor2_ALI, LOW);
  digitalWrite(motor2_AHI, HIGH);
  analogWrite(motor2_BLI, m2_speed);  
  digitalWrite(ledPin2, LOW); 
} 

void m1_stop(){    
  digitalWrite(motor1_BHI, LOW);
  digitalWrite(motor1_ALI, LOW);
  digitalWrite(motor1_AHI, LOW);
  digitalWrite(motor1_BLI, LOW);
  digitalWrite(ledPin1, HIGH);
}

void m2_stop(){
  digitalWrite(motor2_BHI, LOW);
  digitalWrite(motor2_ALI, LOW);
  digitalWrite(motor2_AHI, LOW);
  digitalWrite(motor2_BLI, LOW);
  digitalWrite(ledPin2, HIGH);  
}




