String string_one;
String string_two;
String inChar;
String stop_bit = "$";

int yellow_light = 4;
int red_green_light = 7;

void setup() {
  Serial.begin(9600);
  pinMode(yellow_light, OUTPUT);
  pinMode(red_green_light, OUTPUT);
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
      string_two = string_one;
      Serial.println(string_one);
    }
  }

  if (string_two == "red"){
    digitalWrite(red_green_light, HIGH);
    digitalWrite(yellow_light, LOW);
  }
  else if (string_two == "yellow"){
    digitalWrite(yellow_light, HIGH);
    digitalWrite(red_green_light, HIGH);
  }
  else {
    digitalWrite(red_green_light, LOW);
    digitalWrite(yellow_light, LOW);
  }
}


