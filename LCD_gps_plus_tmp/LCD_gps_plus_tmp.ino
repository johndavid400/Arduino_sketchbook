#include <SoftwareSerial.h>
#include <LiquidCrystal.h>
#include "TinyGPS++.h"

TinyGPSPlus gps;
SoftwareSerial ss(9, 10);

LiquidCrystal lcd(2, 4, 5, 6, 7, 8);

float voltage;
float tempC;
float tempF;
int potVal = 0;

void setup()
{
  Serial.begin(115200);
  ss.begin(9600);
  lcd.begin(16, 2);
}

void loop(){
  checkPot();
  if (potVal > 512){
    checkTemp();
    lcd.clear(); 
    lcd.setCursor(0, 0);
    lcd.print("Temp: ");
    lcd.print(tempF);
    delay(1000);
  }
  else {
    while (ss.available() > 0){
       gps.encode(ss.read());     
    }
    if (gps.location.isUpdated()){
      Serial.println(gps.location.lat(), 6);
      lcd.clear(); 
      lcd.setCursor(0, 0);
      lcd.print("Lat: ");
      lcd.print(gps.location.lat(), 6);
      lcd.setCursor(0, 1);
      lcd.print("Lng: ");
      lcd.print(gps.location.lng(), 6);
    }
    delay(500);
  }
}

static void smartdelay(unsigned long ms)
{
  unsigned long start = millis();
  do 
  {
    while (ss.available())
      gps.encode(ss.read());
  } 
  while (millis() - start < ms);
}

void checkTemp(){
  voltage = analogRead(3) * 5.0;
  voltage /= 1024.0;
  tempC = (voltage - 0.5) * 100;
  tempF = (tempC * 9.0 / 5.0) + 32.0; 
}

void checkPot(){
  potVal = analogRead(2);
}

