// BattleBot
// Controls 2 Sabertooth motor-controllers using R/C pulse signal
// Controls battle-bot weapon using OSMC (open-source motor=controller)
// Decodes 2 R/C servo signals for the Left and Right drive channels (Sabertooth)
// Decodes 1 R/C servo signal for weapon (OSMC)
//
//

int RC_1 = 14; 
int RC_2 = 15;
int RC_3 = 16;

int servo3_val; 
int servo3_Ready;

int adj_val3;  

int deadband = 10;

int Left_OUT = 17;
int Right_OUT = 18;

/////

int OSMC_BHI = 8; 
int OSMC_BLI = 11;  // PWM pin
int OSMC_ALI = 10;  // PWM pin
int OSMC_AHI = 9; 

int LED_1 = 12;
int LED_2 = 13;

// timer variables
int last_update;
int cycle_time;
long last_cycle = 0;

//volatile long servo1_startPulse;  //values for channel 1 signal capture
//volatile 
int servo1_val; 
int adj_val1;  
int servo1_Ready;

//volatile long servo2_startPulse; //values for channel 2 signal capture
//volatile 
int servo2_val; 
int adj_val2;  
int servo2_Ready;


void setup() {

  TCCR1B = TCCR1B & 0b11111000 | 0x01;
  TCCR2B = TCCR2B & 0b11111000 | 0x01;

  Serial.begin(9600);

  //motor pins
  pinMode(OSMC_ALI, OUTPUT);
  pinMode(OSMC_AHI, OUTPUT);
  pinMode(OSMC_BLI, OUTPUT);
  pinMode(OSMC_BHI, OUTPUT);

  //led's
  pinMode(LED_1, OUTPUT);
  pinMode(LED_2, OUTPUT);

  pinMode(Left_OUT, OUTPUT);
  pinMode(Right_OUT, OUTPUT);

  //PPM inputs from RC receiver
  pinMode(RC_1, INPUT);
  pinMode(RC_2, INPUT); 
  pinMode(RC_3, INPUT);

  digitalWrite(OSMC_BHI, LOW); // AHI and BHI should be HIGH for electric brake
  digitalWrite(OSMC_ALI, LOW);
  digitalWrite(OSMC_AHI, LOW); // AHI and BHI should be HIGH for electric brake
  digitalWrite(OSMC_BLI, LOW); 

  //attachInterrupt(0, rc1_begin, RISING);    // catch interrupt 0 (digital pin 2) going HIGH and send to rc1()
  //attachInterrupt(1, rc2_begin, RISING);    // catch interrupt 1 (digital pin 3) going HIGH and send to rc2()

  digitalWrite(LED_1, HIGH);
  digitalWrite(LED_2, LOW);
  delay(1000); 
  digitalWrite(LED_2, HIGH);
  digitalWrite(LED_1, LOW);
  delay(1000); 
  digitalWrite(LED_2, LOW);

  digitalWrite(OSMC_ALI, HIGH);
  digitalWrite(OSMC_BLI, HIGH);  

}



/*
///////// attach servo signal interrupts to catch signals as they go HIGH then again as they go LOW, then calculate the pulse length


void rc1_begin() {           // enter rc1_begin when interrupt pin goes HIGH.

  servo1_startPulse = micros();     // record microseconds() value as servo1_startPulse

  detachInterrupt(0);  // after recording the value, detach the interrupt from rc1_begin

  attachInterrupt(0, rc1_end, FALLING); // re-attach the interrupt as rc1_end, so we can record the value when it goes low

}

void rc1_end() {

  servo1_val = micros() - servo1_startPulse;  // when interrupt pin goes LOW, record the total pulse length by subtracting previous start value from current micros() vlaue.

  detachInterrupt(0);  // detach and get ready to go HIGH again

  attachInterrupt(0, rc1_begin, RISING);

}

void rc2_begin() {

  servo2_startPulse = micros();

  detachInterrupt(1);

  attachInterrupt(1, rc2_end, FALLING);

}

void rc2_end() {

  servo2_val = micros() - servo2_startPulse;

  detachInterrupt(1);

  attachInterrupt(1, rc2_begin, RISING); 

}
/////// servo interrupts end

*/



void loop() {

  servo1_val = pulseIn(RC_1, HIGH, 20000);
  servo2_val = pulseIn(RC_2, HIGH, 20000);
  servo3_val = pulseIn(RC_3, HIGH, 20000);
  

  if (servo1_val < 1550 && servo1_val > 1450){
    digitalWrite(LED_1, HIGH);
  }
  else{
    digitalWrite(LED_1, LOW); 
  }

  if (servo2_val < 1550 && servo2_val > 1450){
    digitalWrite(LED_2, HIGH);
  }  
  else{
    digitalWrite(LED_2, LOW); 
  }  


  if (servo1_val > 0 && servo2_val > 0) {

    if (servo3_val > 800 && servo3_val < 2200){	

      adj_val3 = map(servo3_val, 1000, 1900, -255, 255);

      if (adj_val3 > 255){
        adj_val3 = 255;
      }
      if (adj_val3 < -255){
        adj_val3 = -255;
      }

      if (adj_val3 > deadband){
        weapon_forward(adj_val3);
      }
      else if (adj_val3 < -deadband){
        adj_val3 = adj_val3 * -1;
        weapon_reverse(adj_val3);
      }
      else {
        weapon_stop();
        adj_val3 = 0;
      }
    }
  }

  else{
    servo1_val = 1500;
    servo2_val = 1500;
    servo3_val = 0;
    acquiring();
  }

  Send_Pulses();


  /*
   
   time_stamp();
   
   Serial.print("Left channel:  ");
   Serial.print(servo2_val);
   Serial.print("   ");
   
   Serial.print("Right channel:  ");
   Serial.print(servo1_val);
   Serial.print("   ");
   
   Serial.print("Weapon adjusted:  ");
   Serial.print(adj_val3);
   Serial.print("   ");
   
   Serial.print("Weapon channel:  ");
   Serial.print(servo3_val);
   Serial.print("   ");
   
   Serial.print("Time:  ");
   Serial.print(cycle_time);
   Serial.println("   ");
   */



}

void acquiring(){

  digitalWrite(LED_1, HIGH);
  digitalWrite(LED_2, LOW);
  delay(300); 
  digitalWrite(LED_2, HIGH);
  digitalWrite(LED_1, LOW);
  delay(300); 
  digitalWrite(LED_2, LOW);

}

void Send_Pulses(){

  digitalWrite(Right_OUT, HIGH);
  delayMicroseconds(servo1_val);
  digitalWrite(Right_OUT, LOW);

  digitalWrite(Left_OUT, HIGH);
  delayMicroseconds(servo2_val);
  digitalWrite(Left_OUT, LOW);

}

void weapon_forward(int speed_val1){
  digitalWrite(OSMC_BLI, LOW);
  analogWrite(OSMC_ALI, speed_val1);  
}

void weapon_reverse(int speed_val2){
  digitalWrite(OSMC_ALI, LOW);
  analogWrite(OSMC_BLI, speed_val2); 
}

void weapon_stop() {
  digitalWrite(OSMC_ALI, LOW);
  digitalWrite(OSMC_BLI, LOW);  
}


void time_stamp(){
  cycle_time = millis() - last_cycle;
  last_cycle = millis(); 
}





