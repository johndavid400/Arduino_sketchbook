

int motor_direction = 6;
int motor_speed = 5;


int LED1 = 12;
int LED2 = 13;

int incomingByte = 0;

int speed_val = 255;

void setup(){

  //TCCR2B = TCCR2B & 0b11111000 | 0x01; // set PWM frequency for pins 3 and 11 to 32kHz (pins 9 and 10 on Arduino Mega).

  Serial.begin(19200);

  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);

  pinMode(motor_direction, OUTPUT);
  pinMode(motor_speed, OUTPUT);

  door_stop();

  delay(500);

}

////////////////////////////////////

void loop(){

  if (Serial.available() > 0) {
    // read the incoming byte:
    incomingByte = Serial.read();

    Serial.print("I received: ");
    Serial.println(incomingByte);
    delay(10);


    if (incomingByte == 46){
      speed_val = speed_val + 5;
      test_speed();
      Serial.println(speed_val);  
    }
    else if (incomingByte == 44){
      speed_val = speed_val - 5;
      test_speed();
      Serial.println(speed_val);  
    }
    else if (incomingByte == 47){
      speed_val = 255;
      test_speed();
    }
    
    else if (incomingByte == 111){
      door_up(speed_val);
      delay(1000);
    }
    else if (incomingByte == 108){
      door_down(speed_val);
      delay(1000);
    }
    else {
      door_stop();
    }





  }

  else {
    door_stop();

  }
}

void test_speed(){

  if (speed_val > 250){
    speed_val = 255;
    Serial.println(" MAX ");  
  }
  if (speed_val < 0){
    speed_val = 0;
    Serial.println(" MIN ");  
  }    

}

/////////// motor functions ////////////////

void door_up(int x){
  digitalWrite(LED1, HIGH);
  digitalWrite(motor_direction, LOW);
  analogWrite(motor_speed, x); 
}

void door_down(int x){
  digitalWrite(LED2, HIGH);
  digitalWrite(motor_direction, HIGH);
  delay(200);
  analogWrite(motor_speed, x); 
}

void door_stop(){
  digitalWrite(motor_direction, LOW);
  digitalWrite(motor_speed, LOW);
  digitalWrite(LED1, LOW);
  digitalWrite(LED2, LOW);
}









