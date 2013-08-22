#include "LPD8806.h"
#include "SPI.h"

// Example to control LPD8806-based RGB LED Modules in a strip

/*****************************************************************************/

// Number of RGB LEDs in strand:
int nLEDs = 32;

// Chose 2 pins for output; can be any valid output pins:
int dataPin  = 2;
int clockPin = 3;

// First parameter is the number of LEDs in the strand.  The LED strips
// are 32 LEDs per meter but you can extend or cut the strip.  Next two
// parameters are SPI data and clock pins:
LPD8806 strip = LPD8806(nLEDs, dataPin, clockPin);

// You can optionally use hardware SPI for faster writes, just leave out
// the data and clock pin parameters.  But this does limit use to very
// specific pins on the Arduino.  For "classic" Arduinos (Uno, Duemilanove,
// etc.), data = pin 11, clock = pin 13.  For Arduino Mega, data = pin 51,
// clock = pin 52.  For 32u4 Breakout Board+ and Teensy, data = pin B2,
// clock = pin B1.  For Leonardo, this can ONLY be done on the ICSP pins.
//LPD8806 strip = LPD8806(nLEDs);
// strip.Color(green, red, blue) and values are between 0 and 127

int time = 10000;

void setup() {
  Serial.begin(9600);
  // Start up the LED strip
  strip.begin();
  // Update the strip, to start they are all 'off'
  strip.show();
}

void clear_leds(){
 for(int i=0; i<strip.numPixels(); i++) strip.setPixelColor(i, 0); 
}

void loop() {
  
  solid_rainbow();   
  strip.show(); 
  delay(time);
  clear_leds();
  
  speckled_rainbow();   
  strip.show(); 
  delay(time);
  clear_leds();
  
  jamaica();   
  strip.show(); 
  delay(time);
  clear_leds();
  
  unicorn();   
  strip.show(); 
  delay(time);
  clear_leds();
  
  unicorn2();   
  strip.show(); 
  delay(time);
  clear_leds();  
  
  
}

void speckled_rainbow(){
 
    strip.setPixelColor(0, strip.Color( 127, 0, 127));
    strip.setPixelColor(1, strip.Color( 32, 0, 127));
    strip.setPixelColor(2, strip.Color( 0, 0, 127));
    strip.setPixelColor(3, strip.Color( 0, 127, 127));
    strip.setPixelColor(4, strip.Color( 0, 127, 0));
    strip.setPixelColor(5, strip.Color( 64, 127, 0));
    strip.setPixelColor(6, strip.Color( 127, 127, 0));
    strip.setPixelColor(7, strip.Color( 127, 0, 0));

    strip.setPixelColor(8, strip.Color( 127, 0, 127));
    strip.setPixelColor(9, strip.Color( 32, 0, 127));
    strip.setPixelColor(10, strip.Color( 0, 0, 127));
    strip.setPixelColor(11, strip.Color( 0, 127, 127));
    strip.setPixelColor(12, strip.Color( 0, 127, 0));
    strip.setPixelColor(13, strip.Color( 64, 127, 0));
    strip.setPixelColor(14, strip.Color( 127, 127, 0));
    strip.setPixelColor(15, strip.Color( 127, 0, 0));  
  
    strip.setPixelColor(16, strip.Color( 127, 0, 127));
    strip.setPixelColor(17, strip.Color( 32, 0, 127));
    strip.setPixelColor(18, strip.Color( 0, 0, 127));
    strip.setPixelColor(19, strip.Color( 0, 127, 127));
    strip.setPixelColor(20, strip.Color( 0, 127, 0));
    strip.setPixelColor(21, strip.Color( 64, 127, 0));
    strip.setPixelColor(22, strip.Color( 127, 127, 0));
    strip.setPixelColor(23, strip.Color( 127, 0, 0));
    
    strip.setPixelColor(24, strip.Color( 127, 0, 127));
    strip.setPixelColor(25, strip.Color( 32, 0, 127));
    strip.setPixelColor(26, strip.Color( 0, 0, 127));
    strip.setPixelColor(27, strip.Color( 0, 127, 127));
    strip.setPixelColor(28, strip.Color( 0, 127, 0));
    strip.setPixelColor(29, strip.Color( 64, 127, 0));
    strip.setPixelColor(30, strip.Color( 127, 127, 0));
    strip.setPixelColor(31, strip.Color( 127, 0, 0));

}


void solid_rainbow(){
  for (int i = 0; i <= 3; i++){
    strip.setPixelColor(i, strip.Color( 127, 0, 127));
  }
  for (int i = 4; i <= 7; i++){
    strip.setPixelColor(i, strip.Color( 32, 0, 127));
  }
  for (int i = 8; i <= 11; i++){    
    strip.setPixelColor(i, strip.Color( 0, 0, 127));
  }
  for (int i = 12; i <= 15; i++){
    strip.setPixelColor(i, strip.Color( 0, 127, 127));
  }
  for (int i = 16; i <= 19; i++){
    strip.setPixelColor(i, strip.Color( 0, 127, 0));
  }
  for (int i = 20; i <= 23; i++){
    strip.setPixelColor(i, strip.Color( 64, 127, 0));
  }
  for (int i = 24; i <= 27; i++){ 
    strip.setPixelColor(i, strip.Color( 127, 127, 0));
  }
  for (int i = 28; i <= 31; i++){
    strip.setPixelColor(i, strip.Color( 127, 0, 0));
  }
}

void jamaica(){
  for (int i = 0; i <= 10; i++){
    strip.setPixelColor(i, strip.Color( 127, 0, 0));
  }
  for (int i = 11; i <= 21; i++){
    strip.setPixelColor(i, strip.Color( 127, 127, 0));
  }
  for (int i = 22; i <= 31; i++){    
    strip.setPixelColor(i, strip.Color( 0, 127, 0));
  }
}

void unicorn(){
  for (int i = 0; i <= 10; i++){
    strip.setPixelColor(i, strip.Color( 127, 0, 64));
  }
  for (int i = 11; i <= 21; i++){
    strip.setPixelColor(i, strip.Color( 127, 127, 0));
  }
  for (int i = 22; i <= 31; i++){    
    strip.setPixelColor(i, strip.Color( 0, 127, 127));
  }
}

void unicorn2(){

    strip.setPixelColor(0, strip.Color( 127, 0, 64));
    strip.setPixelColor(1, strip.Color( 127, 127, 0)); 
    strip.setPixelColor(2, strip.Color( 0, 127, 127));    
 
    strip.setPixelColor(3, strip.Color( 127, 0, 64));
    strip.setPixelColor(4, strip.Color( 127, 127, 0)); 
    strip.setPixelColor(5, strip.Color( 0, 127, 127));    

    strip.setPixelColor(6, strip.Color( 127, 0, 64));
    strip.setPixelColor(7, strip.Color( 127, 127, 0)); 
    strip.setPixelColor(8, strip.Color( 0, 127, 127));    
    
    strip.setPixelColor(9, strip.Color( 127, 0, 64));
    strip.setPixelColor(10, strip.Color( 127, 127, 0)); 
    strip.setPixelColor(11, strip.Color( 0, 127, 127));    
   
    strip.setPixelColor(12, strip.Color( 127, 0, 64));
    strip.setPixelColor(13, strip.Color( 127, 127, 0)); 
    strip.setPixelColor(14, strip.Color( 0, 127, 127));    

    strip.setPixelColor(15, strip.Color( 127, 0, 64));
    strip.setPixelColor(16, strip.Color( 127, 127, 0)); 
    strip.setPixelColor(17, strip.Color( 0, 127, 127));    
 
    strip.setPixelColor(18, strip.Color( 127, 0, 64));
    strip.setPixelColor(19, strip.Color( 127, 127, 0)); 
    strip.setPixelColor(20, strip.Color( 0, 127, 127));    
 
    strip.setPixelColor(21, strip.Color( 127, 0, 64));
    strip.setPixelColor(22, strip.Color( 127, 127, 0)); 
    strip.setPixelColor(23, strip.Color( 0, 127, 127));    

    strip.setPixelColor(24, strip.Color( 127, 0, 64));
    strip.setPixelColor(25, strip.Color( 127, 127, 0)); 
    strip.setPixelColor(26, strip.Color( 0, 127, 127));    
 
    strip.setPixelColor(27, strip.Color( 127, 0, 64));
    strip.setPixelColor(28, strip.Color( 127, 127, 0)); 
    strip.setPixelColor(29, strip.Color( 0, 127, 127));    
  
    strip.setPixelColor(30, strip.Color( 127, 0, 64));
    strip.setPixelColor(31, strip.Color( 127, 127, 0));   

}

