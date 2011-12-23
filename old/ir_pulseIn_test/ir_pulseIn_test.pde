
int timer;

void setup(){
 
 Serial.begin(9600); 
 
 pinMode(2, INPUT);
  
}

void loop(){

  while(pulse > 0){
    Serial.println(pulse);  
    pulse();
  }  
  
  pulse();
  
}

void pulse(){
 
 pulse = pulseIn(2, HIGH); 
  
}
