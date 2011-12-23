// 4 digit 7-segment display from Sparkfun.com
// Letters A-G are Cathodes from the 7 segments, must be LOW to turn the led on
// digit1-4 are the common Anodes for each of the 4 digits, must be HIGH to turn led on
// you must display the 1st digits segments, then the 2nd digits segments, and so on with a delay of 5ms or less (not less than 0)
// this sketch counts up from 0:00 to 59:59 (59 minutes and 59 seconds), then resets to 0:00 and adds a decimal each hour for up to 4 hours.

int latchPin = 2;
int clockPin = 7;
int dataPin = 4;

int time = 0; // delay between pulses
int n = 0;

int off = B11111111;
int zero = B11000000;
int one = B11111001;
int two = B10100100;
int three = B10110000;
int four = B10011001;
int five = B10010010;
int six = B10000010;
int seven = B11111000;
int eight = B10000000;
int nine = B10010000;

int shift1_off = B11111111;
int shift2_off = B11110000;

int digit1_on = B11000001;
int digit2_on = B11000010;
int digit3_on = B11000100;
int digit4_on = B11001000;

int digit1_decimal_on = B10000001;
int digit2_decimal_on = B10000010;
int digit3_decimal_on = B10000100;
int digit4_decimal_on = B10001000;

int digit_off = B11000000;

int d1 = off;
int display1;
int d2 = off;
int display2;
int d3 = 0;
int display3;
int d4 = 0;
int display4;

int decimal = 0;

unsigned long timer;

void setup() {

  Serial.begin(9600);
  
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);

}

void loop() {

  if (millis() >= timer + 999){
    timer = millis();
    d4++; 
  }

  if (d4 >= 10) {
    d4 = 0; 
    d3++;
  }
  if (d3 >= 6) {
    d3 = 0;
    d2++;
  }
  if (d2 >= 10) {
    d2 = 0;
    d1++;
  }
  if (d1 >= 6) {
    d1 = 0;
    decimal++;
  }

  number_4();
  number_3();
  number_2();
  number_1();


  if (decimal >= 6){
    decimal = 0;
  }


  ///////////////


  digitalWrite(latchPin, LOW);
  if (decimal == 5){
    shiftOut(dataPin, clockPin, MSBFIRST, digit1_decimal_on); 
  }
  else{
    shiftOut(dataPin, clockPin, MSBFIRST, digit1_on); 
  }
  shiftOut(dataPin, clockPin, MSBFIRST, display1); 
  digitalWrite(latchPin, HIGH);
  delay(time);
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, MSBFIRST, shift2_off); 
  shiftOut(dataPin, clockPin, MSBFIRST, shift1_off);

  digitalWrite(latchPin, HIGH);


  //////////////  write digit 2


  digitalWrite(latchPin, LOW);
  if (decimal == 4){
    shiftOut(dataPin, clockPin, MSBFIRST, digit2_decimal_on); 
  }
  else{
    shiftOut(dataPin, clockPin, MSBFIRST, digit2_on); 
  }
  shiftOut(dataPin, clockPin, MSBFIRST, display2); 
  digitalWrite(latchPin, HIGH);
  delay(time);
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, MSBFIRST, shift2_off); 
  shiftOut(dataPin, clockPin, MSBFIRST, shift1_off);

  digitalWrite(latchPin, HIGH);


  //////////////// write digit 3


  digitalWrite(latchPin, LOW);
  if (decimal == 3){
    shiftOut(dataPin, clockPin, MSBFIRST, digit3_decimal_on); 
  }
  else{
    shiftOut(dataPin, clockPin, MSBFIRST, digit3_on); 
  }  
  shiftOut(dataPin, clockPin, MSBFIRST, display3); 
  digitalWrite(latchPin, HIGH);
  delay(time);
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, MSBFIRST, shift2_off); 
  shiftOut(dataPin, clockPin, MSBFIRST, shift1_off);

  digitalWrite(latchPin, HIGH);

  /////////////// write digit 4


  digitalWrite(latchPin, LOW);
  if (decimal == 2){
    shiftOut(dataPin, clockPin, MSBFIRST, digit4_decimal_on); 
  }
  else{
    shiftOut(dataPin, clockPin, MSBFIRST, digit4_on); 
  }  
  shiftOut(dataPin, clockPin, MSBFIRST, display4); 
  digitalWrite(latchPin, HIGH);
  delay(time);
  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, MSBFIRST, shift2_off); 
  shiftOut(dataPin, clockPin, MSBFIRST, shift1_off);

  digitalWrite(latchPin, HIGH);

  ///////// end of loop
/*
Serial.print(d1);
Serial.print(d2);
Serial.print(":");
Serial.print(d3);
Serial.print(d4);
Serial.print("    ");
Serial.println(decimal);
*/

}

void number_4(){
  if (d4 == 0){
    display4 = zero;
  }   
  if (d4 == 1){
    display4 = one;
  }
  if (d4 == 2){
    display4 = two;
  }
  if (d4 == 3){
    display4 = three;
  }
  if (d4 == 4){
    display4 = four;
  }
  if (d4 == 5){
    display4 = five;
  }
  if (d4 == 6){
    display4 = six;
  }
  if (d4 == 7){
    display4 = seven;
  }
  if (d4 == 8){
    display4 = eight;
  }
  if (d4 == 9){
    display4 = nine;
  }
}


void number_3(){
  if (d3 == 0){
    display3 = zero;
  }   
  if (d3 == 1){
    display3 = one;
  }
  if (d3 == 2){
    display3 = two;
  }
  if (d3 == 3){
    display3 = three;
  }
  if (d3 == 4){
    display3 = four;
  }
  if (d3 == 5){
    display3 = five;
  }
  if (d3 == 6){
    display3 = six;
  }
  if (d3 == 7){
    display3 = seven;
  }
  if (d3 == 8){
    display3 = eight;
  }
  if (d3 == 9){
    display3 = nine;
  }
}

void number_2(){
  if (d2 == 0){
    display2 = zero;
  }   
  if (d2 == 1){
    display2 = one;
  }
  if (d2 == 2){
    display2 = two;
  }
  if (d2 == 3){
    display2 = three;
  }
  if (d2 == 4){
    display2 = four;
  }
  if (d2 == 5){
    display2 = five;
  }
  if (d2 == 6){
    display2 = six;
  }
  if (d2 == 7){
    display2 = seven;
  }
  if (d2 == 8){
    display2 = eight;
  }
  if (d2 == 9){
    display2 = nine;
  }
}

void number_1(){
  if (d1 == 0){
    display1 = zero;
  }   
  if (d1 == 1){
    display1 = one;
  }
  if (d1 == 2){
    display1 = two;
  }
  if (d1 == 3){
    display1 = three;
  }
  if (d1 == 4){
    display1 = four;
  }
  if (d1 == 5){
    display1 = five;
  }
  if (d1 == 6){
    display1 = six;
  }
  if (d1 == 7){
    display1 = seven;
  }
  if (d1 == 8){
    display1 = eight;
  }
  if (d1 == 9){
    display1 = nine;
  }
}

