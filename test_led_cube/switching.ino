
void off(){
  groundOff();
  digitalWrite(led1, LOW);
  digitalWrite(led2, LOW);
  digitalWrite(led3, LOW);
  digitalWrite(led4, LOW);
  digitalWrite(led5, LOW);
  digitalWrite(led6, LOW);
  digitalWrite(led7, LOW);
  digitalWrite(led8, LOW);
  digitalWrite(led9, LOW);
}

void on(){
  digitalWrite(led1, HIGH);
  digitalWrite(led2, HIGH);
  digitalWrite(led3, HIGH);
  digitalWrite(led4, HIGH);
  digitalWrite(led5, HIGH);
  digitalWrite(led6, HIGH);
  digitalWrite(led7, HIGH);
  digitalWrite(led8, HIGH);
  digitalWrite(led9, HIGH);
}

void g1_off(){
  digitalWrite(ground1, HIGH);
}
void g2_off(){
  digitalWrite(ground2, HIGH);
}
void g3_off(){
  digitalWrite(ground3, HIGH);
}

void groundOff(){
  g1_off();
  g2_off();
  g3_off();
}

void g1_on(){
  digitalWrite(ground1, LOW);
}
void g2_on(){
  digitalWrite(ground2, LOW);
}
void g3_on(){
  digitalWrite(ground3, LOW);
}

void groundOn(){
  g1_on();
  g2_on();
  g3_on();
}
