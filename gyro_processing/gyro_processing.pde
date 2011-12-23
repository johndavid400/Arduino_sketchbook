//TWIN WHEELER MODIFIED FOR ARDUINO SIMPLIFIED SERIAL PROTOCOL TO SABERTOOTH V2
//J. Dingley For Arduino 328 Duemalinove or similar with a 3.3V accessory power output
//i.e. the current standard Arduino board.

//2nd April 2010
//small bugs fixed. Now uses second gyro to maintain a constant rate of turn in degrees per second
//I have now built this as a skateboard with 24V lead acid batteries, 2x250Watt motors and Razor E100 chain driven wheels
//and it balances and turns fine with me standing on top of it.






#include <SoftwareSerial.h>

//Set dip switches on the Sabertooth for simplified serial and 9600 Buadrate. Diagram of this on my Instructables page//

//Digital pin 13 is serial transmit pin to sabertooth
#define SABER_TX_PIN 13
//Not used but still initialised, Digital pin 12 is serial receive from Sabertooth
#define SABER_RX_PIN 12

//set baudrate to match sabertooth dip settings
#define SABER_BAUDRATE 9600

//simplifierd serial limits for each motor
#define SABER_MOTOR1_FULL_FORWARD 127
#define SABER_MOTOR1_FULL_REVERSE 1

#define SABER_MOTOR2_FULL_FORWARD 255
#define SABER_MOTOR2_FULL_REVERSE 128

//motor level to send when issuing full stop command
#define SABER_ALL_STOP 0


SoftwareSerial SaberSerial = SoftwareSerial (SABER_RX_PIN, SABER_TX_PIN );

void initSabertooth (void) {
//initialise software to communicate with sabertooth
pinMode ( SABER_TX_PIN, OUTPUT );


SaberSerial.begin( SABER_BAUDRATE );
//2 sec delay to let it settle
delay (2000);
SaberSerial.print(0, BYTE); //kill motors when first switched on
}


//setup all variables. Terms may have strange names but this software has evolved from bits and bobs done by other segway clone builders
float level=0;
float aa = 0.005; //this means 0.5% of the accelerometer reading is fed into angle of tilt calculation with every loop of program (to correct the gyro).
//accel is sensitive to vibration which is why we effectively average it over time in this manner. You can increase aa if you want experiment.
//too high though and the board may become too vibration sensitive.
float Steering;
float SteerValue;
float SteerCorrect;
float steersum;
int Steer = 0;

float accraw;
float x_acc;
float accsum;
float x_accdeg;

float gyrosum;
float hiresgyrosum;
float g;
float s;
float t;

float gangleratedeg;
float gangleratedeg2;

int adc1;
int adc4;
int adc5;


float gangleraterads;
float ti = 2;



float k1;
int k2;
int k3;
int k4;

float overallgain; //potentiometer on an anlog input allows you to change "feel" of board from "squishy" to "tight" or even "very jumpy" if turned up too far.

float gyroangledt;
float angle;
float anglerads;
float balance_torque;
float softstart;

float cur_speed;
//float cycle_time = 0.00555; //seconds per cycle - currently 5.55 milliseconds per loop of the program. If you change it a lot you can measure the pulse coming out of
//digital pin 8 (one per program cycle) to reccalculate this variable. Need to know it as gyro measures rate of turning. Needs to know time between each measurement
//so it can then work out angle it has turned through since the last measurement - so it can know angle of tilt from vertical.
float cycle_time = 0.01;
float Balance_point;
float balancetrim;

int balleft;
int balright;

float a0, a1, a2, a3, a4, a5, a6; //Sav Golay variables. The TOBB bot describes this neat filter for accelerometer called Savitsky Golay filter.
//More on this plus links on my website.

int i;
int j;
int tipstart;

signed char Motor1percent;
signed char Motor2percent;

//analog inputs. Wire up the IMU as in my Instructable and these inputs will be valid.
int accelPin = 4; //pin 4 is analog input pin 4. z-acc to analog pin 4
int gyroPin = 3; //pin 3 is analog balance gyro input pin. Y-rate to analog pin 3
int steergyroPin = 2; //steergyro analog input pin 2. x-rate to analog pin 2. This gyro allows software to "resist" sudden turns (i.e. when one wheel hits small object)
//I have just used the low res output from this gyro.
int overallgainPin = 1; //overall gain analog pin 1. Gain knob to analog pin 1
int hiresgyroPin = 0; //hi res balance gyro input is analog pin 0. Y-rate 4.5 to analog pin 0
//The IMU has a low res and a high res output for each gyro. Low res one used by software when tipping over fast and higher res one when tipping gently.
//digital inputs
int deadmanbuttonPin = 9; // deadman button is digital input pin 9
int balancepointleftPin = 7; //if digital pin 7 is 5V then reduce balancepoint variable. Allows manual fine tune of the ideal target balance point
int balancepointrightPin = 6; //if digital pin 6 is 5V then increase balancepoint variable. Allows manual fine tune of the ideal target balance point
int steeringvariableleftPin = 5; //digital pin5 Used to steer
int steeringvariablerightPin = 4; //digital pin 4 Used to steer the other way.
//digital outputs
int oscilloscopePin = 8; //oscilloscope pin is digital pin 8 so you can work out the program loop time (currently about 5.5millisec)

void setup() // run once, when the sketch starts
{
initSabertooth( );
//analogINPUTS
pinMode(accelPin, INPUT);
pinMode(gyroPin, INPUT);
pinMode(steergyroPin, INPUT);
pinMode(overallgainPin, INPUT);

pinMode(hiresgyroPin, INPUT);

//digital inputs
pinMode(deadmanbuttonPin, INPUT);
pinMode(balancepointleftPin, INPUT);
pinMode(balancepointrightPin, INPUT);
pinMode(steeringvariableleftPin, INPUT);
pinMode(steeringvariablerightPin, INPUT);

//digital outputs
pinMode(oscilloscopePin, OUTPUT);


//Serial.begin(9600); // HARD wired Serial feedback to PC for debugging in Wiring


}








void sample_inputs() {
gyrosum = 0;
steersum = 0;
hiresgyrosum = 0;

accraw = analogRead(accelPin); //read the accelerometer pin (0-1023)

//Take a set of 7 readings very fast
for (j=0; j<7; j++) {
adc1 = analogRead(gyroPin);
adc4 = analogRead(steergyroPin);
adc5 = analogRead(hiresgyroPin);
gyrosum = (float) gyrosum + adc1; //sum of the 7 readings
steersum = (float) steersum + adc4; //sum of the 7 readings
hiresgyrosum = (float)hiresgyrosum +adc5; //sum of the 7 readings
}

k1 = analogRead(overallgainPin);

k2 = digitalRead(steeringvariableleftPin);
k3 = digitalRead(steeringvariablerightPin);
k4 = digitalRead(deadmanbuttonPin);


overallgain = (float) (((k1/852)*0.01) + (overallgain*0.99)); //smooths any voltage spikes in k1 potentiometer readings but allows overallgain to be changed while machine running



balleft = digitalRead(balancepointleftPin);
balright = digitalRead(balancepointrightPin);


if (balleft == 1) balancetrim = balancetrim - 0.04; //if pressing balance point adjust switch then slowly alter the balancetrim variable by 0.04 per loop of the program
//while you are pressing the switch
if (balright == 1) balancetrim = balancetrim + 0.04; //same again in other direction
if (balancetrim < -30) balancetrim = -30; //stops you going too far with this
if (balancetrim > 30) balancetrim = 30; //stops you going too far the other way



// Savitsky Golay filter for accelerometer readings. It is better than a simple rolling average which is always out of date.
// SG filter looks at trend of last few readings, projects a curve into the future, then takes mean of whole lot, giving you a more "current" value - Neat!
// Lots of theory on this on net.
a0 = a1;
a1 = a2;
a2 = a3;
a3 = a4;
a4 = a5;
a5 = a6;
a6 = (float) accraw;

accsum = (float) ((-2*a0) + (3*a1) + (6*a2) + (7*a3) + (6*a4) + (3*a5) + (-2*a6))/21;
//accsum isnt really a "sum" (it used to be once),
//now it is the accelerometer value from the rolling SG filter on the 0-1023 scale

digitalWrite(oscilloscopePin, HIGH); //puts out signal to oscilloscope


gangleratedeg2 = (float) ((steersum/7) - s) * 2.44; //divide by 0.41 as for low resolution balance gyro i.e. multiply by 2.44
// NO steering wanted. Use second gyro to maintain a (roughly) straight line heading (it will drift a bit).
if (k2 == 0 && k3 == 0) {

//gangleratedeg2 = (float) ((steersum/7) - s) * 2.44; //divide by 0.41 as for low resolution balance gyro i.e. multiply by 2.44

SteerCorrect = 0; //blocks the direction stabiliser unless rate of turn exceeds -10 or +10 degrees per sec
if (gangleratedeg2 > 10 || gangleratedeg2 < -10) { //resists turning if turn rate exceeds 10deg per sec
SteerCorrect = (float) 0.4 * gangleratedeg2; //vary the 0.4 according to how much "resistance" to being nudged off course you want.
//a value called SteerCorrect is added to the steering value proportional to the rate of unwanted turning. It keeps getting
//larger if this condition is till being satisfied i.e. still turning >10deg per sec until the change has been resisted.
//can experiment with the value of 10. Try 5 deg per sec if you want - play around - this can probably be improved
//but if you try to turn it fast with your hand while balancing you will feel it resisting you so it does work
//also, when coming to a stop, one motor has a bit more friction than the other so as this motor stops first then as board
//comes to standstill it spins round and you can fall off. This is original reason I built in this feature.
//if motors have same friction you will not notice it so much.
}
//Serial.println(gangleratedeg2); //for debugging
//delay(50);
SteerValue = 512;

}

else {
//i.e. we DO want to steer


//steer one way SteerValue of 512 is straight ahead
if (k2 == 1) {
if (gangleratedeg2 < 5) { //will turn clockwise at 5 degrees per sec and if not, more power fed into steering until it does
SteerValue = SteerValue + 1;
}
if (gangleratedeg2 > 5) {
SteerValue = SteerValue - 1;
}
}
//change the 5 and -5 values if you want faster turn rates. Could use a potentiometer to control these values so would have proportional control of steering

//steer the other way
if (k3 == 1) {
if (gangleratedeg2 < -5) { //will turn anticlockwise at 5 degrees per sec and if not, more power fed into steering until it does
SteerValue = SteerValue + 1;
}
if (gangleratedeg2 > -5) {
SteerValue = SteerValue - 1;
}
}

if (SteerValue < 1) {
SteerValue = 1;
}
if (SteerValue > 1023) {
SteerValue = 1023;
}

SteerCorrect = 0;

}


/*
//for debugging. NOTE: when debugging with serial print commands to your PC the cycle time of program will slow down beyond the 5.5ms it is set up for and the
//angle values etc can turn into nonsense even if there is nothing wrong with your code otherwise
Serial.print(k1);
Serial.print(" ");
Serial.print(k2);
Serial.print(" ");
Serial.print(k3);
Serial.print(" ");
Serial.print(k4);
Serial.print(" ");
Serial.print(balleft);
Serial.print(" ");
Serial.print(balright);
Serial.println(" ");
*/

//ACCELEROMETER notes for the 5 d of f Sparfun IMU I have used in my Instructable:
//300mV (0.3V) per G i.e. at 90 degree angle
//Supply 3.3V is OK from Arduino NOT the 5V supply. Modern Arduinos have a 3.3V power out for small peripherals like this.
//Midpoint is 1.58 Volts when supply to IMU is 3.3V i.e. 323 on the 0-1024 scale when read from a 0-5V Arduino analog input pin
//not the 512 we are all perhaps more used to with 5V powered accel and gyro systems.
//testing with voltmeter over 0-30 degree tilt range shows about 5.666mV per degree. Note: Should use the Sin to get angle i.e. trigonometry, but over our small
//tilt angles (0-30deg from the vertical) the raw value is very similar to the Sin so we dont bother calculating it.
// 1mv is 1024/5000 = 0.2048 steps on the 0-1023 scale so 5.666mV is 1.16 steps on the 0-1023 scale



x_accdeg = (float)((accsum - (350 + balancetrim))*0.862); //approx 1.16 steps per degree so divide by 1.16 i.e. multiply by 0.862
if (x_accdeg < -72) x_accdeg = -72; //rejects silly values to stop it going berserk!
if (x_accdeg > 72) x_accdeg = 72;

/*
//for debugging
Serial.print("accsum = ");
Serial.println(accsum);
Serial.print("balancetrim = ");
Serial.println(balancetrim);
Serial.print("x_accdeg = ");
Serial.println(x_accdeg);
*/

//GYRO NOTES:
//Low resolution gyro output: 2mV per degree per sec up to 500deg per sec. 5V = 1024 units on 0-1023 scale, 1Volt = 204.8 units on this scale.
//2mV = 0.41 units = 1deg per sec
// Hi res gyro output pin(from the same gyro): 9.1mV per degree per sec up to 110deg per sec on hires input. 5V = 1024 units on 0-1023 scale, 1Volt = 204.8 units on this scale.
//9.1mV = 1.86 units = 1 deg per sec

//Low res gyro rate of tipping reading calculated first
gangleratedeg = (float)(((gyrosum/7) - g)*2.44); //divide by 0.41 for low res balance gyro i.e. multiply by 2.44

if (gangleratedeg < -450) gangleratedeg = -450; //stops crazy values entering rest of the program
if (gangleratedeg > 450) gangleratedeg = 450;

//debugging relic
//Serial.print("gangleratedeg1 = ");
//Serial.println(gangleratedeg);



//..BUT...Hi res gyro ideally used to re-calculate the rate of tipping in degrees per sec, i.e. use to calculate gangleratedeg IF rate is less than 100 deg per sec
if (gangleratedeg < 100 && gangleratedeg > -100) {
gangleratedeg = (float)(((hiresgyrosum/7) - t)*0.538); //divide by 1.86 i.e. multiply by 0.538
if (gangleratedeg < -110) gangleratedeg = -110;
if (gangleratedeg > 110) gangleratedeg = 110;
}
//debugging relic
//Serial.print("gangleratedeg2 = ");
//Serial.println(gangleratedeg);

digitalWrite(oscilloscopePin, LOW); //cuts signal to oscilloscope pin so we have one pulse on scope per cycle of the program so we can work out cycle time.


//Key calculations. Gyro measures rate of tilt gangleratedeg in degrees. We know time since last measurement is cycle_time (5.5ms) so can work out much we have tipped over since last measurement
//What is ti variable? Strictly it should be 1. However if you tilt board, then it moves along at an angle, then SLOWLY comes back to level point as it is moving along
//this suggests the gyro is slightly underestimating the rate of tilt and the accelerometer is correcting it (slowly as it is meant to).
//This is why, by trial and error, I have increased ti to 1.2 at start of program where I define my variables.
//experiment with this variable and see how it behaves. Temporarily reconfigure the overallgain potentiometer as an input to change ti and experiment with this variable
//potentiometer is useful for this sort of experiment. You can alter any variable on the fly by temporarily using the potentiometer to adjust it and see what effect it has
gyroangledt = (float) ti * cycle_time * gangleratedeg;
gangleraterads = (float) gangleratedeg * 0.017453; //convert to radians - just a scaling issue from history
angle = (float) ((1-aa) * (angle + gyroangledt)) + (aa * x_accdeg);//aa allows us to feed a bit (0.5%) of the accelerometer data into the angle calculation
//so it slowly corrects the gyro (which drifts slowly with tinme remember). Accel sensitive to vibration though so aa does not want to be too large.
//this is why these boards do not work if an accel only is used. We use gyro to do short term tilt measurements because it is insensitive to vibration
//the video on my instructable shows the skateboard working fine over a brick cobbled surface - vibration +++ !
anglerads = (float) angle * 0.017453; //converting to radians again a historic scaling issue from past software


//debugging
//Serial.print("Angle = ");
//Serial.println(angle);


balance_torque = (float) (4.5 * anglerads) + (0.5 * gangleraterads); //power to motors (will be adjusted for each motor later to create any steering effects
//balance torque is motor control variable we would use even if we just ahd one motor. It is what is required to make the thing balance only.
//the values of 4.5 and 0.5 came from Trevor Blackwell's segway clone experiments and were derived by good old trial and error
//I have also found them to be about right
//We set the torque proportionally to the actual angle of tilt (anglerads), and also proportional to the RATE of tipping over (ganglerate rads)
//the 4.5 and the 0.5 set the amount of each we use - play around with them if you want.
//Much more on all this, PID controlo etc on my website
cur_speed = (float) (cur_speed + (anglerads * 6 * cycle_time)) * 0.999;
//this is not current speed. We do not know actual speed as we have no wheel rotation encoders. This is a type of accelerator pedal effect:
//this variable increases with each loop of the program IF board is deliberately held at an angle (by rider for example)
//So it means "if we are STILL tilted, speed up a bit" and it keeps accelerating as long as you hold it tilted.
//You do NOT need this to just balance, but to go up a slight incline for example you would need it: if board hits incline and then stops - if you hold it
//tilted for long eneough, it will eventually go up the slope (so long as motors powerfull enough and motor controller powerful enough)
//Why the 0.999 value? I got this from the SeWii project code - thanks!
//If you have built up a large cur_speed value and you tilt it back to come to a standstill, you will have to keep it tilted back even when you have come to rest
//i.e. board will stop moving OK but will now not be level as you are tiliting it back other way to counteract this large cur_speed value
//The 0.999 means that if you bring board level after a long period tilted forwards, the cur_speed value magically decays away to nothing and your board
//is now not only stationary but also level!
level = (float)(balance_torque + cur_speed) * overallgain;
//level = (float)balance_torque * overallgain; //You can omit cur speed term during testing while just getting it to initially balance if you want to
//avoids confusion


}





void set_motor() {
unsigned char cSpeedVal_Motor1 = 0;
unsigned char cSpeedVal_Motor2 = 0;

level = level * 200; //changes it to a scale of about -100 to +100

//debugging
//Serial.print("level on -100 to +100 scale = ");
//Serial.println(level);

Steer = (float) SteerValue - SteerCorrect; //at this point is on the 0-1023 scale
//SteerValue is either 512 for dead ahead or bigger/smaller if you are pressing steering switch left or right
//SteerCorrect is the "adjustment" made by the second gyro that resists sudden turns if one wheel hits a small object for example.
Steer = (Steer - 512) * 0.19; //gets it down from 0-1023 (with 512 as the middle no-steer point) to -100 to +100 with 0 as the middle no-steer point on scale

//debugging
//Serial.print("Steer on -100 to +100 scale is= ");
//Serial.println(Steer);



//set motors using the simplified serial Sabertooth protocol (same for smaller 2 x 5 Watt Sabertooth by the way)

Motor1percent = (signed char) level + Steer;
Motor2percent = (signed char) level - Steer;

if (Motor1percent > 100) Motor1percent = 100;
if (Motor1percent < -100) Motor1percent = -100;
if (Motor2percent > 100) Motor2percent = 100;
if (Motor2percent < -100) Motor2percent = -100;

//if not pressing deadman button on hand controller - cut everything
if (k4 < 1) {
level = 0;
Steer = 0;
Motor1percent = 0;
Motor2percent = 0;
}

cSpeedVal_Motor1 = map (Motor1percent,
-100,
100,
SABER_MOTOR1_FULL_REVERSE,
SABER_MOTOR1_FULL_FORWARD);

cSpeedVal_Motor2 = map (Motor2percent,
-100,
100,
SABER_MOTOR2_FULL_REVERSE,
SABER_MOTOR2_FULL_FORWARD);

SaberSerial.print (cSpeedVal_Motor1, BYTE);
SaberSerial.print (cSpeedVal_Motor2, BYTE);

/*
//debugging
Serial.print("Motor1percent = ");
Serial.print(Motor1percent);
Serial.print (" level = ");
Serial.println (level);

Serial.print("Motor2percent = ");
Serial.println(Motor2percent);
Serial.print("cSpeedVal_Motor1 = ");
Serial.println(cSpeedVal_Motor1);
Serial.print("cSpeedVal_Motor2 = ");
Serial.println(cSpeedVal_Motor2);
*/
delay(4); //4ms delay

}






void loop () {



tipstart = 0;
overallgain = 0;
cur_speed = 0;
level = 0;
Steer = 0;
balancetrim = 0;

//Tilt board one end on floor. Turn it on. This 200 loop creates a delay while you finish turning it on and let go i.e. stop wobbling it about
//as now the software will read the gyro values when there is no rotational movement to find the zero point for each gyro. I could have used a simple delay command.
for (i=0; i<200; i++) {
sample_inputs();
}

//now you have stepped away from baord having turned it on, we get 7 readings from each gyro (and a hires reading from the balance gyro)
g = (float) gyrosum/7; //gyro balance value when stationary i.e. 1.35V
s = (float) steersum/7; //steer gyro value when stationary i.e. about 1.32V
t = (float) hiresgyrosum/7; //hiresgyro balance output when stationary i.e. about 1.38V

//we divide sum of the 7 readings by 7 to get mean for each


//tiltstart routine now comes in. It is reading the angle from accelerometer. When you first tilt the board past the level point
//the self balancing algorithm will go "live". If it did not have this, it would fly across the room as you turned it on (tilted)!
while (tipstart < 5) {
for (i=0; i<10; i++) {
sample_inputs();

}
//x_accdeg is tilt angle from accelerometer in degrees
if (x_accdeg < -12 || x_accdeg > -2) {
tipstart = 0;
overallgain = 0;
cur_speed = 0;
level = 0;
Steer = 0;
balancetrim = 0;
}
else {
tipstart = 5;
}

}


overallgain = (float) k1/852; //range of about 0 to 1.5 set by a potentiometer attached to analog input pin 1, this just sets it the first time around when first balanced



angle = 0;
cur_speed = 0;
Steering = 512;
SteerValue = 512;
balancetrim = 0;

//end of tiltstart code. If go beyond this point then machine is active
//main balance routine, just loops forever. Machine is just trying to stay level. You "trick" it into moving by tilting one end down
//works best if keep legs stiff so you are more rigid like a broom handle is if you are balancing it vertically on end of your finger
//if you are all wobbly, the board will go crazy trying to correct your own flexibility.
//NB: This is why a segway has to have vertical handlebar otherwise ankle joint flexibility in fore-aft direction would make it oscillate wildly.
//NB: This is why the handlebar-less version of Toyota Winglet still has a vertical section you jam between your knees.
while (1) {

sample_inputs();

set_motor();

}


}
