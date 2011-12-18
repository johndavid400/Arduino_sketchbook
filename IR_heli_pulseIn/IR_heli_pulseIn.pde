// This code is intended to decode an Infrared helicopter remote using a standard IR receiver from Radio Shack using Interrupts
// JDW 2011

int ledPin = 13;
int pulse_pin = 21;
int pulse_val = 0;
boolean reading = false;
int ir_array[20];
int n = 0;
int speed_val = 0;
int turn_val = 0;
int m1_val = 0;
int m2_val = 0;

void setup() {
  Serial.begin(9600);
  //led on arduino pin 13
  pinMode(ledPin, OUTPUT);
  // IR signal from helicopter controller
  pinMode(pulse_pin, INPUT); 
}

void pulse(){
  pulse_val = pulseIn(pulse_pin, HIGH, 10000);
}

void booleanize(){
  if (pulse_val > 750){
    pulse_val = 1;
  }  
  else {
    pulse_val = 0;
  }
}

void loop() {
  pulse();
  if (pulse_val > 0){
    reading = true;
    booleanize();
    ir_array[n] = pulse_val;
    //if (n >= 5){
    //Serial.print(ir_array[n]);
    //}
    n++;
  }
  else {
    if (reading == true){
      //Serial.println("");
      n = 0;
      decode_speed();
      decode_turn();
      decode_button();
      limit_signal();
      write_motors();
    }
    reading = false;
    //digitalWrite(ledPin, LOW);
  }
}

void write_motors(){
}

void limit_signal(){
  if (m1_val > 255){
    m1_val = 255;
  }
  else if (m1_val < -255){
    m1_val = -255;
  }
  if (m2_val > 255){
    m2_val = 255;
  }
  else if (m2_val < -255){
    m2_val = -255;
  }
}

void decode_turn(){
  // turn
  turn_val = speed_val / 3;

  if (ir_array[15] == 1){
    if (ir_array[16] == 1){
      if (ir_array[17] == 1){
        // left 1
        m1_val = speed_val - turn_val;
        m2_val = speed_val + turn_val;
      }
      else {
        // left 2
        m1_val = speed_val - (turn_val * 2);
        m2_val = speed_val + (turn_val * 2);
      }
    }
    else {
      // left 3
      m1_val = speed_val - (turn_val * 3);
      m2_val = speed_val + (turn_val * 3);
    }
  }
  else {
    if (ir_array[16] == 1){
      if (ir_array[17] == 1){
        // right 3
        m1_val = speed_val + (turn_val * 3);
        m2_val = speed_val - (turn_val * 3);
      }
      else {
        // right 2
        m1_val = speed_val + (turn_val * 2);
        m2_val = speed_val - (turn_val * 2);
      }
    }
    else {
      if (ir_array[17] == 1){
        // right 3
        m1_val = speed_val + turn_val;
        m2_val = speed_val - turn_val;
      }
      else {
        // no turn
        m1_val = speed_val;
        m2_val = speed_val;
      }
    }
  }
}

void decode_button(){
  // button

  if (ir_array[14] == 1){
    if (ir_array[13] == 1){
      // left button
      m1_val = -m1_val;
      m2_val = -m2_val;
    }
    else {
      // right button 
      m1_val = m1_val * 2;
      m2_val = m2_val * 2;
    }
  }


}

void decode_speed(){
  // speed 

  if (ir_array[7] == 1){
    if (ir_array[8] == 1){
      if (ir_array[9] == 1){
        //speed 13
        speed_val = 255;
      }
      else {
        if (ir_array[10] == 1){
          //speed 12
          speed_val = 240;
        }
        else{
          //speed 11
          speed_val = 220;
        }
      }
    }
    else {
      if (ir_array[9] == 1){
        if (ir_array[10] == 1){
          //speed 10
          speed_val = 200;
        }
        else{
          //speed 9
          speed_val = 180;
        }
      }
      else {
        if (ir_array[10] == 1){
          //speed 8
          speed_val = 160;
        }
        else{
          //speed 7
          speed_val = 140;
        }
      }
    }
  }
  else {
    if (ir_array[8] == 1){
      if (ir_array[9] == 1){
        if (ir_array[10] == 1){
          //speed 6
          speed_val = 120;
        }
        else{
          //speed 5
          speed_val = 100;
        }
      }
      else {
        if (ir_array[10] == 1){
          //speed 4
          speed_val = 80;
        }
        else{
          //speed 3
          speed_val = 60;
        }
      }
    }
    else{
      if (ir_array[10] == 1){
        //speed 2
        speed_val = 40;
      }
      else{
        //speed 1
        speed_val = 20;
      }
    }
  }
}




