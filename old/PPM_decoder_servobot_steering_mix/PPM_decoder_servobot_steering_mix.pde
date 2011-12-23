// ServoDecodeTest

#include <ServoDecode.h>

char * stateStrings[] = {
  "NOT_SYNCHED", "ACQUIRING", "READY", "in Failsafe"};


int deadband_high = 275; 
int deadband_low = 235;  

int pwm_ceiling = 256; 
int pwm_floor = 255;  

int low1 = 1250;  // adjust these values if your R/C readings are above or below these for channels 1 and 2.
int high1 = 1740;
int low2 = 1200;
int high2 = 1784;

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

  if (adj_val1 > deadband_high) {
    //Forward
    digitalWrite(motor1_b, LOW);
    digitalWrite(motor1_a, HIGH);
    analogWrite(motor1_pwm, adj_val1 - pwm_ceiling); 
    digitalWrite(ledPin1, LOW);
  }
  else if (adj_val1 < deadband_low) {
    //REVERSE
    digitalWrite(motor1_a, LOW);
    digitalWrite(motor1_b, HIGH);
    analogWrite(motor1_pwm, pwm_floor - adj_val1);
    digitalWrite(ledPin1, LOW);
  }
  else {
    //STOP
    digitalWrite(motor1_a, LOW);
    digitalWrite(motor1_b, LOW);
    digitalWrite(motor1_pwm, LOW);
    digitalWrite(ledPin1, HIGH); // turn on neutral light, turn motor pins off
  }

  ///////////
  

  adj_val2 = map(ServoDecode.GetChannelPulseWidth(4), low2, high2, 0, 511); 
  constrain(adj_val2, 0, 511);
  y = adj_val2;

  if (adj_val2 > deadband_high) {
    //Forward
    digitalWrite(motor2_b, LOW);
    digitalWrite(motor2_a, HIGH);
    analogWrite(motor2_pwm, adj_val2 - pwm_ceiling); 
    digitalWrite(ledPin2, LOW);
  }
  else if (adj_val1 < deadband_low) {
    //REVERSE
    digitalWrite(motor2_a, LOW);
    digitalWrite(motor2_b, HIGH);
    analogWrite(motor2_pwm, pwm_floor - adj_val2);
    digitalWrite(ledPin2, LOW);
  }
  else {
    //STOP
    digitalWrite(motor2_a, LOW);
    digitalWrite(motor2_b, LOW);
    digitalWrite(motor2_pwm, LOW);
    digitalWrite(ledPin2, HIGH); // turn on neutral light, turn motor pins off
  }

  ///////////  
  

} 




