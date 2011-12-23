// This is the Relay sketch to decode 2 more signals and drive external circuitry
// JDW 2009

int relay_Pin = 4;

int lights_Pin_A = 5;
int lights_Pin_B = 6;

int fx_pin = 7;

int m1_a_in;
int m1_b_in;
int m2_a_in;
int m2_b_in;

int m1_a_out = 3;
int m1_b_out = 11;
int m2_a_out = 9;
int m2_b_out = 10;

int ledPin1 = 12;
int ledPin2 = 13;
int ledPin3 = 14;

int ppm1 = 2; 
int ppm2 = 3;

unsigned long val1;
unsigned long val2;

unsigned long rc1_PulseStartTicks;
volatile unsigned rc1_val; 
int lastgood1;
int adj_val1;  
int rc1_InputReady;

unsigned long rc2_PulseStartTicks;
volatile unsigned rc2_val; 
int lastgood2;
int adj_val2;  
int rc2_InputReady;

int deadband_high = 275; 
int deadband_low = 235;  

int pwm_ceiling = 256; 
int pwm_floor = 255;  

int delta_val = 500; 

int low1 = 1150;
int high1 = 1850;
int low2 = 1150;
int high2 = 1850;

void setup() {

  //TCCR1B = TCCR1B & 0b11111000 | 0x02;  // changes pins 9 and 10 frequency. 0x01 = 32kHz, 0x02 = 4kHz
  //TCCR2B = TCCR2B & 0b11111000 | 0x02;  // changes pins 3 and 11 frequency. 0x01 = 32kHz, 0x02 = 4kHz


  Serial.begin(9600);

  pinMode(fx_pin, INPUT);

  //motor1 pins
  pinMode(relay_Pin, OUTPUT);
  pinMode(lights_Pin_A, OUTPUT);
  pinMode(lights_Pin_B, OUTPUT);
  
  pinMode(m1_a_out, OUTPUT);
  pinMode(m1_b_out, OUTPUT);
  pinMode(m2_a_out, OUTPUT);
  pinMode(m2_b_out, OUTPUT);

  //led's
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);
  pinMode(ledPin3, OUTPUT);

  //PPM inputs from RC receiver
  pinMode(ppm1, INPUT); //Pin 2 as input
  pinMode(ppm2, INPUT); //Pin 3 as input

  attachInterrupt(0, rc1, CHANGE);    // catch interrupt 0 (digital pin 2) going HIGH and send to rc1()
  attachInterrupt(1, rc2, CHANGE);    // catch interrupt 1 (digital pin 3) going HIGH and send to rc2()


  lastgood1 = 255; 
  lastgood2 = 255;

}


void rc1() {
  if (digitalRead( ppm1 ) == HIGH)
  {
    rc1_PulseStartTicks = micros();
  }
  else {
    rc1_val = micros() - rc1_PulseStartTicks; 
    rc1_InputReady = true;
  }
}

void rc2()
{
  if (digitalRead( ppm2 ) == HIGH)
  {
    rc2_PulseStartTicks = micros();
  }
  else
  {
    rc2_val = micros() - rc2_PulseStartTicks; 
    rc2_InputReady = true;
  }
}



}

void loop() {

		
if (rc1_val < 2100 || rc1_val > 2200) {

    digitalWrite(relay_Pin, LOW); 

    digitalWrite(ledPin3, HIGH);

  }



  else {

    digitalWrite(ledPin3, LOW);

    if (rc1_InputReady)
    {

      rc1_InputReady = false;  
      adj_val1 = map(constrain(rc1_val, 600, 2400), low1, high1, 0, 511); 
      constrain(adj_val1, 0, 511);

      if (adj_val1 <= 0){	    
        adj_val1 = lastgood1;
      }
      else if (adj_val1 >= 511){  
        adj_val1 = lastgood1;
      }
      else if (((adj_val1 - lastgood1) * 2) > delta_val){   
        adj_val1 = lastgood1;
      }
      else {
        lastgood1 = adj_val1;   
      }


      ///////// Motor Controller Relay /////////

      if (adj_val1 > deadband_high) {
        digitalWrite(relay_Pin, HIGH);
        digitalWrite(ledPin1, LOW);
      }

      else {
        digitalWrite(relay_Pin, LOW);
        digitalWrite(ledPin1, HIGH); // turn on neutral light, turn motor pins off
      }
    }

/*

    if (rc2_InputReady)
    {
      rc2_InputReady = false;

      adj_val2 = map(constrain(rc2_val, 600, 2400), low2, high2, 0, 511); 
      constrain(adj_val2, 0, 511);
      
      if (adj_val2 <= 0){	  
        adj_val2 = lastgood2;
      }
      else if (adj_val2 >= 511){ 
        adj_val2 = lastgood2;
      }
      else if (((adj_val2 - lastgood2) * 2) > delta_val){   
        adj_val2 = lastgood2;
      }
      else {
        lastgood2 = adj_val2;  
      }

      ///////// LIGHTS /////////

      if (adj_val2 > deadband_high) {
				digitalWrite(lights_Pin_B, LOW);
        analogWrite(lights_Pin_A, adj_val2 - pwm_ceiling);
        digitalWrite(ledPin2, LOW);
      }

      else if (adj_val2 < deadband_low) {
				digitalWrite(lights_Pin_A, LOW);
        analogWrite(lights_Pin_B, pwm_floor - adj_val2);
        digitalWrite(ledPin2, LOW);
      }

      else {
        digitalWrite(lights_Pin_A, LOW);
				digitalWrite(lights_Pin_B, LOW);
        digitalWrite(ledPin2, HIGH); 
      }
    }

*/


/*
    //print values
    Serial.print("ch1:  ");
    Serial.print(adj_val1);
    Serial.print("  ");
    Serial.print("rc1:  ");
    Serial.print(rc1_val);
    Serial.print("  ");
    Serial.print("ch2:  ");
    Serial.print(adj_val2);
    Serial.print("  ");
    Serial.print("rc2:  ");
    Serial.print(rc2_val);
    Serial.print("  ");
    Serial.print("high1:  ");
    Serial.print(high1);
    Serial.print("  ");
    Serial.print("low1:  ");
    Serial.print(low1);
    Serial.print("  ");
    Serial.print("high2:  ");
    Serial.print(high2);
    Serial.print("  ");
    Serial.print("low2:  ");
    Serial.print(low2);
    Serial.println("  ");    


	// changes the frequency of the motor driver lines
	analogWrite(m1_a_out, m1_a_in);
        analogWrite(m1_b_out, m1_b_in);
	analogWrite(m2_a_out, m2_a_in);
	analogWrite(m2_b_out, m2_b_in);
*/
  }
}

