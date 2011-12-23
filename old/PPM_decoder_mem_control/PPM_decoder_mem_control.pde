// ServoDecodeTest
#include <ServoTimer2.h>
#include <ServoDecode.h>

// define the servo pins
#define servoApin  2   // the pin the servo is attached to/
ServoTimer2 servoA;    // declare variables for the servos

char * stateStrings[] = {
  "NOT_SYNCHED", "ACQUIRING", "READY", "in Failsafe"};


void setup()			  // run once, when the sketch starts
{
  Serial.begin(38400);
  servoA.attach(servoApin);
  ServoDecode.begin();
  ServoDecode.setFailsafe(3,1234); // set channel 3 failsafe pulse  width
}


void loop()			   // run over and over again
{
  int count=0;
  int pulsewidth;

  // print the decoder state
  if( ServoDecode.getState()!= READY_state) {
    Serial.print("The decoder is ");
    Serial.println(stateStrings[ServoDecode.getState()]);
    for ( int i =0; i <=MAX_CHANNELS; i++ ){ // print the status of the first four channels
	Serial.print("Cx");
	Serial.print(i);
	Serial.print("= ");
	pulsewidth = ServoDecode.GetChannelPulseWidth(i);
	Serial.print(pulsewidth);
	Serial.print("  ");
    }
    Serial.println("");
  }
  else {
    if( count % 20 == 0){   // decoder is ready, print the channel pulse widths every second
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
    count++;
  }
  servoA.write(ServoDecode.GetChannelPulseWidth(3));
  delay(20); // update 50 times a second

} 

