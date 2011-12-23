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


