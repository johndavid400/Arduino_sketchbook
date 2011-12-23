// Read pulse signal from an IR sensor using interrupts for quick readings

volatile int pulse = 0;
volatile long startPulse = 0;
int ticker = 0;
int x = 0;
int ir_vals[25];
int pulsed;

void setup(){
  Serial.begin(19200); 
  pinMode(2, INPUT);
  //attachInterrupt(0, pulse_begin, RISING);    // catch interrupt 0 (digital pin 2) going HIGH and send to rc1()
}
/*
void pulse_begin() {           // enter rc1_begin when interrupt pin goes HIGH.
 startPulse = micros();     // record microseconds() value as servo1_startPulse
 detachInterrupt(0);  // after recording the value, detach the interrupt from rc1_begin
 attachInterrupt(0, pulse_end, FALLING); // re-attach the interrupt as rc1_end, so we can record the value when it goes low
 }
 
 void pulse_end() {
 pulse = micros() - startPulse;  // when interrupt pin goes LOW, record the total pulse length by subtracting previous start value from current micros() vlaue.
 detachInterrupt(0);  // detach and get ready to go HIGH again
 attachInterrupt(0, pulse_begin, RISING); 
 }
 */
void loop(){

  pulse = pulseIn(2, HIGH);

  if (pulse > 0){

    if (pulse < 750){
      pulse = 0;
    }
    else if (pulse > 750 ){
      if (pulse >= 2000){
        pulse = 2;
      }
      else{
        pulse = 1;
      }
    }


    ir_vals[x] = pulse;
    x++;
    pulse = 0;
    pulsed = 1;
  }
  else {
    if (pulsed == 1){

      for (int i = 0; i <= 25; i++){
        Serial.print(i);
        Serial.print(":   ");
        Serial.println(ir_vals[i]);
      } 

      Serial.println("  ");
      Serial.println(" received signal ");
      Serial.println("  ");
      check_pulse();
      pulsed = 0;
      x = 0;

    }
    else {        
    }
  }
}


void check_pulse(){

  if (ir_vals[0] == 2){

    if (ir_vals[23] == 1){
      // then (pause, rec, tv/vcr, up, or down

      if (ir_vals[17] == 1){            
        // then (rec, go back, or tv/vrc)   
        if (ir_vals[19] == 1){
          Serial.println("Record");
        }
        else {
          if (ir_vals[18] == 1){
            Serial.println("Go Back");
          }
          else {
            Serial.println("TV/VCR");
          }
        } 
      }
      else {                               
        // then (pause, up, or down)
        if (ir_vals[18] == 1){
          // then up or down        
          if (ir_vals[20] == 1){
            Serial.println("UP");
          } 
          else {
            Serial.println("Down"); 
          }
        }
        else{
          Serial.println("Pause"); 
        }
      }
    }

    else if (ir_vals[21] == 1){
      // then (ch up, ch dn, info, left, right, <<, >>, play or stop)
      if (ir_vals[17] == 1){
        // then (ch up, right, <<, >>, or stop)
        if (ir_vals[18] == 1){
          // then (ch up or right)
          if (ir_vals[20] == 1){
            Serial.println("Right");
          }
          else {
            if (ir_vals[19] == 1){
              Serial.println("Channel Up"); 
            }
            else {
              Serial.println("OK");
            }
          }
        }
        else {
          // then (<<, >>, or stop)
          if (ir_vals[19] == 1){
            // then (>> or stop)
            if (ir_vals[20] == 1){
              Serial.println("Stop");
            } 
            else {
              Serial.println(">>"); 
            }
          }
          else {
            if (ir_vals[20] == 1){
              Serial.println("Power");
            }
            else {
              Serial.println("<<"); 
            }
          }
        }  
      }
      else{
        // then (ch dn, info, left, play)
        if (ir_vals[18] == 1){
          // then (play or left)
          if (ir_vals[19] == 1){
            Serial.println("Left");
          }
          else {
            Serial.println("Play");
          }
        }
        else {
          // then (ch dn or info)
          if (ir_vals[19] == 1){
            Serial.println("Info");
          }
          else {
            if (ir_vals[20] == 1){
              Serial.println("Channel Down"); 
            }
            else {
              Serial.println("Menu"); 
            }
          }
        }
      }    
    }


    else {
      // then (numbers 0-9, enter or clear)

      if (ir_vals[20] == 1){
        // then (7, 8, 9, 0, enter, or clear)
        if (ir_vals[19] == 1){
          //then (0, enter, or clear)
          if (ir_vals[18] == 1){
            // then (enter or clear)
            if (ir_vals[17] == 1){
              Serial.println("Enter");
            } 
            else{
              Serial.println("Clear"); 
            }
          }
          else {
            Serial.println("number 0");
          }   
        }
        else {
          // then (7, 8, or 9)
          if (ir_vals[18] == 1){
            // then (8 or 9)
            if (ir_vals[17] == 1){
              Serial.println("number 8");
            } 
            else {
              Serial.println("number 9"); 
            }
          }
          else {
            Serial.println("number 7"); 
          }
        }
      }


      else {
        // then (1, 2, 3, 4, 5, or 6)
        if (ir_vals[19] == 1){
          // then (4, 5, or 6)
          if (ir_vals[18] == 1){
            Serial.println("number 6");
          }
          else {
            // then (4 or 5)
            if (ir_vals[17] == 1){
              Serial.println("number 5"); 
            }
            else {
              Serial.println("number 4"); 
            }
          } 
        }
        else {
          // then (1, 2, or 3)
          if (ir_vals[18] == 1){
            Serial.println("number 3");
          }
          else {
            // then (1 or 2)
            if (ir_vals[17] == 1){
              Serial.println("number 2"); 
            }
            else {
              Serial.println("number 1"); 
            }
          }
        }
      }
    }
  }


  else {
    // then (mute, vol up, or vol down)
    if (ir_vals[1] == 2 && ir_vals[7] == 2){
      // just to be sure
      if (ir_vals[19] == 2){
        Serial.println("Mute"); 
      }
      else if (ir_vals[20] == 2){
        Serial.println("Volume Down"); 
      }
      else if (ir_vals[19] == 1 && ir_vals[20] == 1){
        Serial.println("Volume Up"); 
      }
    }   
  }

}


























