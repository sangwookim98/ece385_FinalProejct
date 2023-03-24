module camera_control (input logic Reset, Clk,
							  input [9:0] camX, camS,
							  output [1:0] direction_cam
);

logic flag;

logic[1:0] cam_direction;

reg[31:0] count;

	 // for the cam (test)
	 parameter [9:0] cam_X_Center=40;  // Center position on the X axis
    parameter [9:0] cam_Y_Center=10;  // Center position on the Y axis
    parameter [9:0] cam_X_Min=10;       // Leftmost point on the X axis
    parameter [9:0] cam_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] cam_Y_Min=30;       // Topmost point on the Y axis
    parameter [9:0] cam_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] cam_X_Step=1;      // Step size on the X axis
    parameter [9:0] cam_Y_Step=1;      // Step size on the Y axis


	 

// direction:
//00 : left
//01 : right
//10 : stop

//	 assign direction_cam = 2'b10;
	 
	 always_ff @ (posedge Reset or posedge Clk )
    begin: initialize_cam
        if (Reset)  // Asynchronous Reset
				cam_direction = 2'b00;	  
		  else
		  
		  // cam boundaries
		  begin
				// left motion of the cam          
					if ( (camX - camS) <= cam_X_Min )
						// cam is at the Left edge, stop motion
						cam_direction = 2'b01;
						
//					else
//						cam_direction = 2'b00;
					
				
					// right motion
					else if ( (camX + camS) >= cam_X_Max )
						cam_direction = 2'b00;
					  
//					else
//						cam_direction = 2'b01;
					

					
		  end 	// for else (furthest)
   end 			// end for always_ff
	 
	 assign direction_cam = cam_direction;

	
endmodule
