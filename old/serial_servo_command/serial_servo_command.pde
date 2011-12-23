/*
 * NewSerialServo
 * --------------
 * Servo control from the Serial port
 *
 * Alteration of the control interface to use < and > keys
 * to slew the servo horn left and right.  Works best with
 * the Linux/Mac terminal "screen" program.
 *
 * Created 10 December 2007
 * copyleft 2007 Brian D. Wendt
 * http://principialabs.com/
 *
 * Adapted from code by Tom Igoe
 * http://itp.nyu.edu/physcomp/Labs/Servo
 */

/** Adjust these values for your servo and setup, if necessary **/
int servoPin     =  2;    // control pin for servo motor
int minPulse     =  600;  // minimum servo position
int maxPulse     =  2400; // maximum servo position
int turnRate     =  100;  // servo turn rate increment (larger value, faster rate)
int refreshTime  =  20;   // time (ms) between pulses (50Hz)

/** The Arduino will calculate these values for you **/
int centerServo;         // center servo position
int pulseWidth;          // servo pulse width
int moveServo;           // raw user input
long lastPulse   = 0;    // recorded time (ms) of the last pulse


void setup() {
  pinMode(servoPin, OUTPUT);  // Set servo pin as an output pin
  centerServo = maxPulse - ((maxPulse - minPulse)/2);
  pulseWidth = centerServo;   // Give the servo a starting point (or it floats)
  Serial.begin(9600);
  Serial.println("      Arduino Serial Servo Control");
  Serial.println("Press < or > to move, spacebar to center");
  Serial.println();
}

void loop() {
  // wait for serial input
  if (Serial.available() > 0) {
    // read the incoming byte:
    moveServo = Serial.read();

    // ASCII '<' is 44, ASCII '>' is 46 (comma and period, really)
    if (moveServo == 44) { pulseWidth = pulseWidth - turnRate; }
    if (moveServo == 46) { pulseWidth = pulseWidth + turnRate; }
    if (moveServo == 32) { pulseWidth = centerServo; }

    // stop servo pulse at min and max
    if (pulseWidth > maxPulse) { pulseWidth = maxPulse; }
    if (pulseWidth < minPulse) { pulseWidth = minPulse; }

    // print pulseWidth back to the Serial Monitor (uncomment to debug)
    // Serial.print("Pulse Width: ");
    // Serial.print(pulseWidth);
    // Serial.println("us");   // microseconds
  }

  // pulse the servo every 20 ms (refreshTime) with current pulseWidth
  // this will hold the servo's position if unchanged, or move it if changed
  if (millis() - lastPulse >= refreshTime) {
    digitalWrite(servoPin, HIGH);   // start the pulse
    delayMicroseconds(pulseWidth);  // pulse width
    digitalWrite(servoPin, LOW);    // stop the pulse
    lastPulse = millis();           // save the time of the last pulse
  }
}


