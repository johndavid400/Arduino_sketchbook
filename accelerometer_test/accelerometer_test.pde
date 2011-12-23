// Arduino - Analog Accelerometer
// Plug accelerometer output into Arduino analog pin 0
// Open Serial monitor at 9600bps to see accelerometer value

int angle = 0; // variable used to hold the "rough angle" approximation

void setup(){

  Serial.begin(9600); // start Serial monitor to print values

  analogReference(EXTERNAL); // tell Arduino to use the voltage connected to the Aref pin for analog reference

}

void loop(){

  angle = analogRead(0);  // read the accelerometer from Analog pin 0

  angle = map(angle, 0, 1023, -90, 90); // map the value from a 10 bit to a rough angle in either direction

  Serial.print("Accelerometer:  ");  // print the word "Accelerometer: " first
  Serial.println(angle);  // then print the value of the variable "angle"

}



