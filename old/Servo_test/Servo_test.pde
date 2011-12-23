

// Test Servo


int servo_pin = 13;

int servo_position = 1500;


void setup(){
  
 Serial.begin(9600);

 pinMode(servo_pin, OUTPUT); 
  
}


 void loop(){
   
 
   digitalWrite(servo_pin, HIGH);
   delayMicroseconds(servo_position);
   digitalWrite(servo_pin, LOW);

   delay(18);   
  
   
 }

