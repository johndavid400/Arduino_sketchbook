// This is the failsafe sketch to decode several more R/C signals and drive external circuitry
// Failsafe INPUT goes into pin 2
// Lawnmower kill-switch INPUT goes into pin 3
// Head-lights INPUT goes into pin 4
// Bucket-lift motor INPUT goes into pin 5
// OUTPUTs are listed by function
// you will need a Relay interface board for each output and an H-bridge or DPDT relay to control the lift-motor UP/DOWN
// JD Warren 2010

int ppm1 = 16; // R/C input for failsafe channel
int ppm2 = 17; // R/C input for lights

int failsafe_Pin = 9; // pin used to switch Failsafe relay
int mower_kill = 10;   // pin used to switch lawnmower kill switch relay

int ledPin1 = 12;
int ledPin2 = 13;

// variables to hold the raw R/C readings
unsigned int ppm1_val;
unsigned int ppm2_val;

// variables to hold the tested R/C values
unsigned int failsafe_val;
unsigned int mower_kill_val;

int update = 20;  // sets the update interval to 20 milliseconds


void setup() {

  Serial.begin(9600);

  // Declare the OUTPUTS
  pinMode(failsafe_Pin, OUTPUT);
  pinMode(mower_kill, OUTPUT);

  //Failsafe LED
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);

  //PPM inputs from RC receiver
  pinMode(ppm1, INPUT); 
  pinMode(ppm2, INPUT);	

  // The failsafe should be OFF by default  
  digitalWrite(failsafe_Pin, LOW);
  digitalWrite(mower_kill, LOW);
}

void pulse() {

  // decode and test the value for ppm1
  ppm1_val = pulseIn(ppm1, HIGH, 20000);
  if (ppm1 < 600 || ppm1 > 2400) {
    failsafe_val = 1500; 
  }
  else {
    failsafe_val = ppm1_val; 
  }

  // decode and test the value for ppm2
  ppm2_val = pulseIn(ppm2, HIGH, 20000);
  if (ppm2 < 600 || ppm2 > 2400) {
    mower_kill = 1500;
  }
  else {
    mower_kill = ppm2_val; 
  }

}

void loop() {

  // Use pulseIn() to check the value of each R/C input using the function above  
  pulse();


  // Failsafe relay

  if (failsafe_val > 1750 && failsafe_val < 2000) {
    digitalWrite(failsafe_Pin, LOW); 
    digitalWrite(ledPin1, LOW);
  }
  else {
    digitalWrite(failsafe_Pin, HIGH);
    digitalWrite(ledPin1, HIGH);
  }

  // Lawnmower kill-switch relay

  if (mower_kill_val > 1750 && mower_kill_val < 2000) {
    digitalWrite(mower_kill, LOW); 
    digitalWrite(ledPin2, LOW);
  }
  else {
    digitalWrite(mower_kill, HIGH);
    digitalWrite(ledPin2, HIGH);
  }

  // print the values for each R/C channel

  Serial.print(" Failsafe:  ");
  Serial.print(failsafe_val);
  Serial.print("  ");
  Serial.print(" Mower kill-switch:  ");
  Serial.print(mower_kill_val);

  Serial.println("  ");

  delay(update);

}


