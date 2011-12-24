// Bug-bot v1.2
// (2) Servo motors (modified for continuous rotation) with tank-steering setup (pins 9 and 10).
// (5) bump sensors total - 2 in front (pins 2 and 3) and 3 in rear (pins 14, 15, & 16).
// All sensors are normally HIGH (1) using arduino internal pull-up resistors.
// Sensors are brought LOW (0) by contacting the switch connected to GND.
// Either set of sensors can be used (front or back), by changing Mode Switch on pin 4.
// Pin 4 (HIGH or LOW) changes the bots default direction and sensors.
//

// include the Servo.h Arduino library
#include <Servo.h>

// create instances for each servo using the Servo.h library
// for more information, see: http://arduino.cc/en/Reference/Servo 
Servo servo_L;
Servo servo_R;

//////////////////////////  Variables used for testing (you can change these) /////////////////

// use to determine direction of bot and which sensors to use.
int mode_pin = 4; // connect the mode switch to digital pin 4

int antennae_L = 3; // connect left antennae sensor to digital pin 3
int antennae_R = 2; // connect right antennae sensor to digital pin 2

// Value to change servo stopping point pulse - use Code 7-2 to determine the specific pulse for each motor 
int servo_R_stop = 89;  // set the Neutral position for Right Servo - change as needed
int servo_L_stop = 89;  // set the Neutral position for Left Servo  - change as needed

// integers to use for updating Servo motors
// change these values to change the various motor actions
int stop_time = 1000;  // stop for 1000 millliseconds = 1 second
int backup_time = 700; // backup for 700 milliseconds = .7 seconds
int turn_time = 300;   // turn (either direction) for 300 milliseconds = .3 seconds

//////////////////////////  End of variables used for testing ////////////////////////////////

// value names used to hold timing variables.
unsigned long timer_startTick;

// value names used to hold antennae states
int antennae_R_val;
int antennae_L_val;

// value names used to hold bumper states
int distance_val = 0;
int distance_threshold = 10;

// Set the forward and reverse speed values for the Right Servo based on the Neutral position
int servo_R_forward = servo_R_stop + 50; 
int servo_R_reverse = servo_R_stop - 50; 

// Set the forward and reverse speed values for the Left Servo based on the Neutral position
int servo_L_forward = servo_L_stop - 50;
int servo_L_reverse = servo_L_stop + 50;

// end of variables


// Begin Setup
void setup(){

  Serial.begin(9600); // start Serial connection at 9600 bps

  servo_L.attach(9);  // attach servo_L to pin 9 using the Servo.h library
  servo_R.attach(10); // attach servo_R to pin 10 using the Servo.h library

  pinMode(mode_pin, INPUT);  // declare input 
  digitalWrite(mode_pin, HIGH); // enable pull-up resistor

  pinMode(antennae_R, INPUT);  // declare input  
  digitalWrite(antennae_R, HIGH); // enable pull-up resistor
  pinMode(antennae_L, INPUT);  // declare input  
  digitalWrite(antennae_L, HIGH); // enable pull-up resistor

}
// End Setup


// Begin Loop
void loop(){

  ////////////////////////////////////////////////////////
  // if the switch_pin is LOW, use the Antennae sensors
  ////////////////////////////////////////////////////////
  if (digitalRead(mode_pin) == 0){

    antennae_R_val = digitalRead(antennae_R); // read Right antennae
    antennae_L_val = digitalRead(antennae_L); // read Left antennae

    // Use Antennae sensors
    // check to see if either antennae sensor is equal to GND (it is being touched).
    if (antennae_R_val == 0 || antennae_L_val == 0){

      // now check to see if only the Left antennae was touched  
      if (antennae_R_val == 0 && antennae_L_val == 1){
        // if so, print the word "Left"
        Serial.println("Left");  
        // reset timer
        timer_startTick = millis();
        // Stop motors
        stop_motors();
        // back up a bit
        backup_motors();
        // turn Right for a bit
        turn_right();
      }

      // otherwise, if the Right sensor was touched and the Left was not,
      else if (antennae_R_val == 1 && antennae_L_val == 0){
        // print the word "Right"
        Serial.println("Right");  
        // reset timer
        timer_startTick = millis();
        // Stop motors
        stop_motors();
        // back up a bit
        backup_motors();
        // turn Left for a bit
        turn_left();
      }      

      else {
        // otherwise, both antennae sensors were touched 
        // print the word "Both"
        Serial.println("Both");  
        // reset timer
        timer_startTick = millis();
        // Stop motors
        stop_motors();
        // back up a bit
        backup_motors();
        // turn either direction
        turn_left();
      }      
    }

    else {
      // otherwise no sensors were touched, so go Forward!
      forward_motors();
    }

    // print the states of each antennae
    Serial.print("Right sensor");
    Serial.print(antennae_R_val);
    Serial.print("    ");
    Serial.print("Left sensor");
    Serial.print(antennae_L_val);
    Serial.println("    ");  
    // End Antennae sensors

  }
  ///////////////////////////////////////////////////////////
  // Else, if the switch_pin is HIGH, use the Ultrasonic sensor
  ///////////////////////////////////////////////////////////
  else{

    // read the ultrasonic sensor
    distance_val = analogRead(0) / 2.54;

    // check to see if the value is below 12 inches
    if (distance_val < distance_threshold){
      // if so, print the word "Right"
      Serial.println("Object Sensed!");  
      // reset timer
      timer_startTick = millis();
      // Stop motors
      stop_motors();
      // turn Left
      turn_left();

    }

    else{
      // otherwise no sensors were touched, so go Forward (which is actually Reverse when the direction is switched)!
      reverse_motors(); 
    }

    // print the states of each bumper
    Serial.print("Range: ");
    Serial.print(distance_val);
    Serial.println("    ");  
  }
  // End Ultrasonic sensor
}
///////////////////// End Loop /////////////////////




// Beginning motor control functions

void stop_motors(){
  // stop motors for the amount of time defined in the "stop_time" variable
  while(millis() < timer_startTick + stop_time){ 
    servo_L.write(servo_L_stop); 
    servo_R.write(servo_R_stop);    
  }  
  timer_startTick = millis();  // reset timer variable
}


void backup_motors(){
  // backup for the amount of time defined in the "backup_time" variable
  while(millis() < timer_startTick + backup_time){ 
    servo_L.write(servo_L_reverse); 
    servo_R.write(servo_R_reverse);    
  }
  timer_startTick = millis();  // reset timer variable
}

void ahead_motors(){
  // go forward for the amount of time defined in the "backup_time" variable
  while(millis() < timer_startTick + backup_time){ 
    servo_L.write(servo_L_forward); 
    servo_R.write(servo_R_forward); 
  }
  timer_startTick = millis();  // reset timer variable
}

void turn_right(){
  // turn right for the amount of time defined in the "turn_time" variable
  while(millis() < timer_startTick + turn_time){ 
    servo_L.write(servo_L_forward); 
    servo_R.write(servo_R_reverse); 
  }
}

void turn_left(){
  // turn left for the amount of time defined in the "turn_time" variable
  while(millis() < timer_startTick + turn_time){ 
    servo_L.write(servo_L_reverse); 
    servo_R.write(servo_R_forward); 
  }
}

void reverse_motors(){
  // go reverse indefinitely
  servo_L.write(servo_L_reverse); 
  servo_R.write(servo_R_reverse);    
}

void forward_motors(){
  // go forward indefinitely
  servo_L.write(servo_L_forward); 
  servo_R.write(servo_R_forward); 
}
// End motor control functions

// End Code




