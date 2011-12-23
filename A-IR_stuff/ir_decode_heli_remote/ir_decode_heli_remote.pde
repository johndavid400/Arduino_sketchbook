// Read pulse signal from an IR sensor using interrupts for quick readings
// Using an Innovage universal (jumbo) infrared remote control
// Set DVD code to 202 - press "code search", press "dvd", press "202"

int pulse = 0;
int x = 0;
int ir_vals[25];
int pulsed;

void setup(){
  Serial.begin(19200); 
  pinMode(2, INPUT);
}

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



































