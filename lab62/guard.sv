module  guard ( input 		  Reset, frame_clk,
					 input logic [2:0] direction_guard,

					output [9:0]  GuardX, GuardY, GuardS, GuardSY,
					output [9:0]  vision_startX, vision_startY, vision_endX, vision_endY );
    
    logic [9:0] Guard_X_Pos, Guard_X_Motion, Guard_Y_Pos, Guard_Y_Motion, Guard_size, Guard_SizeY,
				    vision_x_start, vision_y_start, vision_x_end, vision_y_end;
					 
	 logic [9:0] curGuardY, curGuardX;
	 
	 
	 
	 // for the guard (test)
	 parameter [9:0] Guard_X_Center=120;  // Center position on the X axis
    parameter [9:0] Guard_Y_Center=300;  // Center position on the Y axis
    parameter [9:0] Guard_X_Min=10;       // Leftmost point on the X axis
    parameter [9:0] Guard_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Guard_Y_Min=30;       // Topmost point on the Y axis
    parameter [9:0] Guard_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Guard_X_Step=1;      // Step size on the X axis
    parameter [9:0] Guard_Y_Step=1;      // Step size on the Y axis
	 

	 assign Guard_size = 21;
	 assign Guard_SizeY = 45;
	 
	 // vision field adjustments
	 // Down nums
	 parameter[9:0]  vision_x_len = 50;
	 parameter[9:0]  vision_y_len = 175;
	 
	 
	 // Right nums
	 parameter[9:0]  vision_x_len_right = 100;            // length of vision
	 parameter[9:0]  vision_y_len_right = 25;					// width of vision
	 
	 // only detecting once
	 // only applying reset limited times
	 
//	 assign direction_guard = 2'b10;
	 
	 always_ff @ (posedge Reset or posedge frame_clk )
    begin: initialize_guard
        if (Reset)  // Asynchronous Reset
		  begin 
            Guard_Y_Motion <= 10'd0; 
				Guard_X_Motion <= 10'd0; 
				Guard_Y_Pos <= Guard_Y_Center;
				Guard_X_Pos <= Guard_X_Center;	
        end
		  
		  else
		  // Guard boundaries
		  begin
				case(direction_guard)
					// left motion of the guard
				   3'b000 : begin            
					if ( (Guard_X_Pos - Guard_size) <= Guard_X_Min )
						begin// Guard is at the Left edge, stop motion
						Guard_X_Motion <= 1'b0;	
						Guard_X_Pos <= (Guard_X_Pos + Guard_X_Motion);
						end
						
					else
						begin
						Guard_X_Motion <= -1;//A
						Guard_Y_Motion<= 0;
						Guard_Y_Pos <= (Guard_Y_Pos + Guard_Y_Motion);
						Guard_X_Pos <= (Guard_X_Pos + Guard_X_Motion);
						
						// left vision update for guard (WORKING CUZ YASH A G)
						// apply same logic for X if you want sprite placed near WALL
						
						vision_y_start <= Guard_Y_Pos - vision_y_len_right;
						vision_y_end 	<= Guard_Y_Pos + vision_y_len_right;
						
						vision_x_start <= Guard_X_Pos;
						vision_x_end 	<= Guard_X_Pos - vision_x_len_right;
						if ((Guard_X_Pos <= vision_x_len_right))
							vision_x_end <= Guard_X_Min;
							
						else
							vision_x_end 	<= Guard_X_Pos - vision_x_len_right;
						
						vision_startX 	<= vision_x_end;
						vision_endX		<= vision_x_start;
						vision_startY 	<= vision_y_start;
						vision_endY		<= vision_y_end;


						end
					end
				
					// right motion
					3'b001 : begin
					if ( (Guard_X_Pos + Guard_size) >= Guard_X_Max )
						begin// Ball is at the Right edge
						Guard_X_Motion <= 1'b0;  // 2's complement.
						Guard_X_Pos <= (Guard_X_Pos + Guard_X_Motion);
						end  
					  
					else
						begin
						Guard_X_Motion <= 1;//D
						Guard_Y_Motion <= 0;
						Guard_Y_Pos <= (Guard_Y_Pos + Guard_Y_Motion);
						Guard_X_Pos <= (Guard_X_Pos + Guard_X_Motion);
						
						// vision update for Guard Right (working)
						vision_y_start <= Guard_Y_Pos - vision_y_len_right;
						vision_y_end 	<= Guard_Y_Pos + vision_y_len_right;
						
				   	vision_x_start <= Guard_X_Pos;
					   vision_x_end 	<= Guard_X_Pos + vision_x_len_right;				

						vision_startX <= vision_x_start;
						vision_endX	  <= vision_x_end;
						vision_startY <= vision_y_start;
						vision_endY	  <= vision_y_end;


						
						end
					end
				
				// down motion <- working
				3'b010 : begin
				if ( (Guard_Y_Pos + Guard_SizeY) >= Guard_Y_Max ) 
					begin
					Guard_Y_Motion<= 1'b0;
					Guard_Y_Pos <= (Guard_Y_Pos + Guard_Y_Motion);
					end 
			 
				else
					begin
					Guard_Y_Motion <= 1;//S
					Guard_X_Motion <= 0;
					Guard_Y_Pos <= (Guard_Y_Pos + Guard_Y_Motion);
					Guard_X_Pos <= (Guard_X_Pos + Guard_X_Motion);
					
					// Guard down vision update
					vision_x_start  <= Guard_X_Pos - vision_x_len;
					vision_x_end 	 <= Guard_X_Pos + vision_x_len;
					
					vision_y_start  <= Guard_Y_Pos;
					vision_y_end 	 <= vision_y_start + vision_y_len;
				 
					vision_startX 	 <= vision_x_start;
					vision_endX		 <= vision_x_end;
					vision_startY 	 <= vision_y_start;
					vision_endY		 <= vision_y_end;
	 
					end
				end
				
				// up motion
				3'b011: begin
				if ( (Guard_Y_Pos - Guard_SizeY) <= Guard_Y_Min ) 
					begin
					Guard_Y_Motion<= 1'b0;
					Guard_Y_Pos <= (Guard_Y_Pos - Guard_Y_Motion);
					end
				
				else
					begin
					Guard_Y_Motion <= -1;//W
					Guard_X_Motion <= 0;
					Guard_Y_Pos <= (Guard_Y_Pos + Guard_Y_Motion);
					Guard_X_Pos <= (Guard_X_Pos + Guard_X_Motion);
					
					// Guard up vision update (kinda working)
					vision_x_start  <= Guard_X_Pos - vision_x_len;
	 				vision_x_end 	 <= Guard_X_Pos + vision_x_len;
					
					vision_y_start  <= Guard_Y_Pos;
					if (Guard_Y_Pos <= vision_y_len)
						vision_y_end <= Guard_Y_Min;
					
					else	
						vision_y_end 	 <= vision_y_start - vision_y_len;

					vision_startX 	 <= vision_x_start;
					vision_endX		 <= vision_x_end;
					vision_startY 	 <= vision_y_end;
	 				vision_endY	  	 <= vision_y_start;

					end
				end
				
				3'b100:begin
				Guard_Y_Motion <= 0;
				Guard_X_Motion <= 0;
				Guard_Y_Pos <= (Guard_Y_Pos + Guard_Y_Motion);
				Guard_X_Pos <= (Guard_X_Pos + Guard_X_Motion);
				end
				
			default ;
		endcase

					
      end 	// end for line 49 begin
   end 			// end for always_ff
	 
	 assign GuardX = Guard_X_Pos;
	 assign GuardY = Guard_Y_Pos;
	 assign GuardS = Guard_size;
	 assign GuardSY = Guard_SizeY;
	

endmodule
