
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
