// Decode 2 r/c signals using interrupts and 1 failsafe channel using pulseIn.
// The 2 motor channels have full 0-100% high-resolution pwm speed control
// The failsafe channel is polled, and outputs a digital HIGH/LOW. Suitable as a failsafe or auxillary channel.
// 
//  JD Warren 1-8-2010
//  www.rediculouslygoodlooking.com
// failsafe channel is currently used to toggle speed mode fast/slow.
// THIS CODE USES CHANNEL MIXING -- you need to use channel 1 up/down, and channel 2 left/right.




int x;
int y;
int a;
int b;

int speed_low = 0;
int speed_high = 511;

int switch_val;
int speed_val;

void setup() {

  Serial.begin(9600);

  pinMode(motor1_a, OUTPUT);
  pinMode(motor1_b, OUTPUT);
  pinMode(motor2_a, OUTPUT);
  pinMode(motor2_b, OUTPUT);

  pinMode(relay, OUTPUT);

  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);
  pinMode(ledPin3, OUTPUT);

  pinMode(switch_pin, INPUT); 
  pinMode(speed_pin, INPUT); 

  pinMode(servo1, INPUT); 
  pinMode(servo2, INPUT); 

}



void loop() {

  //////// --------------------------------- /////////

  if (servo1_Ready) {
    servo1_Ready = false;  
    adj_val1 = map(constrain(servo1_val, timerVal_low, timerVal_high), low1, high1, speed_low, speed_high); 
    constrain(adj_val1, speed_low, speed_high);
    x = adj_val1;
  }

  if (servo2_Ready) {
    servo2_Ready = false;
    adj_val2 = map(constrain(servo2_val, timerVal_low, timerVal_high), low2, high2, speed_low, speed_high); 
    constrain(adj_val2, speed_low, speed_high);
    y = adj_val2;
  }

  //////// --------------------------------- /////////

  if (digitalRead(switch_pin) == HIGH) {

    if (y > deadband_high) {  // go forward
      if (x > deadband_high) { // turn right
        a = y - pwm_ceiling;
        b = (y - pwm_ceiling) - (x - pwm_ceiling);
        
        digitalWrite(motor1_b, LOW);
	digitalWrite(motor1_a, HIGH);
        analogWrite(motor1_pwm, a);
        digitalWrite(ledPin1, LOW);

        digitalWrite(motor2_b, LOW);
	digitalWrite(motor2_a, HIGH);
        analogWrite(motor2_pwm, b);
        digitalWrite(ledPin2, LOW);
      }
      else if (x < deadband_low) {   // turn left
        a = (y - pwm_ceiling) - (pwm_floor - x);
        b = y - pwm_ceiling;
        
        digitalWrite(motor1_b, LOW);
	digitalWrite(motor1_a, HIGH);        
	analogWrite(motor1_pwm, a);
        digitalWrite(ledPin1, LOW);

        digitalWrite(motor2_b, LOW);
	digitalWrite(motor2_a, HIGH);
        analogWrite(motor2_pwm, b);
        digitalWrite(ledPin2, LOW);
      }
      else {
        a = y - pwm_ceiling;
        b = y - pwm_ceiling;
        test();
        digitalWrite(motor1_b, LOW);
	digitalWrite(motor1_a, HIGH);
        analogWrite(motor1_pwm, a);
        digitalWrite(ledPin1, LOW);

        digitalWrite(motor2_b, LOW);
	digitalWrite(motor2_a, HIGH);
        analogWrite(motor2_pwm, b);
        digitalWrite(ledPin2, LOW);
      }
    }

    else if (y < deadband_low) {    // go backwards
      if (x > deadband_high) { // turn right
        a = pwm_floor - y;
        b = (pwm_floor - y) - (x - pwm_ceiling);
        test();
        digitalWrite(motor1_a, LOW);
	digitalWrite(motor1_b, HIGH);
        analogWrite(motor1_pwm, a);
        digitalWrite(ledPin1, LOW);

        digitalWrite(motor2_a, LOW);
	digitalWrite(motor2_b, HIGH);
        analogWrite(motor2_pwm, b);
        digitalWrite(ledPin2, LOW); 
      }
      else if (x < deadband_low) {   // turn left
        a = (pwm_floor - y) - (pwm_floor - x);
        b = pwm_floor - y;
        test();
        digitalWrite(motor1_a, LOW);
	digitalWrite(motor1_b, HIGH);
        analogWrite(motor1_pwm, a);
        digitalWrite(ledPin1, LOW);

        digitalWrite(motor2_a, LOW);
	digitalWrite(motor2_b, HIGH);
        analogWrite(motor2_pwm, b);
        digitalWrite(ledPin2, LOW);    
      }			
      else {
        a = pwm_floor - y;
        b = pwm_floor - y;
        test();
        digitalWrite(motor1_a, LOW);
	digitalWrite(motor1_b, HIGH);
        analogWrite(motor1_pwm, a);
        digitalWrite(ledPin1, LOW);

        digitalWrite(motor2_a, LOW);
	digitalWrite(motor2_b, HIGH);
        analogWrite(motor2_pwm, b);
        digitalWrite(ledPin2, LOW); 
      }
    }

    else {     // neutral, with a chance of donuts.
      if (x > deadband_high) {
        a = (x - pwm_ceiling) / 2;
        digitalWrite(motor2_b, LOW);
	digitalWrite(motor2_a, HIGH);
        analogWrite(motor2_pwm, a);
        digitalWrite(ledPin2, LOW);

        digitalWrite(motor1_a, LOW);
	digitalWrite(motor2_b, HIGH);
        analogWrite(motor1_pwm, a);
        digitalWrite(ledPin1, LOW);
      }  
      else if (x < deadband_low) {
        a = (pwm_floor - x) / 2;
        digitalWrite(motor2_a, LOW);
	digitalWrite(motor2_b, HIGH);
        analogWrite(motor2_pwm, a);
        digitalWrite(ledPin2, LOW); 

        digitalWrite(motor1_b, LOW);
	digitalWrite(motor1_a, HIGH);
        analogWrite(motor1_pwm, a);
        digitalWrite(ledPin1, LOW);
      }  
      else {
        digitalWrite(motor1_b, LOW);
        digitalWrite(motor1_a, LOW);
	digitalWrite(motor1_pwm, LOW);

        digitalWrite(motor2_b, LOW);
        digitalWrite(motor2_a, LOW);
	digitalWrite(motor2_pwm, LOW);

        digitalWrite(ledPin1, HIGH);
        digitalWrite(ledPin2, HIGH); 
      }    
    }

  }

  //////// --------------------------------- /////////

  else {    // if pin 7 is LOW, use tank-steering 

    if (x > deadband_high) {  //Forward
      a = x - pwm_ceiling;
      test();
      digitalWrite(motor1_b, LOW);
      analogWrite(motor1_a, a);
      digitalWrite(ledPin1, LOW);
    }
    else if (x < deadband_low) {  //REVERSE
      a = pwm_floor - x;
      test();
      digitalWrite(motor1_a, LOW);
      analogWrite(motor1_b, a);
      digitalWrite(ledPin1, LOW);
    }
    else {    //STOP
      digitalWrite(motor1_b, LOW);
      digitalWrite(motor1_a, LOW);
      digitalWrite(ledPin1, HIGH);
    }


    if (y > deadband_high) {  //Forward
      b = y - pwm_ceiling;
      test();
      digitalWrite(motor2_b, LOW);
      analogWrite(motor2_a, b);
      digitalWrite(ledPin2, LOW);
    }
    else if (y < deadband_low) {  //REVERSE
      b = pwm_floor - y;
      test();
      digitalWrite(motor2_a, LOW);
      analogWrite(motor2_b, b);
      digitalWrite(ledPin2, LOW); 
    }
    else {    //STOP
      digitalWrite(motor2_b, LOW);
      digitalWrite(motor2_a, LOW);  
      digitalWrite(ledPin2, HIGH); 
    }

  }




  Serial.print("ch1:  "); 
  Serial.print(a);
  Serial.print("  ");
  Serial.print("rc1:  ");
  Serial.print(servo1_val);
  Serial.print("  ");
  Serial.print("ch2:  ");
  Serial.print(b);
  Serial.print("  ");
  Serial.print("rc2:  ");
  Serial.print(servo2_val);
  Serial.print("  ");

  Serial.print("1:  "); 
  Serial.print(adj_val1);
  Serial.print("  ");    
  Serial.print("2:  "); 
  Serial.print(adj_val2);
  Serial.println("  ");    



}
