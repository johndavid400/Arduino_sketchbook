// ServoDecodeTest

#include <ServoDecode.h>

char * stateStrings[] = {
  "NOT_SYNCHED", "ACQUIRING", "READY", "in Failsafe"};


int deadband_high = 275; 
int deadband_low = 235;  

int pwm_ceiling = 256; 
int pwm_floor = 255;  

int low1 = 1000;  // adjust these values if your R/C readings are above or below these for channels 1 and 2.
int high1 = 2000;
int low2 = 1000;
int high2 = 2000;

int motor1_a = 5; // motor 1 outputs
int motor1_b = 4;
int motor1_pwm = 3;

int motor2_a = 9; // motor 2 outputs
int motor2_b = 10;
int motor2_pwm = 11;

int ledPin1 = 13; // led indicator lights
int ledPin2 = 12;

int adj_val1;
int adj_val2;

int x;
int y;

int a;
int b;

void setup()  
{
  Serial.begin(9600);
  ServoDecode.begin();
  for( int i=1; i <=8; i++){
    ServoDecode.setFailsafe(i,1230 + i);
  }

  //motor1 pins
  pinMode(motor1_a, OUTPUT);
  pinMode(motor1_b, OUTPUT);
  pinMode(motor1_pwm, OUTPUT);
  
  pinMode(motor2_a, OUTPUT);
  pinMode(motor2_b, OUTPUT);
  pinMode(motor2_pwm, OUTPUT);
  
  //led's
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);

}


void loop()
{
  int pulsewidth;

  // print the decoder state
  if( ServoDecode.getState()!= READY_state) {
    Serial.print("The decoder is ");
    Serial.println(stateStrings[ServoDecode.getState()]);
    for ( int i =1; i <=MAX_CHANNELS; i++ ){ // print the status of the first four channels
      Serial.print("Cx"); // if you see this, the decoder does not have a valid signal
      Serial.print(i);
      Serial.print("= ");
      pulsewidth = ServoDecode.GetChannelPulseWidth(i);
      Serial.print(pulsewidth);
      Serial.print("  ");
    }
    Serial.println("");
  }
  else {
    // decoder is ready, print the channel pulse widths
    for ( int i =1; i <=MAX_CHANNELS; i++ ){ // print the status of the first four channels
      Serial.print("Ch");
      Serial.print(i);
      Serial.print("= ");
      pulsewidth = ServoDecode.GetChannelPulseWidth(i);        
      Serial.print(pulsewidth);
      Serial.print("  ");
    }
    Serial.println("");

  }

  ////////////

  adj_val1 = map(ServoDecode.GetChannelPulseWidth(3), low1, high1, 0, 511); 
  constrain(adj_val1, 0, 511);
  x = adj_val1;

  adj_val2 = map(ServoDecode.GetChannelPulseWidth(4), low2, high2, 0, 511); 
  constrain(adj_val2, 0, 511);
  y = adj_val2;


if (y > deadband_high) {  // go forward

    if (x > deadband_high) { // turn right
      a = y - pwm_ceiling;
      b = (y - pwm_ceiling) - (x - pwm_ceiling);
      test();
      motor1_forward();
      motor2_forward();
    }

    else if (x < deadband_low) {   // turn left
      a = (y - pwm_ceiling) - (pwm_floor - x);
      b = y - pwm_ceiling;
      test();
      motor1_forward();
      motor2_forward();
    }

    else {
      a = y - pwm_ceiling;
      b = y - pwm_ceiling;
      test();
      motor1_forward();
      motor2_forward();
    }
  }

  else if (y < deadband_low) {    // go backwards

    if (x > deadband_high) { // turn right
      a = pwm_floor - y;
      b = (pwm_floor - y) - (x - pwm_ceiling);
      test();
      motor1_reverse();
      motor2_reverse();
    }

    else if (x < deadband_low) {   // turn left
      a = (pwm_floor - y) - (pwm_floor - x);
      b = pwm_floor - y;
      test();
      motor1_reverse();
      motor2_reverse();   
    }			

    else {
      a = pwm_floor - y;
      b = pwm_floor - y;
      test();
      motor1_reverse();
      motor2_reverse();
    }

  }

  else {     // neutral, with a chance of donuts.

    if (x > deadband_high) {

      a = (x - pwm_ceiling) / 2;
      b = a;

      motor2_forward();
      motor1_reverse();

    }  

    else if (x < deadband_low) {

      a = (pwm_floor - x) / 2;
      b = a;

      motor2_reverse();
      motor1_forward();

    }  

    else {
      stop();
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


void motor1_forward() {
  digitalWrite(motor1_b, LOW);
  digitalWrite(motor1_a, HIGH);
  analogWrite(motor1_pwm, a);
  digitalWrite(ledPin1, LOW);
}

void motor2_forward() {
  digitalWrite(motor2_b, LOW);
  digitalWrite(motor2_a, HIGH);
  analogWrite(motor2_pwm, b);
  digitalWrite(ledPin2, LOW);
}


void motor1_reverse() {
  digitalWrite(motor1_a, LOW);
  digitalWrite(motor1_b, HIGH);
  analogWrite(motor1_pwm, a);
  digitalWrite(ledPin1, LOW);
}

void motor2_reverse() {
  digitalWrite(motor2_a, LOW);
  digitalWrite(motor2_b, HIGH);
  analogWrite(motor2_pwm, b);
  digitalWrite(ledPin2, LOW); 
}

void motor1_stop() {
  digitalWrite(motor1_b, LOW);
  digitalWrite(motor1_a, LOW);
  digitalWrite(motor1_pwm, LOW);
  digitalWrite(ledPin1, HIGH);
}

void motor2_stop() {
  digitalWrite(motor2_b, LOW);
  digitalWrite(motor2_a, LOW);  
  digitalWrite(motor2_pwm, LOW);
  digitalWrite(ledPin2, HIGH); 
}

void stop() {

  digitalWrite(motor1_b, LOW);
  digitalWrite(motor1_a, LOW);
  digitalWrite(motor1_pwm, LOW);

  digitalWrite(motor2_b, LOW);
  digitalWrite(motor2_a, LOW);
  digitalWrite(motor2_pwm, LOW);

  digitalWrite(ledPin1, HIGH);
  digitalWrite(ledPin2, HIGH); 

}


