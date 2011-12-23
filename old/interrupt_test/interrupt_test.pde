unsigned long start_pulse;
volatile int pulse_length;
int pulse_value;

void setup() {
pinMode(2, INPUT);
attachInterrupt(0, my_ISR, CHANGE);
}

void my_ISR() {
if (digitalRead(2) == HIGH){
  start_pulse = micros();
  }
else {
  pulse_length = micros() - start_pulse;
}
}

void loop() {
 pulse_value = map(pulse_length, 1000, 2000, 0, 255);
 analogWrite(3, pulse_value);
}
