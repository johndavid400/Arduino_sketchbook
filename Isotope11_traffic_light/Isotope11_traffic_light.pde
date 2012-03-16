// Isotope11 CI-server traffic light
// Arduino Uno with 2 relays attached to pins 4 and 7
// 2-9-12

int inByte;
int yellow_light = 4;
int red_green_light = 7;

void setup() {
  Serial.begin(9600);
  pinMode(yellow_light, OUTPUT);
  pinMode(red_green_light, OUTPUT);
}

void loop() {
  if (Serial.available() > 0){
    inByte = Serial.read();
    Serial.println(inByte);
  }
  switch(inByte){
  case 49:
    digitalWrite(yellow_light, HIGH);
    delay(1000);
    digitalWrite(yellow_light, LOW);
    break;
  case 50:
    digitalWrite(yellow_light, LOW);
    break;
  case 51:
    digitalWrite(red_green_light, HIGH);
    break;
  case 52:
    digitalWrite(red_green_light, LOW);
    break;
  }
}

