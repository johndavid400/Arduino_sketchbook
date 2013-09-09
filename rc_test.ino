
// declare R/C inputs
int rc1 = 14;
int rc2 = 15;
int rc1_val = 0;
int rc2_val = 0;

void setup(){
  Serial.begin(9600);
  pinMode(INPUT, rc1);
  pinMode(INPUT, rc2);
}

void loop(){
 rc1_val = pulseIn(rc1, HIGH, 20000);
 rc2_val = pulseIn(rc2, HIGH, 20000);
 Serial.print("  RC1 Raw: ");
 Serial.print(rc1_val);
 Serial.print("  RC2 Raw: ");
 Serial.print(rc2_val);
 Serial.println("");
}
