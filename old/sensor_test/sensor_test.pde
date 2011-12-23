int sensor1 = 0;
int sensor2 = 0;
int sensor3 = 0;
int sensor4 = 0;
int sensor5 = 0;

void setup()  
{
  Serial.begin(9600);
}

void loop(){
sensor1 = analogRead(0);
sensor2 = analogRead(1);
sensor3 = analogRead(2);
sensor4 = analogRead(3);
sensor5 = analogRead(4);

  Serial.print("1:  ");
  Serial.print(sensor1);
  Serial.print("  -  ");

  Serial.print("2:  ");
  Serial.print(sensor2);
  Serial.print("  -  ");

  Serial.print("3:  ");
  Serial.print(sensor3);
  Serial.print("  -  ");

  Serial.print("4:  ");
  Serial.print(sensor4);
  Serial.print("  -  ");

  Serial.print("5:  ");
  Serial.print(sensor5);
  Serial.println(" ");


}
