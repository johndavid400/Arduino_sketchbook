int pulse_val;
int ir_pin = 57;
int ir_vals[5];
int x = 0;

void setup(){
  Serial.begin(9600);
  pinMode(ir_pin, INPUT); 
  Serial.println("Initializing...");
  delay(100);
  Serial.println("Done!");
}

void loop(){

  pulse();

  if (pulse_val > 50){
    ir_vals[x] = pulse_val;
    x++;

    if (x == 6) {
      x = 0;
    }
  }

  if (x == 5){
    for (int y = 0; y <= 5; y++){
      Serial.print(ir_vals[y]);
      Serial.print(" ");
      if (y == 5){
        Serial.println("  ");
      }
      ir_vals[y] = 0;
    }
  }

}


void pulse(){
  pulse_val = pulseIn(ir_pin, HIGH);
}


