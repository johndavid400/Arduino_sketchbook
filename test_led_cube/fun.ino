// ferris_wheel
// ferris_wheel_side
// spiral
// chase_up
// chase_around
//

void ferris_wheel(){
  v2();
  d1();
  l2();
  d2();
}

void ferris_wheel_side(){
  v5();
  d3();
  l2();
  d4();
}

void spiral(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    led1_1();
    off();
    led4_2();
    off();
    led7_3();
    off();
  }
  t = millis();
  while(millis() < t + delayTime){
    led4_1();
    off();
    led7_2();
    off();
    led8_3();
    off();
  }
  t = millis();
  while(millis() < t + delayTime){
    led7_1();
    off();
    led8_2();
    off();
    led9_3();
    off();
  }
  t = millis();
  while(millis() < t + delayTime){
    led8_1();
    off();
    led9_2();
    off();
    led6_3();
    off();
  }
  t = millis();
  while(millis() < t + delayTime){
    led9_1();
    off();
    led6_2();
    off();
    led3_3();
    off();
  }
  t = millis();
  while(millis() < t + delayTime){
    led6_1();
    off();
    led3_2();
    off();
    led2_3();
    off();
  }
  t = millis();
  while(millis() < t + delayTime){
    led3_1();
    off();
    led2_2();
    off();
    led1_3();
    off();
  }
  t = millis();
  while(millis() < t + delayTime){
    led2_1();
    off();
    led1_2();
    off();
    led4_3();
    off();
  }
}

void chase_up(){
  led1_1_blink();
  led1_2_blink();
  led1_3_blink();
  led2_3_blink();
  led2_2_blink();
  led2_1_blink();
  led3_1_blink();
  led3_2_blink();
  led3_3_blink();
  led6_3_blink();
  led6_2_blink();
  led6_1_blink();
  led5_1_blink();
  led5_2_blink();
  led5_3_blink();
  led4_3_blink();
  led4_2_blink();
  led4_1_blink();
  led7_1_blink();
  led7_2_blink();
  led7_3_blink();
  led8_3_blink();
  led8_2_blink();
  led8_1_blink();
  led9_1_blink();
  led9_2_blink();
  led9_3_blink();
  led6_3_blink();
  led6_2_blink();
  led6_1_blink();
  led5_1_blink();
  led5_2_blink();
  led5_3_blink();
  led4_3_blink();
  led4_2_blink();
  led4_1_blink();
}

void chase_around(){
  led1_1_blink();
  led2_1_blink();
  led3_1_blink();
  led6_1_blink();
  led5_1_blink();
  led4_1_blink();
  led7_1_blink();
  led8_1_blink();
  led9_1_blink();
  led9_2_blink();
  led6_2_blink();
  led3_2_blink();
  led2_2_blink();
  led1_2_blink();
  led4_2_blink();
  led7_2_blink();
  led8_2_blink();
  led5_2_blink();
  led5_3_blink();
  led4_3_blink();
  led7_3_blink();
  led8_3_blink();
  led9_3_blink();
  led6_3_blink();
  led3_3_blink();
  led2_3_blink();
  led1_3_blink();
  led1_2_blink();
}

