// Read pulse signal from an IR sensor using interrupts for quick readings

volatile int pulse = 0;
volatile long startPulse = 0;
int ticker = 0;
int x = 0;
int ir_vals[62];
int pulsed = 0;

void setup(){
  Serial.begin(19200); 
  pinMode(2, INPUT);
  //attachInterrupt(0, pulse_begin, RISING);    // catch interrupt 0 (digital pin 2) going HIGH and send to rc1()
}

/*
void pulse_begin() {           // enter rc1_begin when interrupt pin goes HIGH.
 startPulse = micros();     // record microseconds() value as servo1_startPulse
 detachInterrupt(0);  // after recording the value, detach the interrupt from rc1_begin
 attachInterrupt(0, pulse_end, FALLING); // re-attach the interrupt as rc1_end, so we can record the value when it goes low
 }
 
 void pulse_end() {
 pulse = micros() - startPulse;  // when interrupt pin goes LOW, record the total pulse length by subtracting previous start value from current micros() vlaue.
 detachInterrupt(0);  // detach and get ready to go HIGH again
 attachInterrupt(0, pulse_begin, RISING); 
 }
 */

void loop(){

  pulse = pulseIn(2, HIGH);

  if (pulse > 0){
/*
    if (pulse < 500){
      pulse = 0;
    }
    else if (pulse > 500 ){
      if (pulse >= 2000){
        pulse = 2;
      }
      else{
        pulse = 1;
      }
    }    
*/
    ir_vals[x] = pulse;
    x++;

    pulse = 0;
    pulsed = 1;  
  }

  else{

    if (pulsed == 1){

      for (int i = 0; i <= 62; i++){
        Serial.print(i);
        Serial.print(":   " );
        Serial.println(ir_vals[i]);
      } 
      Serial.println(" ");
      Serial.println(" End of Signal ");
      Serial.println(" ");
      pulsed = 0;
      x = 0;
    }
    else {
    }

  }
}













