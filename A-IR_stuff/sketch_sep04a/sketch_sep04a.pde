// Read pulse signal from an IR sensor using interrupts for quick readings

volatile int pulse = 0;
volatile long startPulse = 0;
int ticker = 0;
int x = 0;
int ir_vals[25];
int pulsed;

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

    if (pulse < 750){
      pulse = 0;
    }
    else if (pulse > 750 ){
      if (pulse >= 2000){
        pulse = 2;
      }
      else{
        pulse = 1;
      }
    }


    ir_vals[x] = pulse;
    x++;
    pulse = 0;
    pulsed = 1;
  }
  else {
    if (pulsed == 1){

      for (int i = 0; i <= 25; i++){
        Serial.print(i);
        Serial.print(":   ");
        Serial.println(ir_vals[i]);
      } 

      Serial.println("  ");
      Serial.println(" received signal ");
      Serial.println("  ");
      check_pulse();
      pulsed = 0;
      x = 0;

    }
    else {        
    }
  }
}


void check_pulse(){

  if (ir_vals[23] == 1){
    // then (pause, rec, tv/vcr, up, or down

    if (ir_vals[17] == 1){            
    // then (rec or tv/vrc)   
      if (ir_vals[19] == 1){
        Serial.println("Record");
      }
      else {
        Serial.println("TV/VCR");
      } 
    }
    else {                               
    // then (pause, up, or down)
      if (ir_vals[18] == 1){
      // then up or down        
        if (ir_vals[20] == 1){
          Serial.println("UP");
        } 
        else {
          Serial.println("Down"); 
        }
      }
      else{
        Serial.println("Pause"); 
      }
    }
  }
  
  if (ir_vals[21] == 1){
    // then (ch up, ch dn, info, clear, left, right, <<, >>, play or stop)
    if (ir_vals[] == 1){
  
    }
    else{
  
    }    
  }
  
  
  else {
   // numbers 0-9 
    
  }

}
















