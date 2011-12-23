
int serial_in;

void setup(){
 
 Serial.begin(9600);

 
  
}


void loop(){
  
 if (Serial.available() > 0){
  
  serial_in = Serial.read();
   
  Serial.print("BYTE: "); 
  Serial.print(serial_in, BYTE);
  Serial.print("        ");
  Serial.print("BIN: ");
  Serial.print(serial_in, BIN);
  Serial.print("        "); 
  Serial.print("DEC: ");
  Serial.println(serial_in, DEC);
  
 }
  
  
  
}
