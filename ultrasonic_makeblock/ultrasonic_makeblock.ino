
int center_sensor = 0;
int rear_sensor = 0;
int front_sensor = 0;

int center_distance = 20;
int right_distance = 12;

int dir_a = 12;
int pwm_a = 3;
int dir_b = 13;
int pwm_b = 11;

void setup(){
  Serial.begin(9600);
  pinMode(dir_a, OUTPUT);
  pinMode(pwm_a, OUTPUT);
  pinMode(dir_b, OUTPUT);
  pinMode(pwm_b, OUTPUT);
  
  gather();
  print_stuff();
}

void gather(){
  int sample_count = 3;
  int front_sum = 0;
  int center_sum = 0;
  int rear_sum = 0;
  
  for(int x = 0; x < sample_count; x++){
    front_sum += analogRead(0);
    center_sum += analogRead(1);
    rear_sum += analogRead(2);
  }
  
  front_sensor = front_sum / sample_count;
  center_sensor = center_sum / sample_count;
  rear_sensor = rear_sum / sample_count;
  
}

void loop(){
  //gather();
  //print_stuff();
}

void print_stuff(){
  Serial.print("Center: ");
  Serial.print(center_sensor);
  Serial.print("          ");

  Serial.print("Front: ");
  Serial.print(front_sensor);  
  Serial.print("          ");

  Serial.print("Rear: ");
  Serial.print(rear_sensor);
  Serial.println("          ");
}

void m1_forward(int x){
  digitalWrite(dir_a, LOW);
  analogWrite(pwm_a, x);  
}

void m1_reverse(int x){
  digitalWrite(dir_a, HIGH);
  analogWrite(pwm_a, x);  
}

void m1_stop(){
  digitalWrite(dir_a, LOW);
  digitalWrite(pwm_a, LOW);  
}

void m2_forward(int x){
  digitalWrite(dir_b, LOW);
  analogWrite(pwm_b, x);  
}

void m2_reverse(int x){
  digitalWrite(dir_b, HIGH);
  analogWrite(pwm_b, x);  
}

void m2_stop(){
  digitalWrite(dir_b, LOW);
  digitalWrite(pwm_b, LOW); 
}

void stop_motors(){
  m1_stop();
  m2_stop();
}























