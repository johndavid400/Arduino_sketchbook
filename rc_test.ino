
// declare R/C inputs
int rc1 = 14;
int rc2 = 15;

void setup(){
  Serial.begin(9600);
  // setup input pins for R/C
  pinMode(INPUT, rc1);
  pinMode(INPUT, rc2);
}

void loop(){
 read_rc();
 serial_print_stuff();
}

void read_rc(){
 // read and map rc1
 rc1_val = pulseIn(rc1, HIGH, 20000);
 //rc1_speed = map(rc1_val, 1000, 2000, -255, 255);
 // read and map rc2
 rc2_val = pulseIn(rc2, HIGH, 20000);
 //rc2_speed = map(rc2_val, 1000, 2000, -255, 255);
}

void serial_print_stuff(){
 // print values for rc1
 Serial.print("  RC1 Raw: ");
 Serial.print(rc1_val);
 Serial.print("  RC1 Adj: ");
 Serial.print(rc1_speed);
 // print values for rc1
 Serial.print("  RC2 Raw: ");
 Serial.print(rc2_speed);
 Serial.print("  RC2 Adj: ");
 Serial.print(rc2_val);
 // print new line
 Serial.println("");
}
