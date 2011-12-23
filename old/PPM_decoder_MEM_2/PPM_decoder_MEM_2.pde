// ServoDecodeTest

#include <ServoDecode.h>

int led = 13;

char * stateStrings[] = {
  "NOT_SYNCHED", "ACQUIRING", "READY", "in Failsafe"};

void setup()  
{
  Serial.begin(9600);
  ServoDecode.begin();
  for( int i=1; i <=8; i++){
    ServoDecode.setFailsafe(i,1230 + i);
  }

  pinMode(led,OUTPUT);

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

 if (ServoDecode.GetChannelPulseWidth(3) > 1500) {
  digitalWrite(led, HIGH); 
 }
 else {
  digitalWrite(led, LOW); 
 }

} 



