int pin1 = 3;
int pin2 = 5;
int pin3 = 6;

int pot1 = 0;
int pot2 = 1;
int pot3 = 2;

int potVal1 = 0;
int potVal2 = 0;
int potVal3 = 0;

int button = 2;
int buttonState = 0;
int buttonVal;

long value3;
long value2;
long value1;

long current_value3;
long current_value2;
long current_value1;
int x;
void setup(){

randomSeed(analogRead(0));

value1 = random(255);
current_value1 = value1;
value2 = random(255);
current_value2 = value2;
value3 = random(255);
current_value3 = value3;

analogWrite(pin1, current_value1);
analogWrite(pin2, current_value2);
analogWrite(pin3, current_value3);

value1 = random(255);
value2 = random(255);
value3 = random(255);
}

void loop(){
 buttonState = digitalRead(button);
  
 potVal1 = analogRead(pot1) / 4;
 potVal2 = analogRead(pot2) / 4;
 potVal3 = analogRead(pot3) / 4; 
 
 if (buttonState == LOW){
  analogWrite(pin1, potVal1); 
  analogWrite(pin2, potVal2);
  analogWrite(pin3, potVal3);
 }
 
 else if (buttonState == HIGH){
 x = random(3, 9);
  
if (value1 > current_value1){
  
  current_value1++;
  analogWrite(pin1, current_value1);
  delay(x);
}
  
if (value1 < current_value1){

 current_value1--;
analogWrite(pin1, current_value1);
delay(x);
  
}

if (value1 == current_value1){

 analogWrite(pin1, current_value1);
 value1 = random(255);
  
}
  
  
  
  //////////////////////////
  
  if (value2 > current_value2){
  
  current_value2++;
  analogWrite(pin2, current_value2);
  delay(x);
}
  
if (value2 < current_value2){

 current_value2--;
analogWrite(pin2, current_value2);
delay(x);
  
}

if (value2 == current_value2){

 analogWrite(pin2, current_value2);
 value2 = random(255);
  
}




///////////////////////////////



if (value3 > current_value3){
  
  current_value3++;
  analogWrite(pin3, current_value3);
  delay(x);
}
  
if (value3 < current_value3){

 current_value3--;
analogWrite(pin3, current_value3);
delay(x);
  
}

if (value3 == current_value3){

 analogWrite(pin3, current_value3);
 value3 = random(255);
  
}
}
}
