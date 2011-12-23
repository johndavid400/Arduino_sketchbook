

int bump_L = 3;
int bump_R = 2;

int bump_R_val;
int bump_L_val;

int servo_L = 4;
int servo_R = 5;

int servo_R_stop = 1715;
int servo_L_stop = 1657;

int servo_R_forward = servo_R_stop + 500;
int servo_L_forward = servo_L_stop - 500;

int servo_R_reverse = servo_R_stop - 500;
int servo_L_reverse = servo_L_stop + 500;

int position_L;
int position_R;

unsigned long last_refresh = 0;

unsigned long bump_right_startTick;
unsigned long bump_left_startTick;
unsigned long bump_both_startTick;

int pulse = 0;
int x = 0;
int ir_vals[25];
int pulsed;


void setup(){

  Serial.begin(9600);

  pinMode(4, INPUT);

  pinMode(bump_R, INPUT); 
  digitalWrite(bump_R, HIGH);

  pinMode(bump_L, INPUT); 
  digitalWrite(bump_L, HIGH);

  pinMode(servo_R, OUTPUT); 
  pinMode(servo_L, OUTPUT); 

}

void loop(){

  bump_R_val = digitalRead(bump_R);
  bump_L_val = digitalRead(bump_L);


  if (bump_R_val == 0 || bump_L_val == 0){

    if (bump_R_val == 0 && bump_L_val == 1){
      
      Serial.println("Right");  

      bump_right_startTick = millis();  

      while(millis() < bump_right_startTick + 1000){ 
        position_R = servo_R_stop;
        position_L = servo_L_stop;  
        refresh_motors();
      }
      bump_right_startTick = millis();  

      while(millis() < bump_right_startTick + 1000){ 
        position_R = servo_R_reverse;
        position_L = servo_L_reverse;  
        refresh_motors();
      }
      bump_right_startTick = millis();  

      while(millis() < bump_right_startTick + 400){ 
        position_R = servo_R_forward;
        position_L = servo_L_reverse;  
        refresh_motors();
      }
      bump_right_startTick = millis();
    }

    else if (bump_R_val == 1 && bump_L_val == 0){
      
      Serial.println("Left");  

      bump_left_startTick = millis();

      while(millis() < bump_left_startTick + 1000){ 
        position_R = servo_R_stop;
        position_L = servo_L_stop;  
        refresh_motors();
      }
      bump_left_startTick = millis();  

      while(millis() < bump_left_startTick + 1000){ 
        position_R = servo_R_reverse;
        position_L = servo_L_reverse;  
        refresh_motors();
      }
      bump_left_startTick = millis();  

      while(millis() < bump_left_startTick + 400){ 
        position_R = servo_R_reverse;  
        position_L = servo_L_forward;
        refresh_motors();
      }
      bump_left_startTick = millis();
    }      

    else {

      Serial.println("Both");  
      
      bump_both_startTick = millis();

      while(millis() < bump_both_startTick + 1000){ 
        position_R = servo_R_stop;
        position_L = servo_L_stop;  
        refresh_motors();
      }
      bump_both_startTick = millis();  

      while(millis() < bump_both_startTick + 2000){ 
        position_R = servo_R_reverse;
        position_L = servo_L_reverse;  
        refresh_motors();
      }
      bump_both_startTick = millis();  

      while(millis() < bump_both_startTick + 2000){ 
        position_L = servo_L_forward;
        position_R = servo_R_reverse;  
        refresh_motors();
      }
      bump_both_startTick = millis();
    }      

  }

// insert IR code here

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

      //for (int i = 0; i <= 25; i++){
        //Serial.print(i);
        //Serial.print(":   ");
        //Serial.println(ir_vals[i]);
      //} 

      Serial.println("  ");
      Serial.print("received signal:  ");
      check_pulse();
      pulsed = 0;
      x = 0;

    }
    else {        
    }
  }



// End IR code

  else {

    position_R = servo_R_forward;
    position_L = servo_L_forward;
    refresh_motors();
  }

  Serial.print("Right sensor");
  Serial.print(bump_R_val);
  Serial.print("    ");
  Serial.print("Left sensor");
  Serial.print(bump_L_val);
  Serial.println("    ");  

}


void refresh_motors(){

  digitalWrite(servo_L, HIGH);
  delayMicroseconds(position_L);
  digitalWrite(servo_L, LOW);

  digitalWrite(servo_R, HIGH);
  delayMicroseconds(position_R);
  digitalWrite(servo_R, LOW);

}

void check_pulse(){

  if (ir_vals[0] == 2){
    if (ir_vals[24] == 1){
      Serial.println("Input");
    }
    else {
      if (ir_vals[23] == 1){
        // then (0-9)
        if (ir_vals[17] == 1){            
          // then (1,3,5,7,9)   
          if (ir_vals[18] == 1){
            if (ir_vals[19] == 1){
              if (ir_vals[20] == 1){
                Serial.println("Go Back");
              }
              else{
                Serial.println("number 7");
              }
            }
            else {
              Serial.println("number 3");
            }
          }
          else {
            if (ir_vals[19] == 1){
              Serial.println("number 5");
            }
            else {
              if (ir_vals[20] == 1){
                Serial.println("number 9");
              }
              else {
                Serial.println("number 1"); 
              }
            }
          } 
        }
        else {                               
          // then (2,4,6,8,0)
          if (ir_vals[18] == 1){      
            if (ir_vals[19] == 1){
              if (ir_vals[21] == 1){
                Serial.println("Record");
              }
              else {
                Serial.println("number 6");
              }
            } 
            else {
              Serial.println("number 2"); 
            }
          }
          else{
            if (ir_vals[19] == 1){
              Serial.println("number 4");
            }
            else {
              if (ir_vals[20] == 1){
                Serial.println("number 8");
              }
              else {
                Serial.println("number 0"); 
              }
            } 
          }
        }
      }
      else {
        // then (the rest of the buttons)

        if (ir_vals[21] == 1){
          // then (ch up, ch dn, info)
          if (ir_vals[17] == 1){
            if (ir_vals[20] == 1){
              Serial.println("Info");
            }
            else {
              Serial.println("Channel Up");
            }
          }
          else{
            Serial.println("Channel Down");
          }    
        }

        else {

          if (ir_vals[17] == 1){
            if (ir_vals[18] == 1){
              if (ir_vals[19] == 1){
                if (ir_vals[20] == 1){
                  Serial.println(">>");
                } 
                else{
                  Serial.println("Down"); 
                }
              }
              else {
                Serial.println("Play");
              }   
            }
            else {
              // then (clear, stop, or ok)
              if (ir_vals[19] == 1){
                if (ir_vals[20] == 1){
                  Serial.println("Stop");
                } 
                else {
                  Serial.println("OK/Clear"); 
                }
              }
              else {
                Serial.println("Right"); 
              }
            }
          }

          else {
            // then (enter, left, <<, menu, power, pause, tv/vcr, up)
            if (ir_vals[18] == 1){
              if (ir_vals[19] == 1){
                if (ir_vals[20] == 1){
                  Serial.println("<<");
                }
                else {
                  Serial.println("Up");
                }
              }
              else {
                if (ir_vals[20] == 1){
                  Serial.println("Enter");
                }
                else {
                  Serial.println("Power");
                }
              } 
            }
            else{
              if (ir_vals[19] == 1){
                if (ir_vals[20] == 1){
                  Serial.println("Pause");
                }
                else {
                  Serial.println("Menu");
                } 
              }
              else {
                if (ir_vals[20] == 1){
                  Serial.println("Left");
                }
                else {
                  Serial.println("TV/VCR"); 
                }
              }
            }           
          }
        }
      }
    }
  }
  else {
    // then (mute, vol up, or vol down)
    if (ir_vals[21] == 2){
      // just to be sure
      if (ir_vals[20] == 2){
        Serial.println("Volume Down"); 
      }
      else {
        Serial.println("Volume Up"); 
      }
    }
    else {
      Serial.println("Mute");
    }   
  }
}


