

int ir_val1 = 0;
int ir_val2 = 0;

int led1 = 12;
int led2 = 13;

void setup(){
 
  Serial.begin(9600);
  
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT); 
  
}


void loop() {
  
 ir_val1 = analogRead(0);
 ir_val2 = analogRead(1);

if (ir_val1 > 512){
 digitalWrite(led1, HIGH); 
}
else {
  digitalWrite(led1, LOW);
}


if (ir_val2 > 512){
 digitalWrite(led2, HIGH); 
}
else {
  digitalWrite(led2, LOW);
} 

Serial.print("Val1:  ");
Serial.print(ir_val1);
Serial.print("       ");
Serial.print("Val2:  ");
Serial.print(ir_val2);
Serial.println("       ");

  
}
