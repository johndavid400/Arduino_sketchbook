void init_ardupilot(void)
{
  gps_init_baudrate();
  Serial.begin(9600); 

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
