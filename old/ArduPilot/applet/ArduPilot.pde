/*By Chris Anderson & Jordi Munoz*/
/*ArduPilot Beta 2*/
/*Feb/18/2009*/
/*Released under an Apache 2.0 open source license*/
/*Project home page is at DIYdrones.com (and ArduPilot.com)
/*We hope you improve the code and share it with us at DIY Drones!*/

// gute Werte für Einkiel-Rumpf: kp = 0.6, ki=0.05, kd= 0.1, Speed = 80 
// gute Werte für Katamaran-Rumpf: kp = 2.5, ki=0.03, kd= 0.1, Speed = 80 

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
