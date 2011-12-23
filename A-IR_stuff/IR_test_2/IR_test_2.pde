// ServoDecodeTest

#include <ServoDecode.h>

char * stateStrings[] = {
  "NOT_SYNCHED", "ACQUIRING", "READY", "in Failsafe"};


int ir_val1 = 0;
int ir_val2 = 0;

int adj_val1 = 0;
int adj_val2 = 0;

int high1 = 1000;
int low1 = 0;
int high2 = 1000;
int low2 = 0;

int led1 = 12;
int led2 = 13;

int scan_val1;
int scan_val2;

int motor1_a = 5; // motor 1 outputs
int motor1_b = 4;
int motor1_pwm = 3;

int motor2_a = 9; // motor 2 outputs
int motor2_b = 10;
int motor2_pwm = 11;

int x;
int y;

int a;
int b;

int breakpoint1 = 25;
int breakpoint2 = 25;

int n = 0;

int deadband_high = 275; 
int deadband_low = 235;  

int pwm_ceiling = 256; 
int pwm_floor = 255;  


void setup(){

  Serial.begin(9600);

  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT); 

  //scan(1000);
/*
  ServoDecode.begin();
  for( int i=1; i <=8; i++){
    ServoDecode.setFailsafe(i,1230 + i);
  }
*/
  //motor1 pins
  pinMode(motor1_a, OUTPUT);
  pinMode(motor1_b, OUTPUT);
  pinMode(motor1_pwm, OUTPUT);

  pinMode(motor2_a, OUTPUT);
  pinMode(motor2_b, OUTPUT);
  pinMode(motor2_pwm, OUTPUT);

}


void loop() {

  
  /*
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
  
  */
  
  
  ir_val1 = analogRead(0);
  ir_val2 = analogRead(1);

  adj_val1 = map(ir_val1, low1, high1, 0, 255); 
  constrain(adj_val1, 0, 255);

  adj_val2 = map(ir_val2, low2, high2, 0, 255); 
  constrain(adj_val2, 0, 255);  

  if (adj_val1 > breakpoint1){
    digitalWrite(led1, HIGH); 
    a = 255;
    b = 255 - adj_val1;
    motor1_forward();
    motor2_forward();
  }
  else {
    digitalWrite(led1, LOW);
  }


  if (ir_val2 > 512){
    digitalWrite(led2, HIGH); 
  }
  else {
    digitalWrite(led2, LOW);
  } 

  Serial.print("Val1:  ");
  Serial.print(ir_val1);
  Serial.print("       ");
  Serial.print("Adj_Val1:  ");
  Serial.print(adj_val1);
  Serial.print("       ");
  Serial.print("Val2:  ");
  Serial.print(ir_val2);
  Serial.print("       ");
  Serial.print("Adj_Val2:  ");
  Serial.print(adj_val2);
  Serial.println("       ");


}


int scan(int reading){

  if (n < reading) {

    scan_val1 = analogRead(0);
    scan_val2 = analogRead(1);  

    if (scan_val1 > high1){
      high1 = scan_val1; 
    }
    else if (scan_val1 < low1){
      low1 = scan_val1; 
    }

    else if (scan_val2 > high2){
      high2 = scan_val1;
    }
    else if (scan_val2 < low2){
      low2 = scan_val2; 
    }
    else {
      n++;

      Serial.print("Scanning:  ");
      Serial.print(n);
      Serial.print("       ");  
      Serial.print("HIGH1: ");
      Serial.print(high1);
      Serial.print("       ");
      Serial.print("LOW1: ");
      Serial.print(low1);
      Serial.print("       ");
      Serial.print("HIGH2: ");
      Serial.print(high2);
      Serial.print("       ");
      Serial.print("LOW2: ");
      Serial.print(low2);      
      Serial.println("       ");
    }
  }

  else {
    n = 0; 
  }

}

void motor1_forward() {
  digitalWrite(motor1_b, LOW);
  digitalWrite(motor1_a, HIGH);
  analogWrite(motor1_pwm, a); 
  digitalWrite(led1, LOW);
}

void motor2_forward() {
  digitalWrite(motor2_b, LOW);
  digitalWrite(motor2_a, HIGH);
  analogWrite(motor2_pwm, b); 
  digitalWrite(led2, LOW);
}


void motor1_reverse() {
  digitalWrite(motor1_a, LOW);
  digitalWrite(motor1_b, HIGH);
  analogWrite(motor1_pwm, a);
  digitalWrite(led1, LOW);
}

void motor2_reverse() {
  digitalWrite(motor2_a, LOW);
  digitalWrite(motor2_b, HIGH);
  analogWrite(motor2_pwm, b);
  digitalWrite(led2, LOW);
}

void motor1_stop() {
  digitalWrite(motor1_a, LOW);
  digitalWrite(motor1_b, LOW);
  digitalWrite(motor1_pwm, LOW);
  digitalWrite(led1, HIGH); // turn on neutral light, turn motor pins off
}

void motor2_stop() {
  digitalWrite(motor2_a, LOW);
  digitalWrite(motor2_b, LOW);
  digitalWrite(motor2_pwm, LOW);
  digitalWrite(led2, HIGH); // turn on neutral light, turn motor pins off
}

void stop() {

  digitalWrite(motor1_a, LOW);
  digitalWrite(motor1_b, LOW);
  digitalWrite(motor1_pwm, LOW);
  digitalWrite(led1, HIGH); // turn on neutral light, turn motor pins off

  digitalWrite(motor2_a, LOW);
  digitalWrite(motor2_b, LOW);
  digitalWrite(motor2_pwm, LOW);
  digitalWrite(led2, HIGH); // turn on neutral light, turn motor pins off

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





