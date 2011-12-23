
#include <Stepper.h>
#define STEPS 48

#include "WProgram.h"
void setup();
void loop();
Stepper stepper(STEPS, 5, 6, 9, 10);

int set_steps = 30;
int val = 0;
int previous = 0;

int forward_threshold = 542;
int reverse_threshold = 482;

void setup()
{

  Serial.begin(9600);
  stepper.setSpeed(30);

}

void loop()
{

  val = analogRead(1);

  if (val > forward_threshold) {
    stepper.step(val - forward_threshold); 
  }
  else if (val < reverse_threshold) {
    stepper.step(-(reverse_threshold - val));
  }
  else{
    
  }

  Serial.print("val: ");
  Serial.print(val);
  Serial.println("          ");

}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

