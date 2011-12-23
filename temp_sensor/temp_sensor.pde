// Plug LM35 temperature sensor into analog port 
float temp;
int tempC;
int tempF;

int pwr = 14;
int gnd = 16;

void setup() {

  Serial.begin(9600);
  
  pinMode(14, OUTPUT);
  pinMode(16, OUTPUT);
  
  digitalWrite(pwr, HIGH);
  digitalWrite(gnd, LOW);
  
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
