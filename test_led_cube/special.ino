

// horizontal 

void d1(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    led1_1();
    led2_1();
    led3_1();
    off();
    led4_2();
    led5_2();
    led6_2();
    off();
    led7_3();
    led8_3();
    led9_3();
    off();
  }
}

void d2(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    led1_3();
    led2_3();
    led3_3();
    off();
    led4_2();
    led5_2();
    led6_2();
    off();
    led7_1();
    led8_1();
    led9_1();
    off();
  }
}

void d3(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    led1_1();
    led4_1();
    led7_1();
    off();
    led2_2();
    led5_2();
    led8_2();
    off();
    led3_3();
    led6_3();
    led9_3();
    off();
  }
}

void d4(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    led1_3();
    led4_3();
    led7_3();
    off();
    led2_2();
    led5_2();
    led8_2();
    off();
    led3_1();
    led6_1();
    led9_1();
    off();
  }
}

void l1(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    g1_on();
    on();
    off();
  }
}

void l2(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    g2_on();
    on();
    off();
  }
}

void l3(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    g3_on();
    on();
    off();
  }
}

void v1(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    groundOn();
    led_1();
    led_2();
    led_3();
    off();
  }
}

void v2(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    groundOn();
    led_4();
    led_5();
    led_6();
    off();
  }
}

void v3(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    groundOn();
    led_7();
    led_8();
    led_9();
    off();
  }
}

void v4(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    groundOn();
    led_1();
    led_4();
    led_7();
    off();
  }
}

void v5(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    groundOn();
    led_2();
    led_5();
    led_8();
    off();
  }
}

void v6(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    groundOn();
    led_3();
    led_6();
    led_9();
    off();
  }
}

void v7(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    groundOn();
    led_1();
    led_5();
    led_9();
    off();
  }
}

void v8(){
  unsigned long t = millis();
  while(millis() < t + delayTime){
    groundOn();
    led_3();
    led_5();
    led_7();
    off();
  }
}


