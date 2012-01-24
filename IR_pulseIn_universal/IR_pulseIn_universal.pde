// This code is intended to decode an Infrared helicopter remote using a standard IR receiver from Radio Shack using Interrupts
// This code is tested on an Arduino Mega
// connect 
// JDW 2011

int pulse_pin = 2; // connect IR receiver - I used pin 21, but you can change this if using a regular Arduino, any pin will work.
int pulse_val = 0;
int pulse_boolean;
int pulse_number = 20;
int ir_array[] = {};
int dead_pulse_threshold = 4;
int pulse_limit_low = 10;
int pulse_limit_high = 50;
int n = 0;
int z = 0;

void setup() {
  Serial.begin(115200);
  pinMode(pulse_pin, INPUT);
}

void pulse(){
  pulse_val = pulseIn(pulse_pin, HIGH, 10000);
}

void booleanize(){
  if (pulse_val > 750){
    pulse_boolean = 1;
  }
  else {
    pulse_boolean = 0;
  }
}

void loop() {
  pulse();
  if (pulse_val > 0){
    booleanize();
    ir_array[n] = pulse_boolean;
    Serial.print(ir_array[n]);
    n++;
  }
  else {
    if (z > dead_pulse_threshold){
      if (n > pulse_limit_low){
        if (n > pulse_limit_high){
          n = 0;
        }
        else {
          Serial.print("  light_val: ");
          Serial.println(analogRead(5));
          n = 0;
        }
      }
      z = 0;
    }
    else {
      z++;      
    }
  }
}







