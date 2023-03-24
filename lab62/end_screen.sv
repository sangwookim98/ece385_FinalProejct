module end_screen ( input 		  Reset, frame_clk,
						  
					
               output [9:0]  msgX, msgY, msgS, msgSY);
    
    logic [9:0] msg_X_Pos, msg_Y_Pos, msg_Size, msg_SizeY;

	 
	 
	 
	 // for the player sprite
    parameter [9:0] msg_X_Center=320;  // Center position on the X axis
    parameter [9:0] msg_Y_Center=240;  // Center position on the Y axis

	 
	 
	 // for the key, setup



    assign msg_Size = 21;  // x length
    assign msg_SizeY = 45; // y length
	 
	
	 
	 // Sprite movement with keycode
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
		  begin 
          
				msg_Y_Pos <= msg_Y_Center;
				msg_X_Pos <= msg_X_Center;

			end
	end


       
    assign msgX  = msg_X_Pos;  
    assign msgY  = msg_Y_Pos;
    assign msgS  = msg_Size;
	 assign msgSY = msg_SizeY;
	 

	
endmodule
