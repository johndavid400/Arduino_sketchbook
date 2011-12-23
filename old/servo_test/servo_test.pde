

int bump_L = 3;
int bump_R = 2;

int bump_R_val;
int bump_L_val;

int servo_L = 4;
int servo_R = 5;

int servo_R_stop = 1715;
int servo_L_stop = 1657;

int servo_R_forward = 2400;
int servo_L_forward = 600;

int servo_R_reverse = 600;
int servo_L_reverse = 2400;

int position_L;
int position_R;

unsigned long last_refresh = 0;

unsigned long bump_right_startTick;
unsigned long bump_left_startTick;
unsigned long bump_both_startTick;

void setup(){

  Serial.begin(9600);

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

      while(millis() < bump_right_startTick + 1000){ 
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

      while(millis() < bump_left_startTick + 1000){ 
        position_R = 1000;  
        position_L = 1000;
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

      while(millis() < bump_both_startTick + 3000){ 
        position_L = servo_L_forward;
        position_R = servo_R_reverse;  
        refresh_motors();
      }
      bump_both_startTick = millis();
    }      

  }

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



