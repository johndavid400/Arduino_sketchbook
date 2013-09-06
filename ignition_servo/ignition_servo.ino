
int ignition = 7;
int pos = 2000;
int servo = 9;

void setup(){
 //Serial.begin(115200);
 pinMode(ignition, INPUT);
 digitalWrite(ignition, HIGH);
 pinMode(servo, OUTPUT);
 digitalWrite(servo, LOW);
}

void loop(){
  
  if(digitalRead(ignition)){
    pos = 1200;
  }
  else{
    pos = 1800;
  }
  
  digitalWrite(servo, HIGH);
  delayMicroseconds(pos);
  digitalWrite(servo, LOW);
  delay(20);
  
  //Serial.println(ignition);
}
