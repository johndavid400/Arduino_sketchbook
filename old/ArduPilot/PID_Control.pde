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
  heading_output = constrain(heading_output, (float)HEADING_MIN, (float)HEADING_MAX);//limiting the output.... 

  heading_previous_error = PID_error;//Saving the actual error to use it later (in derivating part)...
 

  //Now checking if the user have selected normal or reverse mode (servo)... 
  if(REVERSE_YAW == 1)
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

