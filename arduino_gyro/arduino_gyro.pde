
float sens= 0.512;
float offset= 316 ;
float count= 0;
float valor =0;
float first_time, time;
float teta=0;

void setup(){
  Serial.begin(9600);
}

void loop(){
//####################################################################//
// //
// Gyro //
// Scale Factor 2.5mV/ �/s = 0.512 counts/ �/s //
// Offset 316 counts = 1562mV = 1.562V //
// ADC 4.88 mV/count // 0.2048 count/mV //
// //
//####################################################################//

count = 0;
for(int i=0;i<20;i++){

count = count + analogRead(3);

}

count = count /20;

valor = (count - offset ) / sens;

time=millis()-first_time;

first_time=millis();

teta=teta+valor*time/1000;

if(teta>-1 && teta<1) teta=0; //avoid drift error


Serial.println(count);

}
