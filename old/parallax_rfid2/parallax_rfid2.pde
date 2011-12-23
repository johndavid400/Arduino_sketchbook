// RFID reader for Arduino 
// Wiring version by BARRAGAN <http://people.interaction-ivrea.it/h.barragan> 
// Modified for Arudino by djmatic


int  val = 0; 
char code[10]; 
int bytesread = 0; 
char rfid_val;
char approved_tag1[] = {
  '0', 'F', '0', '3', '0', '3', '8', '2', '2', 'F'};  // place your RFID tag code in the bracket. This example is: "0F0303822F"
char approved_tag2[] = {
  '0', '4', '1', '5', 'D', 'B', '1', 'F', '3', '0'};  // place your RFID tag code in the bracket. This example is: "0F0303822F"

int relay = 4;
int red_led = 5;
int green_led = 6;

int verify_tag1 = false;
int verify_tag2 = false;

void setup() { 

  Serial.begin(2400); // RFID reader SOUT pin connected to Serial RX pin at 2400bps 
  pinMode(2,OUTPUT);   // Set digital pin 2 as OUTPUT to connect it to the RFID /ENABLE pin 
  pinMode(relay, OUTPUT);
  pinMode(red_led, OUTPUT);
  pinMode(green_led, OUTPUT);
  digitalWrite(2, LOW);                  // Activate the RFID reader
}  


void loop() { 

  if(Serial.available() > 0) {          // if data available from reader 
    if((val = Serial.read()) == 10) {   // check for header 
      bytesread = 0; 
      while(bytesread<10) {              // read 10 digit code 
        if( Serial.available() > 0) { 
          val = Serial.read(); 
          if((val == 10)||(val == 13)) { // if header or stop bytes before the 10 digit reading 
            break;                       // stop reading 
          } 
          code[bytesread] = val;         // add the digit           
          bytesread++;                   // ready to read next digit  
        } 
      } 
      if(bytesread == 10) {    

        // if 10 digit read is complete 
        Serial.print("TAG code is: ");   // possibly a good TAG    
        Serial.println(code);           // print the TAG code 


          ////////////////  Tag1


        if (verify_tag1 == true){
          if (code[1] == approved_tag1[1]){
            if (code[2] == approved_tag1[2]){
              if (code[3] == approved_tag1[3]){
                if (code[4] == approved_tag1[4]){
                  if (code[5] == approved_tag1[5]){
                    if (code[6] == approved_tag1[6]){
                      if (code[7] == approved_tag1[7]){
                        if (code[8] == approved_tag1[8]){
                          if (code[9] == approved_tag1[9]){
                            verify_tag1 = false;
                            digitalWrite(relay, HIGH);
                            digitalWrite(green_led, HIGH);
                            digitalWrite(red_led, LOW);
                            delay(1000); 
                            Serial.println("Welcome home Mr. Warren");
                            Serial.println("           ");
                            delay(200);
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }


          else{
            if (code[1] == approved_tag1[1]){
              if (code[2] == approved_tag1[2]){
                if (code[3] == approved_tag1[3]){
                  if (code[4] == approved_tag1[4]){
                    if (code[5] == approved_tag1[5]){
                      if (code[6] == approved_tag1[6]){
                        if (code[7] == approved_tag1[7]){
                          if (code[8] == approved_tag1[8]){
                            if (code[9] == approved_tag1[9]){
                              verify_tag1 = true;
                              blink(1);
                              delay(200);       
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }      
          }    
        }


        ///////////////////////////////////     



        if (verify_tag2 == true){
          if (code[1] == approved_tag2[1]){
            if (code[2] == approved_tag2[2]){
              if (code[3] == approved_tag2[3]){
                if (code[4] == approved_tag2[4]){
                  if (code[5] == approved_tag2[5]){
                    if (code[6] == approved_tag2[6]){
                      if (code[7] == approved_tag2[7]){
                        if (code[8] == approved_tag2[8]){
                          if (code[9] == approved_tag2[9]){
                            verify_tag2 = false;
                            digitalWrite(relay, HIGH);
                            digitalWrite(green_led, HIGH);
                            digitalWrite(red_led, LOW);
                            delay(1000); 
                            Serial.println("Welcome home Mr. Warren");
                            Serial.println("           ");
                            delay(200);
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }       
        } 


        else{

          if (code[1] == approved_tag2[1]){
            if (code[2] == approved_tag2[2]){
              if (code[3] == approved_tag2[3]){
                if (code[4] == approved_tag2[4]){
                  if (code[5] == approved_tag2[5]){
                    if (code[6] == approved_tag2[6]){
                      if (code[7] == approved_tag2[7]){
                        if (code[8] == approved_tag2[8]){
                          if (code[9] == approved_tag2[9]){
                            verify_tag2 = true;
                            blink(1);
                            delay(200);   
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }       
        }         

      }



      bytesread = 0; 
      delay(500);                       // wait for a second 
    } 
  }  

  else {

    digitalWrite(relay, LOW);
    digitalWrite(green_led, LOW);
    digitalWrite(red_led, HIGH);
  }

} 

void blink(int x) {
  while (x > 0) {
    digitalWrite(red_led, HIGH);
    delay(500);
    digitalWrite(red_led, LOW);
    delay(500);
    x--;
  }
}


// extra stuff
// digitalWrite(2, HIGH);             // deactivate RFID reader 





