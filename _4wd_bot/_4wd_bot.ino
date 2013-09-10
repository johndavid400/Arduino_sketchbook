// robot with 4 wheel drive
// independent control of each motor


#include <Servo.h>

Servo rl;
Servo rr;
Servo fl;
Servo fr;

int front_left = 4;

void setup(){
  Serial.begin(9600);

  pinMode(front_left, OUTPUT);

  rl.attach(4);
  rr.attach(5);
  fl.attach(6);
  fr.attach(7);
  delay(200);
}

void loop(){

  digitalWrite(front_left, HIGH);
  delayMicroseconds(1300)
  digitalWrite(front_left, LOW);

}

// functions for movement

void forward(int spd){
  int pos = map(spd, 0, 100, 90, 179);
  rl.write(pos);
  rr.write(pos);
  fl.write(pos);
  fr.write(pos);
}

void reverse(int spd){
  int pos = map(spd, 0, 100, 90, 0);
  rl.write(pos);
  rr.write(pos);
  fl.write(pos);
  fr.write(pos);
}

void left(int spd){
  int left_pos = map(spd, 0, 100, 90, 0);
  int right_pos = map(spd, 0, 100, 90, 179);
  rl.write(left_pos);
  rr.write(right_pos);
  fl.write(left_pos);
  fr.write(right_pos);
}

void right(int spd){
  int left_pos = map(spd, 0, 100, 90, 179);
  int right_pos = map(spd, 0, 100, 90, 0);
  rl.write(left_pos);
  rr.write(right_pos);
  fl.write(left_pos);
  fr.write(right_pos);
}

void glide_left(int spd){
  int x_pos = map(spd, 0, 100, 90, 0);
  int y_pos = map(spd, 0, 100, 90, 179);
  rl.write(x_pos);
  rr.write(y_pos);
  fl.write(y_pos);
  fr.write(x_pos);
}

void glide_right(int spd){
  int x_pos = map(spd, 0, 100, 90, 179);
  int y_pos = map(spd, 0, 100, 90, 0);
  rl.write(x_pos);
  rr.write(y_pos);
  fl.write(y_pos);
  fr.write(x_pos);
}

void stop(){
  int val = 89;
  rl.write(val);
  rr.write(val);
  fl.write(val);
  fr.write(val);
}


