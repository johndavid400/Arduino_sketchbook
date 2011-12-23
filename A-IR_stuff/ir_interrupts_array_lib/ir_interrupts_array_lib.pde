// Read pulse signal from an IR sensor using interrupts for quick readings

volatile int pulse = 0;
volatile long startPulse = 0;
int ticker = 0;
int x = 0;
int ir_vals[34];
int button = 0;


void setup(){
  Serial.begin(115200); 
  pinMode(2, INPUT);
  attachInterrupt(0, pulse_begin, RISING);    // catch interrupt 0 (digital pin 2) going HIGH and send to rc1()
  //Serial.print("Initializing...");
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

    if (pulse > 3000){
      Serial.println(" ");
      x = 0;
    }

    else if (pulse > 600){
      pulse = 1;
    }
    else{
      pulse = 0;
    }

    ir_vals[x] = pulse;
    x++;

    if (ir_vals[x] >= 33){
      noInterrupts();

      for (int i = 0; i <= 33; i++){
        Serial.print(i);
        Serial.print(":   ");
        Serial.println(ir_vals[i]);
      }      
      
      Serial.println("Finished reading signal");
      x = 0;
      
      interrupts();

    }

    pulse = 0;

  }
  


}



