String string_one;
String inChar;
String stop_bit = "$";

void setup() {
  Serial.begin(9600);
}

void loop() {
  if (Serial.available() > 0){
    inChar = (char)Serial.read();
    if (inChar != stop_bit){ 
      string_one += inChar; 
    }
    else {
      Serial.println(string_one); 
      string_one = "";
    }
  }
}

