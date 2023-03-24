module  camera ( input 		  Reset, frame_clk,
					  input logic [1:0] direction_cam,
					  
					  output [9:0]  camX, camY, camS, camSY,
					  output [9:0]  vision_startX, vision_startY, vision_endX, vision_endY );
    
    logic [9:0] cam_X_Pos, cam_X_Motion, cam_Y_Pos, cam_Y_Motion, cam_size, cam_SizeY,
				    vision_x_start, vision_y_start, vision_x_end, vision_y_end;
					 
	 logic [9:0] curcamY, curcamX;
	 
	 
	 
	 // for the cam (test)
	 parameter [9:0] cam_X_Center=40;  // Center position on the X axis
    parameter [9:0] cam_Y_Center=10;  // Center position on the Y axis
    parameter [9:0] cam_X_Min=10;       // Leftmost point on the X axis
    parameter [9:0] cam_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] cam_Y_Min=30;       // Topmost point on the Y axis
    parameter [9:0] cam_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] cam_X_Step=1;      // Step size on the X axis
    parameter [9:0] cam_Y_Step=1;      // Step size on the Y axis
	 

	 assign cam_size = 21;
	 assign cam_SizeY = 45;
	 
	 // vision field adjustments
	 // Down nums
	 parameter[9:0]  vision_x_len = 50;
	 parameter[9:0]  vision_y_len = 175;
	 

	 
	 // only detecting once
	 // only applying reset limited times
	 
//	 assign direction_cam = 2'b10;
	 
	 always_ff @ (posedge Reset or posedge frame_clk )
    begin: initialize_cam
        if (Reset)  // Asynchronous Reset
		  begin 
            cam_Y_Motion <= 10'd0; 
				cam_X_Motion <= 10'd0; 
				cam_Y_Pos <= cam_Y_Center;
				cam_X_Pos <= cam_X_Center;	
        end
		  
		  else
		  // cam boundaries
		  begin
				case(direction_cam)
					// left motion of the cam
				   2'b00 : begin            
//					if ( (cam_X_Pos - cam_size) <= cam_X_Min )
//						begin// cam is at the Left edge, stop motion
//						cam_X_Motion <= 1'b0;	
//						cam_X_Pos <= (cam_X_Pos + cam_X_Motion);
//						end
//						
//					else
						begin
						cam_X_Motion <= -3;//A
						cam_Y_Motion<= 0;
						cam_Y_Pos <= (cam_Y_Pos + cam_Y_Motion);
						cam_X_Pos <= (cam_X_Pos + cam_X_Motion);
						
						vision_x_start  <= cam_X_Pos - vision_x_len;
						vision_x_end 	 <= cam_X_Pos + vision_x_len;
						
						vision_y_start  <= cam_Y_Pos;
						vision_y_end 	 <= vision_y_start + vision_y_len;
					 
						vision_startX 	 <= vision_x_start;
						vision_endX		 <= vision_x_end;
						vision_startY 	 <= vision_y_start;
						vision_endY		 <= vision_y_end;

						end
					end
				
					// right motion
					2'b01 : begin
//					if ( (cam_X_Pos + cam_size) >= cam_X_Max )
//						begin// Ball is at the Right edge
//						cam_X_Motion <= 1'b0;  // 2's complement.
//						cam_X_Pos <= (cam_X_Pos + cam_X_Motion);
//						end  
					  
//					else
						begin
						cam_X_Motion <= 3;//D
						cam_Y_Motion <= 0;
						cam_Y_Pos <= (cam_Y_Pos + cam_Y_Motion);
						cam_X_Pos <= (cam_X_Pos + cam_X_Motion);
						
						vision_x_start  <= cam_X_Pos - vision_x_len;
						vision_x_end 	 <= cam_X_Pos + vision_x_len;
						
						vision_y_start  <= cam_Y_Pos;
						vision_y_end 	 <= vision_y_start + vision_y_len;
					 
						vision_startX 	 <= vision_x_start;
						vision_endX		 <= vision_x_end;
						vision_startY 	 <= vision_y_start;
						vision_endY		 <= vision_y_end;
						
						end
					end

				
				2'b11:begin
				cam_Y_Motion <= 0;
				cam_X_Motion <= 0;
				cam_Y_Pos <= (cam_Y_Pos + cam_Y_Motion);
				cam_X_Pos <= (cam_X_Pos + cam_X_Motion);
				
				
				end
				
			default ;
		endcase

					
      end 	// end for line 49 begin
   end 			// end for always_ff
	 
	 assign camX = cam_X_Pos;
	 assign camY = cam_Y_Pos;
	 assign camS = cam_size;
	 assign camSY = cam_SizeY;
	

endmodule
