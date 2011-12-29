// This code is intended to decode an Infrared helicopter remote using a standard IR receiver from Radio Shack using Interrupts
// This code is tested on an Arduino Mega
// connect 
// JDW 2011

int ledPin = 13; // optional LED on pin 13
int pulse_pin = 2; // connect IR receiver - I used pin 21, but you can change this if using a regular Arduino, any pin will work.
int pulse_val = 0;
boolean reading = false;
int ir_array[20];
int n = 0;
int z = 0;

void setup() {

  // start serial monitor
  Serial.begin(9600);
  //led on arduino pin 13
  pinMode(ledPin, OUTPUT);
  // IR signal from helicopter controller
  pinMode(pulse_pin, INPUT);

}

void pulse(){
  pulse_val = pulseIn(pulse_pin, HIGH, 10000);
}

void booleanize(){
  // this function changes the pulse readings of 500 microseconds and 1100 microseconds (the only 2 pulse lengths I could detect) into or 0 boolean values.
    if (pulse_val > 750){
    pulse_val = 1;
  }
  else {
    pulse_val = 0;
  }
}

void loop() {
  // get a pulse reading from the IR sensor
  pulse();
  // now check to see if it is above 0
  if (pulse_val > 0){
    digitalWrite(ledPin, HIGH);
    // if so, lets start reading the pulses
    reading = true;
    booleanize();
    // put each of the 20 or so readings into an array
    ir_array[n] = pulse_val;
    Serial.print(ir_array[n]);
    // cycle the counter up one to continue through the array
    n++;
  }
  // if the pulse is not greater than 0...
  else {
    // check to make sure we got at least 18 of the 20 pulses
    if (n > 18){
      n = 0;
      Serial.println("");
    }
  }
  digitalWrite(ledPin, LOW);
}






