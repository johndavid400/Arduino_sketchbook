// DangerShield code
// Plug on top of Arduino, load code, and play!
// Change whatever you want
// JDW 2011

//////// I/O pins defined /////////////

// button switch
int LED = 2;

void setup(){
  pinMode(LED, OUTPUT);
}

void loop(){
 // Turn LED On 
 digitalWrite(LED, HIGH);
 // leave On for 1000 milliseconds (1 second)
 delay(1000);
 // turn LED Off
 digitalWrite(LED, LOW);
 // wait 1 second
 delay(1000); 
}



