// DIY Segway
// JD Warren
// 



// Analog input pins
int gyro_pin = 1;
int accel_pin = 5;

int ledPin = 13;

int potPin = 3;


// value to hold the final angle 
float angle = 0.00;

// the following 2 values should add together to equal 1.
float gyro_weight = 0.98;
float accel_weight = 0.02;
//


// accelerometer values
int accel_offset = 511;
int accel_avg;
int x_acc_raw;

float x_acc;
float x_acc_scale = 0.011;
float x_acc_degree = 0.00; 

int accel_1;
int accel_2;
int accel_3;
int accel_4;
int accel_5;
int accel_6;
int accel_7;
int accel_8;
int accel_9;
int accel_10;

// gyroscope values
int gyro_offset = 391;
int gyro_avg;
int gyro_raw; 

float gyro_rate;
//float gyro_scale = 0.015;  // 0.927927928
float gyro_angle = 0.00;

int gval_1;
int gval_2;
int gval_3;
int gval_4;
int gval_5;
int gval_6;
int gval_7;
int gval_8;
int gval_9;
int gval_10;

// other variables

int last_update;

long last_cycle = 0;
int cycle_time;

int m1_speed = 0;
int m2_speed = 0;

float output;

float Kp = 1;
int motor_out = 0;
int motor_1_out = 0;
int motor_2_out = 0;

float steer_pot;
int steer_tweak = 5;
int steer_reading;


////////////////////////////////  the setup

void setup(){

  Serial.begin(9600);

  pinMode(accel_pin, INPUT);
  pinMode(gyro_pin, INPUT);

  pinMode(13, OUTPUT);

  analogReference(EXTERNAL);

}


///////////////////////////////  the main loop


void loop(){

  sample_accel();

  sample_gyro();


  angle = (float)(gyro_weight) * (angle + (gyro_rate * -0.05)) + (accel_weight) * (x_acc);
  

  get_steering(); // Gets value from steering pot, maps it from -1 to 1  
  update_motor_speed();
 

/*
  Serial.print("Time: ");  
  Serial.print(cycle_time);  
  Serial.println("  "); 
*/

  // calculate each loop cycle time, and add a delay to make equal to 100 milliseconds - ie. create a 10Hz loop cycle time.

  /*

   Serial.print("cycle_timer:  ");  
   Serial.print(cycle_time);  
   Serial.println("  ");
   
   */

  digitalWrite(13, HIGH);  // use pin 13 as a loop new cycle signal... check with an oscilloscope to see loop frequency

  // create a timer based delay to set the loop frequency to 20Hz - change the value "50" (milliseconds) to set total desired loop. minimum = 35 milliseconds
  while((millis() - last_cycle) < 50){
    delay(1);
  }

  digitalWrite(13, LOW);

  cycle_time = millis() - last_cycle;
  last_cycle = millis();


}


/////////////////////////////// update the accelerometer


void sample_accel(){

  accel_1 = analogRead(accel_pin);
  
  /*
  accel_2 = analogRead(accel_pin);
  accel_3 = analogRead(accel_pin);
  accel_4 = analogRead(accel_pin);
  accel_5 = analogRead(accel_pin);
  accel_6 = analogRead(accel_pin);
  accel_7 = analogRead(accel_pin);
  accel_8 = analogRead(accel_pin);
  accel_9 = analogRead(accel_pin);
  accel_10 = analogRead(accel_pin);

  accel_avg = (accel_1 + accel_2 + accel_3 + accel_4 + accel_5 + accel_6 + accel_7 + accel_8 + accel_9 + accel_10) / 10;

*/

  accel_avg = accel_1;
  
  x_acc_raw = accel_avg - accel_offset;

  x_acc_raw = constrain(x_acc_raw, -100, 100);

  x_acc = (float)(x_acc_raw) * x_acc_scale;

}


///////////////////////////////////////////// gyro functions


void sample_gyro(){

  gval_1 = analogRead(gyro_pin);

  /*
  gval_2 = analogRead(gyro_pin);
   gval_3 = analogRead(gyro_pin);
   gval_4 = analogRead(gyro_pin);
   gval_5 = analogRead(gyro_pin);
   gval_6 = analogRead(gyro_pin);
   gval_7 = analogRead(gyro_pin);
   gval_8 = analogRead(gyro_pin);
   gval_9 = analogRead(gyro_pin);
   gval_10 = analogRead(gyro_pin);
   
   gyro_avg = (gval_1 + gval_2 + gval_3 + gval_4 + gval_5 + gval_6 + gval_7 + gval_8 + gval_9 + gval_10) / 10;
   
  */

  gyro_avg = gval_1;

  gyro_raw = gyro_avg - gyro_offset;

  gyro_raw = constrain(gyro_raw, -388, 388);

  gyro_rate = (float)(gyro_raw) * 0.015;  // should I use the actual number here ? 0.927927928


/*
  if (angle == 0.00 || angle == -0.00){
    gyro_angle = 0.00;
  }

  gyro_angle = gyro_angle + (gyro_rate * -0.10);
*/


}

void get_steering(){
  steer_reading = analogRead(potPin); // We want to coerce this into a range between -1 and 1, and set that to steer_pot
  steer_pot = map(steer_reading, 0, 1023, -100, 100) / 100.0; 
}



///////////////////////////// Update the motors

void update_motor_speed(){
  
  if (angle < -0.4 || angle > 0.4){
  
     motor_out = 0;
    
  } else {
 
    output = Kp * (0.0 - angle) * (0.05);
    
    motor_out = (int)(output * 2200);
    
    if(motor_out > 64){
      motor_out = 64;
    }else if(motor_out < -64){
      motor_out = -64;
    }
  }
  motor_1_out = motor_out + (steer_tweak * steer_pot);
  motor_2_out = motor_out - (steer_tweak * steer_pot);
  
  if(motor_1_out > 63){
    motor_1_out = 63;
  }
  if(motor_1_out < -63){
    motor_1_out = -63;
  }
  if(motor_2_out > 63){
    motor_2_out = 63;
  }
  if(motor_2_out < -63){
    motor_2_out = -63;
  }
  
  m1_speed = 64 + motor_1_out;
  m2_speed = 192 + motor_2_out;
      
  Serial.print(m1_speed, BYTE);
  Serial.print(m2_speed, BYTE);
   

  Serial.print("A: ");  
  Serial.print(x_acc);  
  Serial.print("  ");   

  Serial.print("G: ");  
  Serial.print(gyro_angle);  
  Serial.print("  ");  

  Serial.print("F: ");  
  Serial.print(angle);  
  Serial.print("  "); 
  
  Serial.print("o/m: ");
  Serial.print(output);
  Serial.print("/");
  Serial.print(motor_out);
  Serial.print("  "); 
  
  Serial.print("steer_pot: ");
  Serial.print(steer_pot);
  Serial.print("  "); 
  
  Serial.print("steer_reading: ");
  Serial.print(steer_reading);
  Serial.print("  "); 
  
  Serial.print("m1/m2: ");
  Serial.print(m1_speed);
  Serial.print("/");
  Serial.println(m2_speed);

  
  

    
}





