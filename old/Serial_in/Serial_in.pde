int incomingByte = 0;	// for incoming serial data

void setup() {
	Serial.begin(115200);	// opens serial port, sets data rate to 9600 bps
        pinMode(13, OUTPUT);
      
    }

void loop() {

	// send data only when you receive data:
	if (Serial.available() > 0) {
		// read the incoming byte:
		incomingByte = Serial.read();

		// say what you got:
		Serial.print("I received: ");
		Serial.println(incomingByte, DEC);

                digitalWrite(13, HIGH);
                
	}

        else {
         
         digitalWrite(13, LOW); 
          
        }

}

