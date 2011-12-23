// Xbee-bot
//
//
// JD Warren 2011

int m2_A = 3;  // 9 on Arduino Mega
int m2_B = 11;  // 10 on Arduino Mega

int m1_A = 9;  // 11 on Arduino Mega
int m1_B = 10; // 12 on Ardiuno Mega

int RC_1 = 14; 
int RC_2 = 15;

int servo1_val; 
int adj_val1;  

int servo2_val; 
int adj_val2;  

int mode_pin = 5;

// LED pin attached to Arduino D13
int LED = 13;

// variable to store speed value
int slack = 0;
int max_speed = 200 - slack;
int deadband = 30;
int low = -100;
int high = 100;

int X_accel_raw;
int Y_accel_raw;
int x;
int y;
int left;
int right;

String readString;
char command_end = 'Z';
char command_begin = '$';
char current_char;

///////////////////////////////////////////

void setup(){

  Serial.begin(19200);

  //TCCR1B = TCCR1B & 0b11111000 | 0x01; // set PWM frequency for pins 9 and 10 to 32kHz (pins 11 and 12 on Arduino Mega).
  //TCCR2B = TCCR2B & 0b11111000 | 0x01; // set PWM frequency for pins 3 and 11 to 32kHz (pins 9 and 10 on Arduino Mega).

  pinMode(RC_1, INPUT);
  pinMode(RC_2, INPUT); 

  pinMode(m1_A, OUTPUT);
  pinMode(m1_B, OUTPUT);
  pinMode(m2_A, OUTPUT);
  pinMode(m2_B, OUTPUT);

  pinMode(mode_pin, INPUT);
  digitalWrite(mode_pin, HIGH);
  delay(100);

}


void loop(){


  if (digitalRead(mode_pin) == LOW){


    // use serial interface
    while (Serial.available()) {
      current_char = Serial.read();  //gets one byte from serial buffer

      if(current_char == command_begin){ // when we get a begin character, start reading
        readString = "";
        while(current_char != command_end){ // stop reading when we get the end character
          current_char = Serial.read();  //gets one byte from serial buffer
          if(current_char != command_end){
            //Serial.println(current_char);
            readString += current_char;
            delay(10);
          }
        }

        Serial.println(readString);
        if(current_char == command_end){ 
          //Serial.println("foo");
          handle_command(readString);
          readString = "";
        }
      } 
    }


    x = map(X_accel_raw, low, high, -max_speed, max_speed); 
    y = map(Y_accel_raw ,low, high, -max_speed, max_speed); 

    //////////////////

    //    servo1_val = pulseIn(RC_1, HIGH, 20000);
    //    servo2_val = pulseIn(RC_2, HIGH, 20000);
    //
    //    x = map(servo1_val, 1100, 1900, max_speed, -max_speed);
    //    y = map(servo2_val, 1100, 1875, -max_speed, max_speed);


    /////////////////

    // Now we can check the accelerometer values to see what direction the robot should go:

    if (y > deadband) {  // if the Y-axis input is above the upper threshold, go FORWARD 

      // Going Forward, now check to see if we should go straight ahead,turn left, or turn right.
      if (x > deadband) { // go forward while turning right proportional to the R/C left/right input
        left = y;
        right = y - x;
        // quadrant 1 - forward and to the right
      }
      else if (x < -deadband) {   // go forward while turning left proportional to the left/right input
        left = y + x;  // remember that in this case, x will be a negative number, so multiply by -1
        right = y;
        // quadrant 2 - forward and to the left
      }
      else {   // left/right stick is centered, go straight forward
        left = y;
        right = y;
        // go forward along Y axis
      }
    }

    else if (y < -deadband) {    // otherwise, if the Up/Down R/C input is below lower threshold, go BACKWARD

      // remember that x is below deadband_low, it will always be a negative number, we need to multiply it by -1 to make it positive.
      // now check to see if left/right input from R/C is to the left, to the right, or centered.
      if (x > deadband) { // // go backward while turning right proportional to the R/C left/right input
        left = y;
        right = y + x;
        // quadrant 4 - go backwards and to the right
      }
      else if (x < -deadband) {   // go backward while turning left proportional to the R/C left/right input
        left = y - x;
        right = y;
        // quadrant 3 - go backwards and to the left
      }     
      else {   // left/right stick is centered, go straight backwards
        left = y; 
        right = y; 
        // go straight backwards along x axis
      }
    }

    else {     // if neither of the above 2 conditions is met, then X (Up/Down) R/C input is centered (neutral)
      if (x > deadband) { 
        left = x * 2;
        right = -x * 2;
      }
      else if (x < -deadband) {   
        left = x * 2;
        right = -x * 2; 
      }      
      else{
        // Stop motors!
        left = 0;
        right = 0;
        m1_stop();
        m2_stop();
      }
    }

    test(max_speed);
    update_motors();


    Serial.print("r: ");
    Serial.print(right);
    Serial.print("     ");
    Serial.print("l: ");
    Serial.print(left);
    Serial.println("     ");
    //delay(300);

  }

  else {
    // use r/c interface

      servo2_val = pulseIn(RC_2, HIGH, 20000);
    servo1_val = pulseIn(RC_1, HIGH, 20000);

    //    Serial.print(servo1_val);
    //    Serial.print("   ");
    //    Serial.println(servo2_val);

    if (servo1_val > 0 && servo2_val > 0) {

      left = map(servo1_val, 1100, 1875, -255, 255);
      right = map(servo2_val, 1100, 1900, 255, -255);

      test(255);  
      update_motors();

    }

    //    Serial.print(adj_val1);
    //    Serial.print("   ");
    //    Serial.println(adj_val2);

  }
}


void handle_command(String readString){

  if(readString.substring(0,1) == "X"){
    char temp[20];
    readString.substring(1).toCharArray(temp, 19);
    int x_val = atoi(temp);
    X_accel_raw = x_val;    
  }
  else if(readString.substring(0,1) == "Y"){
    char temp[20];
    readString.substring(1).toCharArray(temp, 19);
    int y_val = atoi(temp);
    Y_accel_raw = y_val;
  } 
  else {
    //X_accel_raw = 0;
    //Y_accel_raw = 0;
  }

  /*
  Serial.print("X_accel_raw: ");
   Serial.print(X_accel_raw);
   Serial.print("     ");
   Serial.print("Y_accel_raw: ");
   Serial.print(Y_accel_raw);
   Serial.print("     ");
   */
}

void update_motors(){

  if (left > deadband){
    m1_forward(left);
  }
  else if (left < -deadband){
    m1_reverse(-left);
  }
  else{
    m1_stop();  
  }

  if (right > deadband){
    m2_forward(right);
  }
  else if (right < -deadband){
    m2_reverse(-right);
  }
  else{
    m2_stop();  
  }
}

void test(int speedVal){

  if (left > speedVal){
    left = speedVal;
  }
  if (left < -speedVal){
    left = -speedVal;
  }

  if (right > speedVal){
    right = speedVal;
  }
  if (right < -speedVal){
    right = -speedVal;
  } 
}




void m1_reverse(int x){
  digitalWrite(m1_B, LOW);
  analogWrite(m1_A, x + slack);  
}

void m1_forward(int x){
  digitalWrite(m1_A, LOW);
  analogWrite(m1_B, x + slack);  
}

void m1_stop(){
  digitalWrite(m1_A, LOW);
  digitalWrite(m1_B, LOW);  
}

void m2_forward(int y){
  digitalWrite(m2_A, LOW);
  analogWrite(m2_B, y + slack);
}

void m2_reverse(int y){
  digitalWrite(m2_B, LOW);
  analogWrite(m2_A, y + slack);  
}

void m2_stop(){
  digitalWrite(m2_A, LOW);
  digitalWrite(m2_B, LOW);  
}

