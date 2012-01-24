// R/C airplane using ardupilot
// airplane uses dc motor and a single mosfet to apply pwm to the negative motor terminal
// jdw 2012

int throttle_in = 2;
int throttle_out = 9;
int pulseVal = 0;
int speed_val = 0;
int mode_pin = 5;
int tmiso_pin = 4;

void setup(){
  Serial.begin(9600);
  pinMode(throttle_in, INPUT);
  pinMode(throttle_out, OUTPUT);
  pinMode(mode_pin, OUTPUT);
  pinMode(tmiso_pin, OUTPUT);

  digitalWrite(mode_pin, HIGH);
  digitalWrite(tmiso_pin, HIGH); 
}

void loop(){
  pulseVal = pulseIn(throttle_in, HIGH, 20000);

  if(pulseVal > 600 && pulseVal < 2400){
    speed_val = map(pulseVal, 1200, 1750, 255, 0);
    if (speed_val > 250){
      speed_val = 255;
    }     
    else if (speed_val < 0){
      speed_val = 0; 
    }
    analogWrite(throttle_out, speed_val);
    //Serial.print(pulseVal);
    //Serial.print("   ");
    //Serial.println(speed_val);
  }
  else {
    digitalWrite(throttle_out, LOW);
  }
}


