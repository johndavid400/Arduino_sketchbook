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
int motor1_b = 6;

int motor2_a = 3; // motor 2 outputs
int motor2_b = 11;

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

  pinMode(motor2_a, OUTPUT);
  pinMode(motor2_b, OUTPUT);

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

  if (ServoDecode.GetChannelPulseWidth(1) > 750 && ServoDecode.GetChannelPulseWidth(1) < 1100){

    adj_val1 = map(ServoDecode.GetChannelPulseWidth(3), low1, high1, 0, 511); 
    constrain(adj_val1, 0, 511);
    y = adj_val1;

    adj_val2 = map(ServoDecode.GetChannelPulseWidth(4), low2, high2, 0, 511); 
    constrain(adj_val2, 0, 511);    
    x = adj_val2;

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
  ////////////

  else {

    adj_val1 = map(ServoDecode.GetChannelPulseWidth(3), low1, high1, 0, 511); 
    constrain(adj_val1, 0, 511);

    if (adj_val1 > deadband_high) {
      //Forward
      digitalWrite(motor1_b, LOW);
      analogWrite(motor1_a, adj_val1 - pwm_ceiling); 
      digitalWrite(ledPin1, LOW);
    }
    else if (adj_val1 < deadband_low) {
      //REVERSE
      digitalWrite(motor1_a, LOW);
      analogWrite(motor1_b, pwm_floor - adj_val1);
      digitalWrite(ledPin1, LOW);
    }
    else {
      //STOP
      digitalWrite(motor1_a, LOW);
      digitalWrite(motor1_b, LOW);
      digitalWrite(ledPin1, HIGH); // turn on neutral light, turn motor pins off
    }

    ///////////


    adj_val2 = map(ServoDecode.GetChannelPulseWidth(2), high2, low2, 0, 511); 
    constrain(adj_val2, 0, 511);

    if (adj_val2 > deadband_high) {
      //Forward
      digitalWrite(motor2_b, LOW);
      analogWrite(motor2_a, adj_val2 - pwm_ceiling); 
      digitalWrite(ledPin2, LOW);
    }
    else if (adj_val2 < deadband_low) {
      //REVERSE
      digitalWrite(motor2_a, LOW);
      analogWrite(motor2_b, pwm_floor - adj_val2);
      digitalWrite(ledPin2, LOW);
    }
    else {
      //STOP
      digitalWrite(motor2_a, LOW);
      digitalWrite(motor2_b, LOW);
      digitalWrite(ledPin2, HIGH); // turn on neutral light, turn motor pins off
    }

    ///////////  

  }

} 


void motor1_forward() {
  digitalWrite(motor1_b, LOW);
  analogWrite(motor1_a, a); 
  digitalWrite(ledPin1, LOW);
}

void motor2_forward() {
  digitalWrite(motor2_b, LOW);
  analogWrite(motor2_a, b); 
  digitalWrite(ledPin2, LOW);
}


void motor1_reverse() {
  digitalWrite(motor1_a, LOW);
  analogWrite(motor1_b, a);
  digitalWrite(ledPin1, LOW);
}

void motor2_reverse() {
  digitalWrite(motor2_a, LOW);
  analogWrite(motor2_b, b);
  digitalWrite(ledPin2, LOW);
}

void motor1_stop() {
  digitalWrite(motor1_a, LOW);
  digitalWrite(motor1_b, LOW);
  digitalWrite(ledPin1, HIGH); // turn on neutral light, turn motor pins off
}

void motor2_stop() {
  digitalWrite(motor2_a, LOW);
  digitalWrite(motor2_b, LOW);
  digitalWrite(ledPin2, HIGH); // turn on neutral light, turn motor pins off
}

void stop() {

  digitalWrite(motor1_a, LOW);
  digitalWrite(motor1_b, LOW);
  digitalWrite(ledPin1, HIGH); // turn on neutral light, turn motor pins off

  digitalWrite(motor2_a, LOW);
  digitalWrite(motor2_b, LOW);
  digitalWrite(ledPin2, HIGH); // turn on neutral light, turn motor pins off

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

