int my_led = 13;   // declare the variable my_led
int pot_val;    // use variable “pot_val” to store the value of the potentiometer 
int adj_val;   // use this variable to adjust the pot_val into a variable frequency value
int cycle_val = 16;  // Use this value (in milliseconds) to manually adjust the frequency of the pseudo-PWM signal

void setup() {
  Serial.begin(9600);
  pinMode(my_led, OUTPUT);    // use the pinMode() command to set my_led as an OUTPUT
}

void loop() {
  pot_val = analogRead(0); // read potentiometer value from A0
  adj_val = map(pot_val, 0, 1023, 0, cycle_val); // adjust 0-1023 analog input value to a range determined by the variable cycle_val 

  // switching cycle On/Off, occurs each loop cycle - changing cycle_val changes delay time between cycles.
  // more switching cycles (lower delay) each second means higher frequency - fewer switching cycles (higher delay) means lower frequency.
  digitalWrite(my_led, HIGH);    // set my_led HIGH (turn it On)
  delay(adj_val); 	         // stay turned On for this amount of time
  digitalWrite(my_led, LOW);     // set my_led LOW (turn it Off)
  delay(cycle_val - adj_val);    // stay turned Off for this amount of time 
 
  //Serial.println(adj_val);
 
}
