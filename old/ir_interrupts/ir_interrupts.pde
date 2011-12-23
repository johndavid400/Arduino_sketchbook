// Read pulse signal from an IR sensor using interrupts for quick readings

volatile int pulse = 0;
volatile long startPulse = 0;
int ticker = 0;
int x = 0;
int ir_vals[33];
int focus;

void setup(){
  Serial.begin(115200); 
  pinMode(2, INPUT);
  attachInterrupt(0, pulse_begin, RISING);    // catch interrupt 0 (digital pin 2) going HIGH and send to rc1()
}

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

void loop(){

  if (pulse > 0){
    if (pulse > 4000){
      Serial.println(" ");
      ticker = 0;
      x = 0;
    }
    ir_vals[x] = pulse;
    focus = ir_vals[x];
    x++;
    ticker++;
    pulse = 0;
    
  }

  if (focus == ir_vals[26]){
    focus = focus / 100;
    Serial.println(focus);
    focus = 0;
  }


}






