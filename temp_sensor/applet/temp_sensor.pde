
float temp;
int tempC;
int tempF;


void setup() {

  Serial.begin(9600);
  
}

void loop() {
  
  temp = analogRead(1);
  tempC = (5.0 * temp * 100.0)/1024.0;
  tempF = (tempC * 9)/ 5 + 32;
  
  Serial.print("tempC:  ");
  Serial.print(tempC);
  Serial.print("           ");
  Serial.print("tempF:  ");
  Serial.print(tempF);
  Serial.println("           ");
 
  delay(500);
  
}
