// robot with 4 wheel drive
// independent control of each motor


#include <Servo.h>

Servo rl;
Servo rr;
Servo fl;
Servo fr;

void setup(){
  Serial.begin(9600);
  rl.attach(4);
  rr.attach(5);
  fl.attach(6);
  fr.attach(7);
}

void loop(){
  forward(50);
  delay(20);
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
