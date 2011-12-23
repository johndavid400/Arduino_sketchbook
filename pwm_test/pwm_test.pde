

int pwm = 9;

int HI = 8;

void setup() {
  
  pinMode(pwm, OUTPUT);
  pinMode(HI, OUTPUT);
  
}


void loop() {
  
 digitalWrite(HI, HIGH);
 analogWrite(pwm, 240);
 
  
}
