// Automated Chicken coop door
// JD Warren 2011


int motor_direction = 6;
int motor_speed = 5;


int LED1 = 12;
int LED2 = 13;

int incomingByte = 0;

int speed_val = 100;

int light_val;
int ir_sensor;

int dawn_dusk = 25;
int ir_threshold = 150;
int daytime = 0;
int ir1;
int ir2;
int lv1;
int lv2;


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
    

  ir1 = analogRead(5);
  delay(20);
  ir2 = analogRead(5);
  ir_sensor = (ir1 + ir2) / 2;
  
  lv1 = analogRead(4);
  delay(100);
  lv2 = analogRead(4);
  light_val = (lv1 + lv2) / 2;
  

  if (daytime == 1){

    if (light_val > dawn_dusk){
      door_up(speed_val);
      delay(100);
    }
    while (ir_sensor > ir_threshold){
      door_up(speed_val);
      ir_sensor = analogRead(5);
      daytime = 0;
    }
    door_stop();
  }

  else {

    if (light_val < dawn_dusk){
      door_down(speed_val);
      delay(100);
    } 
    while (ir_sensor > ir_threshold){
      door_down(speed_val);
      ir_sensor = analogRead(5);
      daytime = 1;
    }
    door_stop();
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










