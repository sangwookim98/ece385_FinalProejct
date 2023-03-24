module  sprite_movement ( input Reset, frame_clk,
					input [7:0] keycode,
               output [9:0]  SpriteX, SpriteY, SpriteS );
    
    logic [9:0] Sprite_X_Pos, Sprite_X_Motion, Sprite_Y_Pos, Sprite_Y_Motion, Sprite_Size;
	 
    parameter [9:0] Sprite_X_Center=320;  // Center position on the X axis
    parameter [9:0] Sprite_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Sprite_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Sprite_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Sprite_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Sprite_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Sprite_X_Step=20;      // Step size on the X axis
    parameter [9:0] Sprite_Y_Step=20;      // Step size on the Y axis
	 
	 

    assign Sprite_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Sprite
        if (Reset)  // Asynchronous Reset
		  begin 
            Sprite_Y_Motion <= 10'd0; //Sprite_Y_Step;
				Sprite_X_Motion <= 10'd0; //Sprite_X_Step;
				Sprite_Y_Pos <= Sprite_Y_Center;
				Sprite_X_Pos <= Sprite_X_Center;
        end
          // Accomodate for spazzing near border
			 // Finished border + movement of Sprite (12th Nov)
			 
			 
//        else 
//        begin 
//				 if ( (Sprite_Y_Pos + Sprite_Size) >= Sprite_Y_Max ) 
//				 begin  // Sprite is at the bottom edge, BOUNCE!
////					  Sprite_Y_Motion <= (~ (Sprite_Y_Step) + 1'b1);  // 2's complement.
//					  Sprite_Y_Motion<= 1'b0;
//					  Sprite_Y_Pos <= (Sprite_Y_Pos + Sprite_Y_Motion);
//				 end
//
//					  
//				 else if ( (Sprite_Y_Pos - Sprite_Size) <= Sprite_Y_Min )
//			    begin	 // Sprite is at the top edge, BOUNCE!
////					  Sprite_Y_Motion <= Sprite_Y_Step;
//					  Sprite_Y_Motion<= 1'b0;
//					  Sprite_Y_Pos <= (Sprite_Y_Pos + Sprite_Y_Motion);
//				 end
//				
//				 else if ( (Sprite_X_Pos + Sprite_Size) >= Sprite_X_Max )
//				 begin// Sprite is at the Right edge, BOUNCE!
////					  Sprite_X_Motion <= (~ (Sprite_X_Step) + 1'b1);  // 2's complement.
//					  Sprite_X_Motion <= 1'b0;  // 2's complement.
//					  Sprite_X_Pos <= (Sprite_X_Pos + Sprite_X_Motion);
//				 end
//
//					  
//				 else if ( (Sprite_X_Pos - Sprite_Size) <= Sprite_X_Min )
//					begin// Sprite is at the Left edge, BOUNCE!
////					  Sprite_X_Motion <= Sprite_X_Step;
//					  Sprite_X_Motion <= 1'b0;	
//					  Sprite_X_Pos <= (Sprite_X_Pos + Sprite_X_Motion);
//					 end
					  
		else		 
		begin
				  Sprite_Y_Pos <= Sprite_Y_Pos;  // Sprite is somewhere in the middle, don't bounce, just keep moving 
				  Sprite_X_Pos <= Sprite_X_Pos;  // Sprite is somewhere in the middle, don't bounce, just keep moving
					  
					case (keycode)
									 
					8'h04 : begin        // Left

				 			if ( (Sprite_X_Pos - Sprite_Size) <= Sprite_X_Min )
							begin// Sprite is at the Left edge
								Sprite_X_Motion <= Sprite_X_Step;
					  			Sprite_X_Motion <= 1'b0;	
					  			Sprite_X_Pos <= (Sprite_X_Pos - Sprite_X_Motion);
					 		end	
					
								else
								begin
									Sprite_X_Motion <= -1;//A
									Sprite_Y_Motion<= 0;
									Sprite_Y_Pos <= (Sprite_Y_Pos + Sprite_Y_Motion);
									Sprite_X_Pos <= (Sprite_X_Pos + Sprite_X_Motion);
								end
							  end
					        
					8'h07 : begin			// Right
							
							if ( (Sprite_X_Pos + Sprite_Size) >= Sprite_X_Max )
							begin// Sprite is at the Right edge
								Sprite_X_Motion <= 1'b0;  // 2's complement.
								Sprite_X_Pos <= (Sprite_X_Pos + Sprite_X_Motion);
				 			end  
							  
							  else
							  begin
								Sprite_X_Motion <= 1;//D
								Sprite_Y_Motion <= 0;
								Sprite_Y_Pos <= (Sprite_Y_Pos + Sprite_Y_Motion);
								Sprite_X_Pos <= (Sprite_X_Pos + Sprite_X_Motion);
							  end
							 end

							  
					8'h16 : begin			// Down

					       if ( (Sprite_Y_Pos + Sprite_Size) >= Sprite_Y_Max ) 
				 			 begin
//									Sprite is at the bottom edge
//									Sprite_Y_Motion <= (~ (Sprite_Y_Step) + 1'b1);  // 2's complement.
									Sprite_Y_Motion<= 1'b0;
									Sprite_Y_Pos <= (Sprite_Y_Pos + Sprite_Y_Motion);
							 end 
							 
							 else
								begin
								Sprite_Y_Motion <= 1;//S
								Sprite_X_Motion <= 0;
								Sprite_Y_Pos <= (Sprite_Y_Pos + Sprite_Y_Motion);
								Sprite_X_Pos <= (Sprite_X_Pos + Sprite_X_Motion);
					
							 end
						 end	  
					8'h1A : begin			// Up
					
							  if ( (Sprite_Y_Pos - Sprite_Size) <= Sprite_Y_Min ) 
				 			  begin
//									Sprite is at the top edge
//									Sprite_Y_Motion <= (~ (Sprite_Y_Step) + 1'b1);  // 2's complement.
									Sprite_Y_Motion<= 1'b0;
									Sprite_Y_Pos <= (Sprite_Y_Pos - Sprite_Y_Motion);
								end
							 else
								begin
								Sprite_Y_Motion <= -1;//W
								Sprite_X_Motion <= 0;
								Sprite_Y_Pos <= (Sprite_Y_Pos + Sprite_Y_Motion);
								Sprite_X_Pos <= (Sprite_X_Pos + Sprite_X_Motion);
								end 
							 end	  
					default: ;
			   endcase
					end 

				 

				 
//				 Sprite_Y_Pos <= (Sprite_Y_Pos + Sprite_Y_Motion);  // Update Sprite position
//				 Sprite_X_Pos <= (Sprite_X_Pos + Sprite_X_Motion);
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Sprite_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Sprite_Y_pos.  Will the new value of Sprite_Y_Motion be used,
          or the old?  How will this impact behavior of the Sprite during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
//    end
       
    assign SpriteX = Sprite_X_Pos;
   
    assign SpriteY = Sprite_Y_Pos;
   
    assign SpriteS = Sprite_Size;
    

endmodule
