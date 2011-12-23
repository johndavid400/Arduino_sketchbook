// BattleBot
// Controls 2 Sabertooth motor-controllers using R/C pulse signal
// Controls battle-bot weapon using OSMC (open-source motor=controller)
// Decodes 2 R/C servo signals for the Left and Right drive channels (Sabertooth 2x25 in R/C mode)
// Decodes 1 R/C servo signal for weapon (OSMC)
//
//

int RC_1 = 14; 
int RC_2 = 15;
int RC_3 = 16;
int RC_4 = 17;

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

int servo3_val; 
int adj_val3;  
int servo3_Ready;

int servo4_val; 
int adj_val4;  
int servo4_Ready;

int deadband = 10;

int Left_OUT = 18;
int Right_OUT = 19;

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

int weapon_armed = false;

void setup() {

  TCCR1B = TCCR1B & 0b11111000 | 0x01; // changes PWM frequency on pins 9 & 10 to 32kHz
  TCCR2B = TCCR2B & 0b11111000 | 0x01; // changes PWM frequency on pins 3 & 11 to 32kHz

  Serial.begin(9600);

  //motor pins
  pinMode(OSMC_ALI, OUTPUT);
  pinMode(OSMC_AHI, OUTPUT);
  pinMode(OSMC_BLI, OUTPUT);
  pinMode(OSMC_BHI, OUTPUT);

  //led's
  pinMode(LED_1, OUTPUT);
  pinMode(LED_2, OUTPUT);

  // R/C signal outputs
  pinMode(Left_OUT, OUTPUT);
  pinMode(Right_OUT, OUTPUT);

  //PPM inputs from RC receiver
  pinMode(RC_1, INPUT);
  pinMode(RC_2, INPUT); 
  pinMode(RC_3, INPUT);
  pinMode(RC_4, INPUT);
  
  // Set all OSMC pins LOW during Setup
  digitalWrite(OSMC_BHI, LOW); // AHI and BHI should be HIGH for electric brake
  digitalWrite(OSMC_ALI, LOW);
  digitalWrite(OSMC_AHI, LOW); // AHI and BHI should be HIGH for electric brake
  digitalWrite(OSMC_BLI, LOW); 

  digitalWrite(LED_1, HIGH);
  digitalWrite(LED_2, LOW);
  delay(1000); 
  digitalWrite(LED_2, HIGH);
  digitalWrite(LED_1, LOW);
  delay(1000); 
  digitalWrite(LED_2, LOW);

  // Write OSMC Hi-side pins HIGH, enabling electric-brake for weapon motor when not being used
  digitalWrite(OSMC_AHI, HIGH);
  digitalWrite(OSMC_BHI, HIGH);  

}


void loop() {
  
  // Read R/C signals
  servo3_val = pulseIn(RC_3, HIGH, 20000);
  servo1_val = pulseIn(RC_1, HIGH, 20000);
  servo2_val = pulseIn(RC_2, HIGH, 20000);
  servo4_val = pulseIn(RC_4, HIGH, 20000);


  // One failsafe - check to see if BOTH drive channels are valid before processing
  if (servo1_val > 0 && servo2_val > 0) {

    // turn on Neutral lights for the drive channels if they are centered (individually). 
    // Uses LEDs on pins D12 & D13
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

    // another failsafe - check to see if Toggle switch is On, before enabling Weapon
    if (servo4_val > 1550){  
      
      weapon_armed = true;
      
      // If toggle switch is On, go ahead and process the Weapon value
      if (servo3_val > 800 && servo3_val < 2200){	

        // Map bi-directional value from R/C Servo pulse centered at 1500 milliseconds,
        // to a forward/reverse value centered at 0. 
        // 255 = full forward
        // 0 = Neutral
        // -255 = full reverse
        adj_val3 = map(servo3_val, 1000, 2000, -255, 255);

        // check for direction (positive or negative value)
        if (adj_val3 > 255){
          adj_val3 = 255;
        }
        if (adj_val3 < -255){
          adj_val3 = -255;
        }
        
        // write direction that we just checked for
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

      else { 
        weapon_stop();
      }
    }
    
    // disables Weapon if Drive signals are not valid - extra failsafe
    else{
      weapon_armed = false;
      weapon_stop();
    }
  }

  // If drive signals are not valid, stop using Neutral LEDs and make them blink
  // back and forth until the signal is restored - see the acquiring() function.
  else {
    servo1_val = 1500;
    servo2_val = 1500;
    
    weapon_armed = false;

    acquiring();
  }
  
  // send the R/C pulses to the Sabertooth
  Send_Pulses();

/*

  time_stamp();

  Serial.print("Left channel:  ");
  Serial.print(servo2_val);
  Serial.print("   ");

  Serial.print("Right channel:  ");
  Serial.print(servo1_val);
  Serial.print("   ");

  if (weapon_armed == true){
  Serial.print(" WEAPON ARMED! ");
  Serial.print("   ");
  
  Serial.print("Weapon channel:  ");
  Serial.print(servo3_val);
  Serial.print("   ");
  
  }
  else{
  Serial.print(" weapon disarmed: ");
  Serial.print("   ");
  }
  
  Serial.print("Time:  ");
  Serial.print(cycle_time);
  Serial.println("   ");

*/

}

void acquiring(){

  digitalWrite(LED_1, HIGH);
  digitalWrite(LED_2, LOW);
  delay(200); 
  digitalWrite(LED_2, HIGH);
  digitalWrite(LED_1, LOW);
  delay(200); 
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








