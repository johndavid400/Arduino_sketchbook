
// Debugging output, sends the value of internal variables to the datalogger every second
// Floating point values are multiplied and converted to integers to get it through the Serial.print function
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
// Debugging output, sends the value of internal variables to the datalogger once on startup
// Floating point values are multiplied and converted to integers to get it through the Serial.print function
void  print_header(void)
{  
 // Header for the System constants
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
  
  // header for the debugging variables 
  Serial.println("Act\t Setp\t err\t Dist\t Time\t Rudd\t WP\t pid_p\t pid_i\t pid_d\t speed\t alt");  
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

// function to calculate the remaining amount of RAM in Bytes
// Check always, if you have changed the Waypoint array (see the Header of the debug-output)

int ram_info() 
{
  uint8_t *heapptr;
  uint8_t *stackptr;

  stackptr = (uint8_t *)malloc(4);   // use stackptr temporarily
  heapptr = stackptr;		    // save value of heap pointer
  free(stackptr);		  // free up the memory again (sets stackptr to 0)
  stackptr =  (uint8_t *)(SP);	 // save value of stack pointer

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
