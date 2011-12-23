/*By Chris Anderson & Jordi Munoz*/
/*ArduPilot Beta 2*/
/*Feb/18/2009*/
/*Released under an Apache 2.0 open source license*/
/*Project home page is at DIYdrones.com (and ArduPilot.com)
/*We hope you improve the code and share it with us at DIY Drones!*/

// gute Werte f\u00fcr Einkiel-Rumpf: kp = 0.6, ki=0.05, kd= 0.1, Speed = 80 
// gute Werte f\u00fcr Katamaran-Rumpf: kp = 2.5, ki=0.03, kd= 0.1, Speed = 80 

#define CATAMARAN
//#define LONGKEEL
//define GLIDER


//Defining ranges of the servos (and ESC), must be +-90 degrees. 
#define max16_throttle 2100 //ESC max position, given in useconds, in my ungly servos 2100 is fine, you can try 2000..
#define min16_throttle 1000 //ESC position 

#define max16_yaw 2100 //Servo max position
#define min16_yaw 1000 //Servo min position

#define reverse_yaw 1 // normal = 0 and reverse = 1

//PID max and mins
#define   heading_max 70
#define   heading_min -70

#define INTEGRATOR_MAX 1100.0
#define INTEGRATOR_MIN -1100.0

//Number of waypoints defined
#include "WProgram.h"
void setup();
void loop();
void send_to_ground(void);
void  print_header(void);
int compass_error(int PID_set_Point, int PID_current_Point);
int ram_info();
void finish_mission(void);
void yaw_control(void);
void steer_course (int fixcourse);
void gps_parse_nmea(void);
int get_gps_course(float flat1, float flon1, float flat2, float flon2);
unsigned int get_gps_dist(float flat1, float flon1, float flat2, float flon2);
void gps_init_baudrate(void);
void init_ardupilot(void);
void init_startup_parameters(void);
int PID_heading(int PID_error);
void reset_PIDs(void);
void Init_servo(void);
void pulse_servo_throttle(long angle);
void pulse_servo_yaw(long angle);
void bldc_arm_throttle(void);
void bldc_start_throttle(void);
void bldc_stop_throttle(void);
void test_yaw(void);
int waypoints;

typedef struct {  float lon; 
                  float lat;
               }LONLAT; 

#if 0 // Test_LowSpeed.kml
LONLAT wps[] = 
{                
10.02069619383977, 48.35006621372347, 
10.02018762320307, 48.35061609619746,
10.021905,  48.350598  /* Gurrensee Home*/
};
#endif

#if 1 // T2010_03_25.kml zickzack nord sued
LONLAT wps[] = 
{      
10.01858932403474, 48.3492681149007,
10.0204287373173, 48.34749612962756,
10.01890777691184, 48.34984257813071,
10.02092273287666, 48.34755187341519,
10.01963717346614, 48.35008063070348,
10.02144042858133, 48.34766233043898,
10.02024863160596, 48.35041004471471,
10.02184247467033, 48.34798513506198,
10.02102220006753, 48.35033447318764,
10.021905,  48.350598  /* Gurrensee Home*/
};
#endif


#if 0 // T11_08.kml
LONLAT wps[] = 
{                
10.01828588875765, 48.34908109748631, 
10.01991661494723, 48.34754931668771,
10.02092201436531, 48.34742890319306,
10.01875271600669, 48.34920486394454, 
10.02028392612293, 48.34761556206701,
10.021905,  48.350598  /* Gurrensee Home*/
};
#endif

#if 0 // T10_9.kml
LONLAT wps[] = 
{                
10.01878599784611, 48.34914625898592, 
10.02030759560836, 48.34763868929347, 
10.02080610573088, 48.34746850749877, 
10.02126983972149, 48.34745142567727, 
10.0215876863066, 48.34752639058969, 
10.02181909042964, 48.34772911997013, 
10.02189787630972, 48.34803288776422, 
10.02195797882327, 48.34837149044561, 
10.02195939390856, 48.34871516358439, 
10.02196029489443, 48.34904614484464, 
10.0219416443464, 48.34934714305871, 
10.02182915108475, 48.34993926040147, 
10.02165532040892, 48.35017950196706, 
10.01902256994808, 48.34921761629291, 
10.02040031146757, 48.34778408141367, 
10.02081269297727, 48.34762664857499, 
10.02124984916224, 48.34760133595911, 
10.02164685596985, 48.34779519190754, 
10.02172582079199, 48.34805488641231, 
10.0217595022215, 48.34837590028225, 
10.02175427676439, 48.34870651662558, 
10.0217224369766, 48.34905139195352, 
10.02167679261813, 48.34931726191038, 
10.02154329962563, 48.34994330219298, 
10.02043345634753, 48.34953421919506, 
10.01940409523274, 48.34914443862765, 
10.02056657029008, 48.34789460355453, 
10.0208259778341, 48.34777604055103, 
10.02126998307504, 48.34775817493535, 
10.02153838907331, 48.34800013413778, 
10.02153500574493, 48.34838036917549, 
10.02154910330283, 48.34869351567791, 
10.02149051129392, 48.34902992618508, 
10.02140494190671, 48.34928324234425, 
10.02135168283, 48.34948673673797, 
10.02129638146661, 48.34968323683175, 
10.01977482882391, 48.34913995428855, 
10.0206528672476, 48.34802699370576, 
10.02085444371678, 48.34791557122745, 
10.02124765236654, 48.34793108098847, 
10.02139807519249, 48.3481038669976, 
10.02136988520337, 48.34838485957225, 
10.02133756048778, 48.3487074050681, 
10.02128491557605, 48.34897765422848,
10.02117875057436, 48.34925715642867,
10.02112166290659, 48.34944227943786, 
10.02010234489425, 48.3490767563444, 
10.02083170961855, 48.34807019135362,
10.02111363883894, 48.34805404627905, 
10.02128453735848, 48.34817396154638, 
10.0211317334075, 48.34880491393038, 
10.02106557078075, 48.34900945490115, 
10.02099897265961, 48.34919995745587, 
10.02041223929194, 48.34901905204995, 
10.0209239764807, 48.34817381887163, 
10.02115758716876, 48.34822381243518, 
10.02089742686639, 48.34901304110738, 
10.02064452971192, 48.34894639097525, 
10.02097277505724, 48.34829566180776, 
10.021905,  48.350598  /* Gurrensee Home*/
};
#endif

#if 0
LONLAT wps[] = 
{                
10.01919172174253,48.34873791854873,
10.01940161134515,48.34854627713872,
10.02149762426506,48.34999935382113,
10.02178600354267,48.34980817315577,
10.01974308041223,48.34833380538601,
10.02004317515047,48.34811452646275,
10.02196111525295,48.34949193040838,
10.02151836305288,48.34979508348037,
10.01948346356353,48.34838930350296,
10.01980402656699,48.34814624754722,
10.02169991531253,48.34950542686911,
10.02199726018609,48.34927905316707,
10.02001155133383,48.3478762097841,
10.021905,  48.350598  /* Gurrensee Home*/
};

#endif

//PID gains
#ifdef CATAMARAN
  #define KP_HEADING 2.5
  #define KI_HEADING 0.03
  #define KD_HEADING 0.1
  #define MOTOR_SPEED 90
  #define WP_TIMEOUT 25 // Timeout counter value in seconds
#endif

#ifdef GLIDER
  #define KP_HEADING 1.0
  #define KI_HEADING 0.03
  #define KD_HEADING 0.1
  #define MOTOR_SPEED 60
  #define WP_TIMEOUT 25 // Timeout counter value in seconds
#endif

#ifdef LONGKEEL
  #define KP_HEADING 0.6
  #define KI_HEADING 0.05
  #define KD_HEADING 0.1
  #define MOTOR_SPEED 80
  #define WP_TIMEOUT 25 // Timeout counter value in seconds
#endif


// Defining HMs add-on variables and consts
#define BLUE_LED   12
#define YELLOW_LED 13
#define WP_RADIUS 10  // Radius for waypoint-hit in m


unsigned int integrator_reset_counter = 0;

byte current_wp = 0; //This variable stores the actual waypoint we are trying to reach.. 
byte jumplock_wp = 0; //When switching waypoints this lock will allow only one transition..

int wp_bearing = 0; //Stores the bearing from the current waypoint
unsigned int wp_distance = 0; //Stores the distances from the current waypoint
/*******************************/
//PID loop variables
int heading_previous_error; 
float heading_I = 0.0;             //Stores the result of the integrator

// PID Debug Variables
float pid_p;
float pid_i;
float pid_d;
float pid_dt;
int dbg_pid_error;

/*******************************/
char buffer[90]; //Serial buffer to catch GPS data
/*GPS Pointers*/
char *token;
char *search = ",";
char *brkb, *pEnd;

//GPS obtained information
byte fix_position = 0;//Valid gps position
float lat = 0; //Current Latitude
float lon = 0; //Current Longitude
unsigned long time;
float ground_speed = 0; //Ground speed? yes Ground Speed.
int  course = 0; // Course over ground...
int alt = 0; //Altitude 

//ACME variables
byte gps_new_data_flag = 0; // A simple flag to know when we've got new gps data.

#define MIDDLE_YAW 90  // central position of yaw servo


// Yaw setpoint variable, holds the calculated value for the yaw servo
int yaw_setpoint=0;


void setup()
{
  init_ardupilot();
  waypoints = sizeof(wps) / sizeof(LONLAT);

  //ram_info();
 
  Init_servo();//Initalizing servo, see "Servo_Control" tab. 
  
  test_yaw(); // Just move the servo to see, that there is something living

  delay(2000); // wait until datalogger ist ready
  print_header();
  delay(500); 
  
  init_startup_parameters(); // Wait for first GPS Fix
  test_yaw(); 
  bldc_arm_throttle();   // Start the BLDC controller
  bldc_start_throttle(); // start the motor 
  delay (5000);
  init_startup_parameters(); // re-synchronize GPS
 
}

// Program main loop starts here

void loop()
{
  gps_parse_nmea(); // parse incoming NMEA Messages from GPS Module and store relevant data in global variables
 
  if((gps_new_data_flag & 0x01) == 0x01)    //Checking new GPS "GPRMC" data flag in position 
  {
    digitalWrite(YELLOW_LED, HIGH); 
    gps_new_data_flag &= (~0x01); //Clearing new data flag... 
    yaw_control(); // Control function for steering the course to next waypoint 

   if (integrator_reset_counter++ < WP_TIMEOUT)    // Force I and D part to zero for WP_TIMEOUT seconds after waypoint switch
     reset_PIDs();
 
   send_to_ground();   /*Print values, just for debugging*/
  } // end if gps_new_data...


  /*************************************************************************/
  /* Ensure that the autopilot will jump ONLY ONE waypoint */
  /*************************************************************************/
    if((wp_distance < WP_RADIUS) && (jumplock_wp == 0x00)) //Checking if the waypoint distance is less than WP_RADIUS m, and check if the lock is open
    {
      current_wp++; //Switch the waypoint
      jumplock_wp = 0x01; //Lock the waypoint switcher.
      integrator_reset_counter = 0;
     
      if(current_wp >= waypoints)    // Check if we've passed all the waypoints, if yes stop motor
       finish_mission();          
     } // end if wp_distance...
 
  digitalWrite(YELLOW_LED,LOW);  //Turning off the status LED
} // end loop ()



void send_to_ground(void)
{
     
    Serial.print(course);
    Serial.print("\t");
       
    Serial.print((int)wp_bearing);   
    Serial.print("\t");
    
    Serial.print(dbg_pid_error);   
    Serial.print("\t");     
     
    Serial.print(wp_distance);   
    Serial.print("\t");    
    
    Serial.print(time);
    Serial.print("\t");
  
    Serial.print((int)yaw_setpoint);      
    Serial.print("\t");
    
    Serial.print((int)current_wp);
    Serial.print("\t");

    Serial.print((int)pid_p);
    Serial.print("\t");

    Serial.print((int)pid_i);
    Serial.print("\t");

    Serial.print((int)pid_d);
    Serial.print("\t");

    ground_speed *= 18.0; // Scale miles/h to km/h * 10
    Serial.print((int)ground_speed);
    Serial.print("\t");

    Serial.print(alt);

    Serial.println();  
          
}

void  print_header(void)
{  
  Serial.println("KP_HEADING\t\t KI_HEADING\t\t KD_HEADING\t\t INTEGRATOR_MAX\t\t RAM"); 
  delay(50);
  Serial.print ((int)(KP_HEADING * 100));  
  Serial.print("\t\t"); 
  Serial.print ((int)(KI_HEADING * 100));
  Serial.print("\t\t");  
  Serial.print ((int)(KD_HEADING * 100)); 
  Serial.print("\t\t"); 
  Serial.print ((int)(INTEGRATOR_MAX)); 
  Serial.print("\t\t"); 
  Serial.println( ram_info() );
  delay(50);
  Serial.println("Ist\t Soll\t err\t Dist\t Time\t Rudd\t WP\t pid_p\t pid_i\t pid_d\t speed\t alt");  
  delay (50);
}

/***************************************************************************/
//Computes heading the error, and choose the shortest way to reach the desired heading
/***************************************************************************/
int compass_error(int PID_set_Point, int PID_current_Point)
{
   float PID_error=0;//Temporary variable
   
    if(fabs(PID_set_Point-PID_current_Point) > 180) 
	{
		if(PID_set_Point-PID_current_Point < -180)
		{
		  PID_error=(PID_set_Point+360)-PID_current_Point;
		}
		else
		{
		  PID_error=(PID_set_Point-360)-PID_current_Point;
		}
	}
	else
	{
          PID_error=PID_set_Point-PID_current_Point;
        }

	return PID_error;
}


int ram_info() 
{
  uint8_t *heapptr;
  uint8_t *stackptr;

  stackptr = (uint8_t *)malloc(4);   // use stackptr temporarily
  heapptr = stackptr;		    // save value of heap pointer
  free(stackptr);		  // free up the memory again (sets stackptr to 0)
  stackptr =  (uint8_t *)(SP);	 // save value of stack pointer

 // Serial.print("HP: ");
 // Serial.println((int) heapptr, HEX);
 // Serial.print("SP: ");
 // Serial.println((int) stackptr, HEX);
 // Serial.print("Free: ");
 // Serial.println((int) stackptr - (int) heapptr, HEX);
 //  Serial.println("");
  return ((int) stackptr - (int) heapptr);
 
}
 
// This function stops all activity and will never return
// This is the end...
void finish_mission(void) 
{
  bldc_stop_throttle();
  while (1)     // loop forever, if timeout reached (and start to swim and recover the boat)
  {
    digitalWrite(YELLOW_LED,LOW); // Fast flashing Yellow LED to indicate arrival
    delay(100);
    digitalWrite(YELLOW_LED,HIGH);
    delay(100);
   }          
}


/*************************************************************************
 * Yaw Control, reads gps info, calculates navigation, executes PID and sends values to the servo.. 
 *************************************************************************/
void yaw_control(void)
{

  wp_bearing=get_gps_course(lat, lon, wps[current_wp].lat, wps[current_wp].lon);//Calculating Bearing, this function is located in the GPS_Navigation tab.. 
 
  wp_distance = get_gps_dist(lat, lon, wps[current_wp].lat, wps[current_wp].lon); //Calculating Distance, this function is located in the GPS_Navigation tab.. 

  yaw_setpoint = MIDDLE_YAW+PID_heading(compass_error(wp_bearing, course)); //Central Position + PID(compass_error(desired course, current course)). 


   pulse_servo_yaw((long)yaw_setpoint);  //Sending values to servo, 90 degrees is central position. 

  }

void steer_course (int fixcourse)
{
   //test autopilot 
   
   yaw_setpoint=MIDDLE_YAW+PID_heading(compass_error(fixcourse, course));  // Special mode to just fly a fixed course 
   pulse_servo_yaw(yaw_setpoint);  //Sending values to servo, 90 degrees is central position. 
}

/*************************************************************************
 * This functions parses the NMEA strings... 
 * Pretty complex but never fails and works well with all GPS modules and baud speeds.. :-) 
 * Just change the Serial.begin() value in the first tab for higher baud speeds
 *************************************************************************/

void gps_parse_nmea(void)
{
  const char head_rmc[]="GPRMC"; //GPS NMEA header to look for
  const char head_gga[]="GPGGA"; //GPS NMEA header to look for

  static byte unlock=1; //some kind of event flag
  static byte checksum=0; //the checksum generated
  static byte checksum_received=0; //Checksum received
  static byte counter=0; //general counter

  //Temporary variables for some tasks, specially used in the GPS parsing part 
  unsigned long temp=0;
  unsigned long temp2=0;
  unsigned long temp3=0;


  while(Serial.available() > 0)
  {
    if(unlock==0)
    {
      buffer[0]=Serial.read();//puts a byte in the buffer

      if(buffer[0]=='$')//Verify if is the preamble $
      {
        unlock=1; 
      }
    }
    /*************************************************/
    else
    {
      buffer[counter]=Serial.read();


      if(buffer[counter]==0x0A)//Looks for \F
      {

        unlock=0;


        if (strncmp (buffer, head_rmc, 5) == 0)   // $GPRMC parsing starts here
        {

          /*Generating and parsing received checksum, */
          for(int x=0; x<100; x++)
          {
            if(buffer[x]=='*')
            { 
              checksum_received=strtol(&buffer[x+1],NULL,16);//Parsing received checksum...
              break; 
            }
            else
            {
              checksum ^= buffer[x]; //XOR the received data... 
            }
          }

          if(checksum_received == checksum)//Checking checksum
          {
            /* Token will point to the data between comma "'", returns the data in the order received */
            /*THE GPRMC order is: UTC, UTC status ,Lat, N/S indicator, Lon, E/W indicator, speed, course, date, mode, checksum*/
            token = strtok_r(buffer, search, &brkb); //Contains the header GPRMC, not used

            token = strtok_r(NULL, search, &brkb); //UTC Time, not used
            time = atol (token);
            token = strtok_r(NULL, search, &brkb); //Valid UTC data? maybe not used... 

            
            //Longitude in degrees, decimal minutes. (ej. 4750.1234 degrees decimal minutes = 47.835390 decimal degrees)
            //Where 47 are degrees and 50 the minutes and .1234 the decimals of the minutes.
            //To convert to decimal degrees, divide the minutes by 60 (including decimals), 
            //Example: "50.1234/60=.835390", then add the degrees, ex: "47+.835390=47.835390" decimal degrees
            token = strtok_r(NULL, search, &brkb); //Contains Latitude in degrees decimal minutes... 
 
            // Serial.println(token);
  
            //taking only degrees, and minutes without decimals, 
            //strtol stop parsing till reach the decimal point "."  result example 4750, eliminates .1234
            temp = strtol (token, &pEnd, 10);

            //takes only the decimals of the minutes
            //result example 1234. 
            temp2 = strtol (pEnd + 1, NULL, 10);

            //joining degrees, minutes, and the decimals of minute, now without the point...
            //Before was 4750.1234, now the result example is 47501234...
            temp3 = (temp * 10000) + (temp2);


            //modulo to leave only the decimal minutes, eliminating only the degrees.. 
            //Before was 47501234, the result example is 501234.
            temp3 = temp3 % 1000000;


            //Dividing to obtain only the degrees, before was 4750 
            //The result example is 47 (4750/100=47)
            temp /= 100;

            //Joining everything and converting to float variable... 
            //First i convert the decimal minutes to degrees decimals stored in "temp3", example: 501234/600000= .835390
            //Then i add the degrees stored in "temp" and add the result from the first step, example 47+.835390=47.835390 
            //The result is stored in "lat" variable... 
            lat=temp + ( (float)temp3 / 600000 );


            token = strtok_r(NULL, search, &brkb); //lat, north or south?
            //If the char is equal to S (south), multiply the result by -1.. 
            if(*token == 'S')
            {
              lat = lat * -1;
            }

            //This the same procedure use in lat, but now for Lon....
            token = strtok_r(NULL, search, &brkb);
 
            // Serial.println(token);
 
            temp = strtol (token, &pEnd, 10); 
            temp2 = strtol (pEnd + 1, NULL, 10); 
            temp3 = (temp * 10000) + (temp2);
            temp3 = temp3 % 1000000; 
            temp /= 100;
            lon=temp + ((float)temp3 / 600000);

            token = strtok_r(NULL, search, &brkb); //lon, east or west?
            if(*token == 'W')
            {
              lon=lon * -1;
            }

            token = strtok_r(NULL, search, &brkb); //Speed overground?
            ground_speed = atof(token);

            token = strtok_r(NULL, search, &brkb); //Course?
            course= atoi(token);

            gps_new_data_flag |= 0x01; //Update the flag to indicate the new data has arrived. 

            jumplock_wp=0x00;//clearing waypoint lock..

          }
          checksum=0;
        } //End of the GPRMC parsing

        if (strncmp (buffer,head_gga,5) == 0)  // $GPGGA parsing starts here
        {
          /*Generating and parsing received checksum, */
          for(int x=0; x<100; x++)
          {
            if(buffer[x] == '*')
            { 
              checksum_received = strtol(&buffer[x+1], NULL, 16);//Parsing received checksum...
              break; 
            }
            else
            {
              checksum ^= buffer[x]; //XOR the received data... 
            }
          }

          if(checksum_received == checksum)//Checking checksum
          {
            token = strtok_r(buffer, search, &brkb);//GPGGA header, not used anymore
            token = strtok_r(NULL, search, &brkb);//UTC, not used!!
            token = strtok_r(NULL, search, &brkb);//lat, not used!!
            token = strtok_r(NULL, search, &brkb);//north/south, nope...
            token = strtok_r(NULL, search, &brkb);//lon, not used!!
            token = strtok_r(NULL, search, &brkb);//wets/east, nope
            token = strtok_r(NULL, search, &brkb);//Position fix, used!!
            fix_position = atoi(token); 
            token = strtok_r(NULL, search, &brkb); //sats in use!! Nein...
            token = strtok_r(NULL, search, &brkb);//HDOP, not needed
            token = strtok_r(NULL, search, &brkb);//ALTITUDE, is the only meaning of this string.. in meters of course. 
            alt = atoi(token);
            if(alt < 0)
            {
              alt = 0;
            }

            if(fix_position >= 0x01) 
              digitalWrite(BLUE_LED,HIGH); //Status LED...
            else 
             digitalWrite(BLUE_LED,LOW);

            gps_new_data_flag |= 0x02; //Update the flag to indicate the new data has arrived.
          }
          checksum=0; //Restarting the checksum
        } // end of $GPGGA parsing

        for(int a=0; a<=counter; a++)//restarting the buffer
        {
          buffer[a]=0;
        } 
        counter=0; //Restarting the counter
      }
      else
      {
        counter++; //Incrementing counter
      }
    }
  } 

}
/*************************************************************************
 * //Function to calculate the course between two waypoints
 * //I'm using the real formulas--no lookup table fakes!
 *************************************************************************/
int get_gps_course(float flat1, float flon1, float flat2, float flon2)
{
  float calc;
  float bear_calc;

  float x = 69.1 * (flat2 - flat1); 
  float y = 69.1 * (flon2 - flon1) * cos(flat1/57.3);

  calc=atan2(y,x);

  bear_calc= degrees(calc);

  if(bear_calc<=1){
    bear_calc=360+bear_calc; 
  }
  return bear_calc;
}


/*************************************************************************
 * //Function to calculate the distance between two waypoints
 * //I'm using the real formulas
 *************************************************************************/
unsigned int get_gps_dist(float flat1, float flon1, float flat2, float flon2)
{

    float x = 69.1 * (flat2 - flat1); 
    float y = 69.1 * (flon2 - flon1) * cos(flat1/57.3);

    return (float)sqrt((float)(x*x) + (float)(y*y))*1609.344; 
}


// This function tries to switch the EM406 into 9600 Baud
void gps_init_baudrate(void)
{   
    Serial.begin(4800); // Allways try in 4800 Baud first. 
    delay(100);
    Serial.println("$PSRF100,1,9600,8,1,0*0D"); //  command to switch SIRFIII to NMEA, 9600, 8, N, 1 
    delay(100);
    Serial.begin(9600);  // switch finally back to 9600 Baud 
}



void init_ardupilot(void)
{
  gps_init_baudrate();
  Serial.begin(9600); 
//  Serial.println("ArduPilot!!!"); 
  //Declaring pins
  pinMode(2,INPUT);//Servo input; 
  pinMode(3,INPUT);//Servo Input; 
  pinMode(4,INPUT); //MUX pin
  // This next line is a Mode pin, which only works in with three-position toggle switches on your transmitter. 
  // If you want to use it for some special mode, you must change the Attiny code. It is not currently active.
  // When you put the switch in the central position the attiny will set high a pin called "mode", 
  // and you can use it to do whatever yowant... 
  pinMode(5,INPUT); // Mode pin (see above)
  pinMode(11,OUTPUT); // Simulator Output pin
  pinMode(BLUE_LED,OUTPUT); // LOCK LED pin in ardupilot board, indicates valid GPS data
  pinMode(YELLOW_LED,OUTPUT);// STATS LED pin in ardupilot board, blinks to indicate the board is working well...  
}

void init_startup_parameters(void)
{
  //yeah a do-while loop, checks over and over again until we have valid GPS position and lat is diferent from zero. 
  //I re-verify the Lat because sometimes fails and sets home lat as zero. This way never goes wrong.. 
  do
  {
    gps_parse_nmea(); //Reading and parsing GPS data
  }
  while(((fix_position < 0x01) || (lat == 0)));

  //Another verification
  gps_new_data_flag=0;

  do
  {
    gps_parse_nmea(); //Reading and parsing GPS data  
  }
  while((gps_new_data_flag&0x01 != 0x01) & (gps_new_data_flag&0x02 != 0x02)); 
  yaw_control(); //I've put this here because i need to calculate the distance to the next waypoint, otherwise it will start at waypoint 2.


}

/****************************************************************************************
 * PID= P+I+D This function only works, when GPS with one second update is used.
 ***************************************************************/
int PID_heading(int PID_error)
{ 
  static float heading_D; //Stores the result of the derivator
  static float heading_output; //Stores the result of the PID loop

  dbg_pid_error = PID_error; // deBug

#if 0
  if (fabs(PID_error) > 120)         // de-activate Integrator, when error is too high (on the turn)
    reset_PIDs();
#endif

  heading_I += (float)PID_error; 
  
  heading_I = constrain(heading_I, INTEGRATOR_MIN, INTEGRATOR_MAX); //Limit the PID integrator... 

  //Derivation part
  heading_D = ((float)PID_error - (float)heading_previous_error);

  heading_output = 0.0;//Clearing the variable.	

  heading_output =  (KP_HEADING * (float)PID_error);  //Proportional part, is just the KP constant * error.. and adding to the output 
  pid_p =  (KP_HEADING * (float)PID_error);  
  
  heading_output += (KI_HEADING * heading_I);  //Adding integrator result...
  pid_i = (KI_HEADING * heading_I); 
  
  heading_output += (KD_HEADING * heading_D);// /Adding derivator result.... 
  pid_d = (KD_HEADING * heading_D);


  //Adds all the PID results and limit the output... 
  heading_output = constrain(heading_output, (float)heading_min, (float)heading_max);//limiting the output.... 

  heading_previous_error = PID_error;//Saving the actual error to use it later (in derivating part)...
 

  //Now checking if the user have selected normal or reverse mode (servo)... 
  if(reverse_yaw == 1)
  {
    return (int)(-1 * heading_output); 
  }
  else
  {
    return (int)(heading_output);
  }
}

/*************************************************************************
 * Reset all the PIDs
 *************************************************************************/
void reset_PIDs(void)
{
  heading_previous_error = 0.0;
  heading_I = 0.0; 
}


/**************************************************************
 * Configuring the PWM hadware... If you want to understand this you must read the Data Sheet of atmega168..  
 ***************************************************************/
void Init_servo(void)//This part will configure the PWM to control the servo 100% by hardware, and not waste CPU time.. 
{   
  digitalWrite(10,LOW);//Defining servo output pins
  pinMode(10,OUTPUT);
  digitalWrite(9,LOW);
  pinMode(9,OUTPUT);
  /*Timer 1 settings for fast PWM*/
  //Note: these strange strings that follow, like OCRI1A, are actually predefined Atmega168 registers. We load the registers and the ch
  // p does the rest.

    //Remember the registers not declared here remains zero by default... 
  TCCR1A =((1<<WGM11)|(1<<COM1B1)|(1<<COM1A1)); //Please read page 131 of DataSheet, we are changing the registers settings of WGM11,COM1B1,COM1A1 to 1 thats all... 
  TCCR1B = (1<<WGM13)|(1<<WGM12)|(1<<CS11); //Prescaler set to 8, that give us a resolution of 2us, read page 134 of data sheet
  OCR1A = 2500; //the period of servo 1, remember 2us resolution, 2500/2 = 1250us the pulse period of the servo...    
  OCR1B = 3000; //the period of servo 2, 3000/2=1500 us, more or less is the central position... 
  ICR1 = 40000; //50hz freq...Datasheet says  (system_freq/prescaler)/target frequency. So (16000000hz/8)/50hz=40000, 
  //must be 50hz because is the servo standard (every 20 ms, and 1hz = 1sec) 1000ms/20ms=50hz, elementary school stuff... 
}
/**************************************************************
 * Function to pulse the throttle servo
 ***************************************************************/
void pulse_servo_throttle(long angle)//Will convert the angle to the equivalent servo position... 
{
  //angle=constrain(angle,180,0);
  OCR1A=((angle*(max16_throttle-min16_throttle))/180L+min16_throttle)*2L;
}

/**************************************************************
 * Function to pulse the yaw/rudder servo... 
 ***************************************************************/
void pulse_servo_yaw(long angle)//Will convert the angle to the equivalent servo position... 
{
  OCR1B=((angle*(max16_yaw-min16_yaw))/180L+min16_yaw)*2L; //Scaling
}

// Function to "arm" the throttle BLDC controller (Multiplex type). 
void bldc_arm_throttle(void)
{
  pulse_servo_throttle(90);  // Middle position, Servo controller idle
  delay(500);
  pulse_servo_throttle(5);   // then switch to approx. zero, Servo controller armed
  delay(500);
}

void bldc_start_throttle(void)  // brushless Motor (Multiplex controller)
{
  pulse_servo_throttle(MOTOR_SPEED); // set Motor speed
}

// function to stop the Motor   // brushless Motor (Multiplex controller)
void bldc_stop_throttle(void)
{
  pulse_servo_throttle(5);  // switch to approx. zero
}



void test_yaw(void)
{
  pulse_servo_yaw(90+heading_min);
  digitalWrite(YELLOW_LED, HIGH);
  delay(1500);
  pulse_servo_yaw(90+heading_max);
  digitalWrite(YELLOW_LED, LOW);
  delay(1500);
  digitalWrite(YELLOW_LED, HIGH);
  pulse_servo_yaw(90);
  delay(1500);
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

