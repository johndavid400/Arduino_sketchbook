

volatile unsigned long ppm_start;
volatile int ch1;
volatile int ch2;
volatile int ch3;
volatile int ch4;
volatile int ch5;
volatile int ch6;

volatile int channel = 0;



void setup() {
  
 Serial.begin(9600);
  
  pinMode(2, INPUT);

  attachInterrupt(0, ppm_begin, RISING);

}


void ppm_begin() {
  
 ppm_start = micros();
 
 detachInterrupt(0);
 
 attachInterrupt(0, ppm_end, FALLING);
 
 if (channel == 0){
   ch1 = micros() - ppm_start;
 }
 if (channel == 1){
   ch2 = micros() - ppm_start; 
 }
 if (channel == 2){
   ch3 = micros() - ppm_start;
 }
 if (channel == 3){
   ch4 = micros() - ppm_start; 
 }
 if (channel == 4){
   ch5 = micros() - ppm_start;
 }
 if (channel == 5){
   ch6 = micros() - ppm_start; 
 }
 if (channel == 6){
   if (micros() - ch6 > 6000){
     channel = 0;
   }
 }
 
 if (channel >= 7){
   channel = 0;
 }
 
 
}

void ppm_end() {

 detachInterrupt(0); 
 attachInterrupt(0, ppm_begin, RISING);
  
 channel++;
 
}


void loop() {
  
 Serial.print("ch1:   ");
 Serial.print(ch1);
 Serial.print("       ");

 Serial.print("ch2:   ");
 Serial.print(ch2);
 Serial.print("       ");
 
 Serial.print("ch3:   ");
 Serial.print(ch3);
 Serial.print("       ");
 
 Serial.print("ch4:   ");
 Serial.print(ch4);
 Serial.print("       ");
 
 Serial.print("ch5:   ");
 Serial.print(ch5);
 Serial.print("       ");
 
 Serial.print("ch6:   ");
 Serial.print(ch6);
 Serial.print("       ");

 Serial.println("      ");
 
}


