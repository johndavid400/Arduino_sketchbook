// Arduino - Analog Gyroscope 
// Plug gyroscope into analog pin 1
// Hold gyroscope level and still for 5 seconds after turning on to allow for calibration of offset.
// Open Serial monitor to see readings

int gyro_val; // variable used to hold gyro reading from analog pin 1
int gyro_sum; // variable used to calculate average offset
int gyro_offset; // determines the average value above Zero while the gyro is at rest

float angle = 0.0; // variable to hold angular value
int gyro_raw; // value of the gyro_val minus the gyro_offset
float gyro_rate;

long last_cycle; // variable to hold the cycle-end millisecond reading from the system timer (timestamp)
int cycle_time; // variable to hold current millisecond value minus the last cycle millisecond value = cycle time in milliseconds

void setup(){

  Serial.begin(9600); // start Serial monitor to print values

  analogReference(EXTERNAL); // tell Arduino to use the voltage connected to the Aref pin for analog reference (3.3v)

   // run this function to sample the gyro at rest 25 times during the setup, and add each reading to gyro_sum
   for (int i=0; i < 25; i++){  
      gyro_sum += analogRead(1); // the += symbol is equivalent to gyro_sum = gyro_sum + analogRead(1);
      delay(10); // wait 10 milliseconds to let get another random sample
   } 

    gyro_offset = gyro_sum / 25; // average the 25 sample readings by dividing their sum by 25 to determine the above 0 offset
    
}  



void loop(){

  gyro_val = analogRead(1); // each loop cycle, read the gyro output value from analog pin 1

  gyro_raw = gyro_val - gyro_offset; // subtract the offset from the current reading

  gyro_rate = (float)(gyro_raw * 0.015);
  
  // First multiply the gyro_raw (rate) by 0.05 (time - in seconds,0.05 seconds = 50 milliseconds) to get the distance
  // Then add the new recorded distance in either direction to the previous angle reading to get the new angle reading
  // this all happens in 1 line of code 
  
  angle = angle + (gyro_rate * -0.05); 


  // create a timer based delay to set the loop frequency to 20Hz - change the value "50" (milliseconds) to set total desired loop. 
  while((millis() - last_cycle) < 50){
    delay(1);
  }

  cycle_time = millis() - last_cycle;
  last_cycle = millis();
/*
  Serial.print(" Gyro: ");
  Serial.print(gyro_val);
  Serial.print("    ");
  
  Serial.print(" Raw: ");
  Serial.print(gyro_raw);
  Serial.print("    ");  
  
  Serial.print(" Offset: ");
  Serial.print(gyro_offset);
  Serial.print("    ");
  */
  Serial.print(" time: ");
  Serial.print(cycle_time);
  Serial.print("    ");
  
  Serial.print(" Angle: ");
  Serial.print(angle);
  Serial.println("    ");
  
}

