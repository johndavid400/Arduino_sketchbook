// 4 digit 7-segment display from Sparkfun.com
// Letters A-G are Cathodes from the 7 segments, must be LOW to turn the led on
// digit1-4 are the common Anodes for each of the 4 digits, must be HIGH to turn led on
// you must display the 1st digits segments, then the 2nd digits segments, and so on with a delay of 5ms or less (not less than 0)
// this sketch counts up from 0:00 to 59:59 (59 minutes and 59 seconds), then resets to 0:00 and adds a decimal each hour for up to 4 hours.
int A = 1;
int B = 2;
int C = 3;
int D = 4;
int E = 5;
int F = 6;
int G = 7;

int digit1 = 8;
int digit2 = 9;
int digit3 = 10;
int digit4 = 11;

int decimal_point = 12;

int colon = 13;

int time = 0; // delay between pulses
int n = 0;

int off = B11111110;
int zero = B10000000;
int one = B11110010;
int two = B01001000;
int three = B01100000;
int four = B00110011;
int five = B00100100;
int six = B00000100;
int seven = B11110000;
int eight = B00000000;
int nine = B00100000;

int d1 = off;
int display1;
int d2 = off;
int display2;
int d3 = 0;
int display3;
int d4 = 0;
int display4;

int decimal = 0;


int digit1_on = B00110001;
int digit2_on = B00110010;
int digit3_on = B00110100;
int digit4_on = B00111000;

int digit_off = B00110000;


unsigned long timer;

void setup() {

  pinMode(A, OUTPUT); 
  pinMode(B, OUTPUT);
  pinMode(C, OUTPUT);
  pinMode(D, OUTPUT);
  pinMode(E, OUTPUT);
  pinMode(F, OUTPUT);
  pinMode(G, OUTPUT);

  pinMode(digit1, OUTPUT); 
  pinMode(digit2, OUTPUT);
  pinMode(digit3, OUTPUT);
  pinMode(digit4, OUTPUT);

  pinMode(colon, OUTPUT);
  pinMode(decimal_point, OUTPUT);

  digitalWrite(colon, HIGH);

}

void loop() {

  if (millis() > timer + 999){
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

  if (decimal == 5){
    PORTB = B00100001;
  }
  else {
    PORTB = digit1_on;  
    //digitalWrite(digit1, HIGH);
  }
  PORTD = display1;
  delay(time);
  PORTD = off;
  //digitalWrite(digit1, LOW); 
  PORTB = digit_off;

  //////////////  write digit 2

  if (decimal == 4){
    PORTB = B00100010;
  }
  else{
    PORTB = digit2_on;
    //digitalWrite(digit2, HIGH);
  }
  PORTD = display2;
  delay(time);
  PORTD = off;
  //digitalWrite(digit2, LOW);
  PORTB = digit_off;

  //////////////// write digit 3

  if (decimal == 3){
    PORTB = B00100100;
  }
  else{
    PORTB = digit3_on;
    //digitalWrite(digit3, HIGH); 
  }
  PORTD = display3;
  delay(time);
  PORTD = off;
  //digitalWrite(digit3, LOW);
  PORTB = digit_off;

  /////////////// write digit 4

  if (decimal == 2){
    PORTB = B00101000;
  }
  else{
    PORTB = digit4_on;
    //digitalWrite(digit4, HIGH);
  }
  PORTD = display4;
  delay(time);
  PORTD = off;
  //digitalWrite(digit4, LOW);
  PORTB = digit_off;

  ///////// end of loop

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

