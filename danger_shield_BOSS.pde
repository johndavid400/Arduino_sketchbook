// DangerShield code
// Plug on top of Arduino, load code, and play!
// Change whatever you want
// JDW 2011

//////// I/O pins defined /////////////

// main leds
int led1 = 5;
int led2 = 6;

// potentiometer leds
int slider_led1 = 11;
int slider_led2 = 10;
int slider_led3 = 9;

// button switches
int button1 = 2;
int button2 = 7;
int button3 = 4;

// shift register (7-segment LED)
int latch = 8;
int clock = 12;
int data = 13;

// analog inputs
int slider1 = 2;
int slider2 = 1;
int slider3 = 0;

int light_sensor = 3;

///////////  variables /////////////

int potVal1;
int potVal2;
int potVal3;

int lightVal;
int numVal;

int switchVal1; 
int switchVal2; 
int switchVal3;

int button_fx = 1;

// define shift register light patterns for each number (will probably need to be changed to display correct numbers)
byte turn_off = B00000000;
byte one = B01100000;
byte two = B11011010;
byte three = B11110010;
byte four = B01100110;
byte five = B10110110;
byte six = B10111110;
byte seven = B11100000;
byte eight = B11111110;
byte nine = B11100110;

/////// end variable declaration //////

void setup(){

  Serial1.begin(19200);

  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);

  pinMode(slider_led1, OUTPUT);
  pinMode(slider_led2, OUTPUT);
  pinMode(slider_led3, OUTPUT);

  pinMode(latch, OUTPUT);
  pinMode(clock, OUTPUT);
  pinMode(data, OUTPUT);

  pinMode(button1, INPUT);
  pinMode(button2, INPUT);
  pinMode(button3, INPUT);

  pinMode(slider1, INPUT);
  pinMode(slider2, INPUT);
  pinMode(slider3, INPUT);

  pinMode(light_sensor, INPUT);

}

void loop(){

  // read sliding pot and set LED accordingly
  potVal1 = analogRead(slider1);
  potVal1 = map(potVal1, 0, 1023, 1023, 0);
  
  potVal2 = analogRead(slider2);
  potVal2 = map(potVal2, 0, 1023, 255, 0);
  
  potVal3 = analogRead(slider3); 
  potVal3 = map(potVal3, 0, 1023, 10, 0);

  // read light sensor and knock sensor
  lightVal = analogRead(light_sensor);

  // read button switches
  switchVal1 = digitalRead(button1);
  switchVal2 = digitalRead(button2);
  switchVal3 = digitalRead(button3);

  // Update the buttons
  update_buttons();
  // update the 7-segment LED array
  seven_segment();
  // update the LEDs
  leds();
  // update the values sent to the serial monitor
  serial_print_values();

  delay(20);
}


void update_buttons(){

  // check button switches and command slider LEDs on or off

  // use button 1 to determine function state
  if (switchVal1 == HIGH){
    delay(50);
    if (switchVal1 == HIGH){
      delay(100);
      button_fx++; 
      if (button_fx > 2){
        button_fx = 1; 
      }
    }
  }

  // depending on button_fx state, change state of slider led 1
  if (button_fx == 2){
    digitalWrite(slider_led1, HIGH);
  }
  else {
    digitalWrite(slider_led1, LOW); 
  }

  // set the led on slider2 to equal the button 2 state
  if (switchVal2 == HIGH){
    digitalWrite(slider_led2, HIGH); 
  }
  else {
    digitalWrite(slider_led2, LOW); 
  }
  
  // set the led on slider3 to be OPPOSITE the button 3 state
  if (switchVal3 == HIGH){
    digitalWrite(slider_led3, LOW); 
  }
  else {
    digitalWrite(slider_led3, HIGH); 
  }
}



void leds(){
  
  // if button_fx state is equal to 1, write inverse values to the 2 side LEDs
  if (button_fx == 1){
    analogWrite(led1, potVal2);
    analogWrite(led2, 255 - potVal2);
  }
  // if button_fx state is not equal to 1, use individual potentiometers to control 2 side LEDs
  else {
    analogWrite(led1, potVal1 / 4);
    analogWrite(led2, potVal2);
  }

}

void seven_segment(){

  // Let's display some stuff on the 7 segment led using the 3rd potentiometer value
  // LSBFIRST, B11111110 is the same as MSBFIRST, B01111111

  if (potVal1 > 100 && potVal1 < 200){
    //ground latchPin and hold low for as long as you are transmitting
    digitalWrite(latch, LOW);
    shiftOut(data, clock, LSBFIRST, one);   
    digitalWrite(latch, HIGH);
    numVal = 1;
  }
  else if (potVal1 >= 200 && potVal1 < 300){
    digitalWrite(latch, LOW);
    shiftOut(data, clock, LSBFIRST, two);   
    digitalWrite(latch, HIGH);
    numVal = 2;
  }
  else if (potVal1 >= 300 && potVal1 < 400){
    digitalWrite(latch, LOW);
    shiftOut(data, clock, LSBFIRST, three);   
    digitalWrite(latch, HIGH);
    numVal = 3;
  }
  else if (potVal1 >= 400 && potVal1 < 500){
    digitalWrite(latch, LOW);
    shiftOut(data, clock, LSBFIRST, four);   
    digitalWrite(latch, HIGH);
    numVal = 4;
  }
  else if (potVal1 >= 500 && potVal1 < 600){
    digitalWrite(latch, LOW);
    shiftOut(data, clock, LSBFIRST, five);   
    digitalWrite(latch, HIGH);
    numVal = 5;
  }
  else if (potVal1 >= 600 && potVal1 < 700){
    digitalWrite(latch, LOW);
    shiftOut(data, clock, LSBFIRST, six);   
    digitalWrite(latch, HIGH);
    numVal = 6;
  }
  else if (potVal1 >= 700 && potVal1 < 800){
    digitalWrite(latch, LOW);
    shiftOut(data, clock, LSBFIRST, seven);   
    digitalWrite(latch, HIGH);
    numVal = 7;
  }
  else if (potVal1 >= 800 && potVal1 < 900){
    digitalWrite(latch, LOW);
    shiftOut(data, clock, LSBFIRST, eight);   
    digitalWrite(latch, HIGH);
    numVal = 8;
  }
  else if (potVal1 > 900){
    digitalWrite(latch, LOW);
    shiftOut(data, clock, LSBFIRST, nine);   
    digitalWrite(latch, HIGH);
    numVal = 9;
  }
  else{
    digitalWrite(latch, LOW);
    shiftOut(data, clock, LSBFIRST, turn_off);   
    digitalWrite(latch, HIGH);
    numVal = 0;
  }  
}


void serial_print_values(){


  // Print the 3 potentiometer values, light sensor value, and knock sensor value.

  if (button_fx == 1){
    Serial1.print("button_fx:  ");
    Serial1.print(button_fx);
    Serial1.print("   pot1:    ");
    Serial1.print(potVal1);
    Serial1.print("   pot2:    ");
    Serial1.print(potVal2);
    Serial1.print("   pot3:    ");
    Serial1.print(potVal3);
    Serial1.print("   light:    ");
    Serial1.print(lightVal);
    Serial1.print("   number:    ");
    Serial1.println(numVal);
  }
  else {
    Serial1.print("button_fx:  ");
    Serial1.print(button_fx);
    Serial1.print("   Button2:    ");
    Serial1.print(switchVal2);
    Serial1.print("   Button3:    ");
    Serial1.print(switchVal3);
    Serial1.print("   light:    ");
    Serial1.print(lightVal);
    Serial1.print("   number:    ");
    Serial1.println(numVal);
  }


}












