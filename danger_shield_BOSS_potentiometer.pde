// DangerShield code
// Plug on top of Arduino, load code, and play!
// Change whatever you want
// JDW 2011

//////// I/O pins defined /////////////
// connect potentiometer to analog pin 0
int slider1 = 0;

// variable to hold potentiometer value
int potVal1;

void setup(){
  Serial.begin(19200);
  pinMode(slider1, INPUT);
}

void loop(){
  // read sliding pot and set LED accordingly
  potVal1 = analogRead(slider1);
  Serial.println(potVal1);
}

