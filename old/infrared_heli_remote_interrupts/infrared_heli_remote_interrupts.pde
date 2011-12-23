int pulse_val;
int ir_pin = 57;
int ir_vals[5];
int x = 0;

int analyzed_channel = 1;

void setup(){
  Serial.begin(9600);
  pinMode(ir_pin, INPUT); 
  Serial.println("Initializing...");
  delay(100);
  Serial.println("Done!");
}

pulse_rise

void loop(){

  if (pulse_val > 50){
    ir_vals[x] = pulse_val;
    x++;

    if (x == 6) {
      x = 0;
    }
  }

  if (x == analyzed_channel){
    Serial.println(ir_vals[analyzed_channel]);
    ir_vals[analyzed_channel] = 0;
  }

}


void pulse(){
  pulse_val = pulseIn(ir_pin, HIGH);
}


