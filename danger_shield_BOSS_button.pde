// DangerShield code
// Plug on top of Arduino, load code, and play!
// Change whatever you want
// JDW 2011

//////// I/O pins defined /////////////

// button switch
int button1 = 2;
// variable to hold switch state
int switchVal1; 

void setup(){
  pinMode(button1, INPUT);
}

void loop(){
  // read button switches
  switchVal1 = digitalRead(button1);
}



