char A;
char B;
char C;
void setup(){
  Serial.begin(9600);
  
}
void loop(){
if (Serial.available() > 0) {
char inByte = Serial.read();
        if (inByte == 'A') {
            // send bytes out here:
            Serial.print(A, BYTE);
            Serial.print(B, BYTE);
            Serial.print(C, BYTE);
        }

}
}
