// This code is intended to decode an Infrared helicopter remote using a standard IR receiver from Radio Shack using Interrupts
// JDW 2011

int ledPin = 13;
int pulse_pin = 21;
int pulse_val = 0;
boolean reading = false;
int ir_array[20];
int n = 0;

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
      decode_signal();
    }
    reading = false;
    //digitalWrite(ledPin, LOW);
  }
}

void decode_signal(){

  // turn

  if (ir_array[15] == 1){
    if (ir_array[16] == 1){
      if (ir_array[17] == 1){
        // left 1
        Serial.print("Left 1, ");
      }
      else {
        // left 2
        Serial.print("Left 2, ");
      }
    }
    else {
      // left 3
      Serial.print("Left 3, ");
    }  
  }
  else {
    if (ir_array[16] == 1){
      if (ir_array[17] == 1){
        // right 3
        Serial.print("Right 3, ");
      }
      else {
        // right 2
        Serial.print("Right 2, ");
      }
    }
    else {
      if (ir_array[17] == 1){
        // right 3
        Serial.print("Right 1, ");
      }
      else {
        // no turn
      }
    }  
  }

  // button

  if (ir_array[14] == 1){
    if (ir_array[13] == 1){
      // left button
      Serial.print("Button Left, ");
    }
    else {
      // right button 
      Serial.print("Button Right, ");
    }
  }


  // speed 

  if (ir_array[7] == 1){
    if (ir_array[8] == 1){
      if (ir_array[9] == 1){
        //speed 13
        Serial.println("Speed 13");
      }
      else {
        if (ir_array[10] == 1){
          //speed 12
          Serial.println("Speed 12");
        }
        else{
          //speed 11
          Serial.println("Speed 11");
        }
      }
    }
    else {
      if (ir_array[9] == 1){
        if (ir_array[10] == 1){
          //speed 10
          Serial.println("Speed 10");
        }
        else{
          //speed 9
          Serial.println("Speed 9");
        }
      }
      else {
        if (ir_array[10] == 1){
          //speed 8
          Serial.println("Speed 8");
        }
        else{
          //speed 7
          Serial.println("Speed 7");
        }
      }
    }
  }
  else {
    if (ir_array[8] == 1){
      if (ir_array[9] == 1){
        if (ir_array[10] == 1){
          //speed 6
          Serial.println("Speed 6");
        }
        else{
          //speed 5
          Serial.println("Speed 5");
        }
      }
      else {
        if (ir_array[10] == 1){
          //speed 4
          Serial.println("Speed 4");
        }
        else{
          //speed 3
          Serial.println("Speed 3");
        }
      }
    }
    else{
      if (ir_array[10] == 1){
        //speed 2
        Serial.println("Speed 2");
      }
      else{
        //speed 1
        Serial.println("Speed 1");
      }
    }
  }



}






