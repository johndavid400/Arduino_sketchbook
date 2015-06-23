
int delayTime = 100;
int incrementer = 50;
int functionTimer = 10000;
unsigned long startTime = 0;

int ground1 = 3;
int ground2 = 5;
int ground3 = 6;

int led1 = 2;
int led2 = 4;
int led3 = 7;
int led4 = 8;
int led5 = 9;
int led6 = 10;
int led7 = 11;
int led8 = 12;
int led9 = 13;

void setup(){
  Serial.begin(9600);
  pinMode(ground1, OUTPUT);
  pinMode(ground2, OUTPUT);
  pinMode(ground3, OUTPUT);
  digitalWrite(ground1, HIGH);
  digitalWrite(ground2, HIGH);
  digitalWrite(ground3, HIGH);
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);
  pinMode(led4, OUTPUT);
  pinMode(led5, OUTPUT);
  pinMode(led6, OUTPUT);
  pinMode(led7, OUTPUT);
  pinMode(led8, OUTPUT);
  pinMode(led9, OUTPUT);
}

void loop(){
  startTime = millis() + functionTimer;
  while (startTime > millis()){
    ferris_wheel();
  }
  startTime = millis() + functionTimer;
  while (startTime > millis()){
    spiral();
  }
    startTime = millis() + functionTimer;
  while (startTime > millis()){
    chase_up();
  }
    startTime = millis() + functionTimer;
  while (startTime > millis()){
    ferris_wheel_side();
  }
    startTime = millis() + functionTimer;
  while (startTime > millis()){
    chase_around();
  }
}

