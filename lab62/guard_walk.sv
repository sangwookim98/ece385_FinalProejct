module guard_walk ( input logic Reset, vga_clk,
						  input [9:0] DrawX, DrawY, 
						  input [9:0] GuardX, GuardY,
						  
						  input [2:0] direction_guard,
						  
						  // another stage: make another variable
				
						  output logic [3:0] g_redleft, g_redright, g_redup, g_reddown,
													g_greenleft, g_greenright, g_greenup, g_greendown,
													g_blueleft, g_blueright, g_blueup, g_bluedown
);

enum logic [5:0] { not_moving, g_upone, g_uptwo, g_upthree, g_upfour,
						 g_downone, g_downtwo, g_downthree, g_downfour,
						 g_leftone, g_lefttwo, g_leftthree, g_leftfour,
						 g_rightone, g_righttwo, g_rightthree, g_rightfour} cur_state, next_state;
						 
						 
reg [31:0] count;

logic flag;
				
				
logic [10:0] gdown_rom_address, gup_rom_address, gleft_rom_address, gright_rom_address;

// other sprite motion animation
logic [10:0] gdown2_rom_address, gup2_rom_address, gleft2_rom_address, gright2_rom_address;

// rom address
logic [4:0] gdown_rom_q, gup_rom_q, gleft_rom_q, gright_rom_q;

// rom address for other motion
logic [4:0] gdown2_rom_q, gup2_rom_q, gleft2_rom_q, gright2_rom_q;

// palettes
logic [3:0] gdpalette_red, gdpalette_green, gdpalette_blue,
				gupalette_red, gupalette_green, gupalette_blue,
				grpalette_red, grpalette_green, grpalette_blue,
				glpalette_red, glpalette_green, glpalette_blue; 
				
logic [3:0] gd2palette_red, gd2palette_green, gd2palette_blue,
				gu2palette_red, gu2palette_green, gu2palette_blue,
				gr2palette_red, gr2palette_green, gr2palette_blue,
				gl2palette_red, gl2palette_green, gl2palette_blue; 

// Creating guard sprite
// down guard - first motion
guard_sprite_rom guard_rom_map (
	.clock   (vga_clk),
	.address (gdown_rom_address),
	.q       (gdown_rom_q)
);

guard_sprite_palette guard_palette (
	.index (gdown_rom_q),
	.red   (gdpalette_red),
	.green (gdpalette_green),
	.blue  (gdpalette_blue)
);

// down guard - second motion
guard_down2_rom g2down_rom_map (
	.clock   (vga_clk),
	.address (gdown2_rom_address),
	.q       (gdown2_rom_q)
);

guard_down2_palette g2down_palette (
	.index (gdown2_rom_q),
	.red   (gd2palette_red),
	.green (gd2palette_green),
	.blue  (gd2palette_blue)
);


// up - first motion
guard_up_rom g_up_rom (
	.clock   (vga_clk),
	.address (gup_rom_address),
	.q       (gup_rom_q)
);	

guard_up_palette guard_up_palette (
	.index (gup_rom_q),
	.red   (gupalette_red),
	.green (gupalette_green),
	.blue  (gupalette_blue)
);

// up - second motion
guard_up2_rom g2_up_rom (
	.clock   (vga_clk),
	.address (gup2_rom_address),
	.q       (gup2_rom_q)
);

guard_up2_palette gup_palette (
	.index (gup2_rom_q),
	.red   (gu2palette_red),
	.green (gu2palette_green),
	.blue  (gu2palette_blue)
);

//right - first motion
guard_right_rom g_right_rom (
	.clock   (vga_clk),
	.address (gright2_rom_address),
	.q       (gright2_rom_q)
);	

guard_right_palette gright_palette (
	.index (gright2_rom_q),
	.red   (gr2palette_red),
	.green (gr2palette_green),
	.blue  (gr2palette_blue)
);

//right - second motion
guard_right2_rom g2_right_rom (
	.clock   (vga_clk),
	.address (gright_rom_address),
	.q       (gright_rom_q)
);	

guard_right2_palette g2right_palette (
	.index (gright_rom_q),
	.red   (grpalette_red),
	.green (grpalette_green),
	.blue  (grpalette_blue)
);

//left - first motion
guard_left_rom g_left_rom (
	.clock   (vga_clk),
	.address (gleft_rom_address),
	.q       (gleft_rom_q)
);	

guard_left_palette gleft_palette (
	.index (gleft_rom_q),
	.red   (glpalette_red),
	.green (glpalette_green),
	.blue  (glpalette_blue)
);
		
//left - second motion
guard_left2_rom g2left_rom (
	.clock   (vga_clk),
	.address (gleft2_rom_address),
	.q       (gleft2_rom_q)
);	

guard_left2_palette g2left_palette (
	.index (gleft2_rom_q),
	.red   (gl2palette_red),
	.green (gl2palette_green),
	.blue  (gl2palette_blue)
);		

assign gdown_rom_address = ((DrawX - GuardX) + (DrawY - GuardY) * 21);
assign gup_rom_address = ((DrawX - GuardX) + (DrawY - GuardY) * 21);
assign gleft_rom_address = ((DrawX - GuardX) + (DrawY - GuardY) * 21);
assign gright_rom_address = ((DrawX - GuardX) + (DrawY - GuardY) * 21);

assign gdown2_rom_address = ((DrawX - GuardX) + (DrawY - GuardY) * 21);
assign gup2_rom_address = ((DrawX - GuardX) + (DrawY - GuardY) * 21);
assign gleft2_rom_address = ((DrawX - GuardX) + (DrawY - GuardY) * 21);
assign gright2_rom_address = ((DrawX - GuardX) + (DrawY - GuardY) * 21);


// similar to guard_control module set up
always@(posedge vga_clk)
begin
	if(flag) 
		count <= 0;
	
	else
		count <= count + 1;
end


always_ff @ (posedge vga_clk or posedge Reset)
begin
	if (Reset)
	begin
		cur_state <= not_moving;
		flag <= 1'b0;
	end
	else if (count > 100000)
	begin
		cur_state <= next_state;
		flag <= 1'b1;
	end
	
	else
		flag <= 1'b0;
end	


always_comb
begin
	// Maintain position at default state
	next_state = cur_state;
	
	// default variable instantiations
	// for left sprite 
	g_redleft 	 = glpalette_red;
	g_greenleft = glpalette_green;
	g_blueleft  = glpalette_blue;
	
	// for right sprite
	g_redright   = grpalette_red;
	g_greenright = grpalette_green; 
	g_blueright  = grpalette_blue;
	
	// for up sprite
	g_redup 	 = gupalette_red;
	g_greenup = gupalette_green; 
	g_blueup  = gupalette_blue;	
	
	// for down sprite
	g_reddown 	= gdpalette_red;
	g_greendown = gdpalette_green; 
	g_bluedown  = gdpalette_blue;	

	


	unique case (cur_state)
	not_moving: 
		case(direction_guard)
		
		// left
		3'b000 : begin	
			next_state = g_leftone;
		end
		
		// right
		3'b001 : begin
			next_state = g_rightone;
		end
		
		// down	
		3'b010 : begin
			next_state = g_downone;
		end
		
		// up 
		3'b011 : begin
			next_state = g_upone;
		end	
		
		// no movement
		3'b111 : begin
			next_state = cur_state;
		end
		
		default: begin
			next_state = not_moving;
		end
		
	endcase
	
	// Left movement sprite: one -> two -> three -> four
	g_leftone:
		if (direction_guard == 3'b000)
			next_state = g_lefttwo;
			
		else
			next_state = not_moving;
			
	g_lefttwo:
		if (direction_guard == 3'b000)
			next_state = g_leftthree;
			
		else
			next_state = not_moving;
			
	g_leftthree:
		if (direction_guard == 3'b000)
			next_state = g_leftfour;
			
		else
			next_state = not_moving;
			
	g_leftfour:
		if (direction_guard == 3'b000)
			next_state = g_leftone;
			
		else
			next_state = not_moving;
	
	// Right movement sprite: one -> two -> three -> four
	g_rightone:
		if (direction_guard == 3'b001)
			next_state = g_righttwo;
			
		else
			next_state = not_moving;
			
	g_righttwo:
		if (direction_guard == 3'b001)
			next_state = g_rightthree;
			
		else
			next_state = not_moving;
			
	g_rightthree:
		if (direction_guard == 3'b001)
			next_state = g_rightfour;
			
		else
			next_state = not_moving;
			
	g_rightfour:
		if (direction_guard == 3'b001)
			next_state = g_rightone;
			
		else
			next_state = not_moving;

	// Down movement sprite: one -> two -> three -> four
	g_downone:
		if (direction_guard == 3'b010)
			next_state = g_downtwo;
			
		else
			next_state = not_moving;
			
	g_downtwo:
		if (direction_guard == 3'b010)
			next_state = g_downthree;
			
		else
			next_state = not_moving;
			
	g_downthree:
		if (direction_guard == 3'b010)
			next_state = g_downfour;
			
		else
			next_state = not_moving;
			
	g_downfour:
		if (direction_guard == 3'b010)
			next_state = g_downone;
			
		else
			next_state = not_moving;
			
	// Up movement sprite: one -> two -> three -> four
	g_upone:
		if (direction_guard == 3'b011)
			next_state = g_uptwo;
			
		else
			next_state = not_moving;
			
	g_uptwo:
		if (direction_guard == 3'b011)
			next_state = g_upthree;
			
		else
			next_state = not_moving;
			
	g_upthree:
		if (direction_guard == 3'b011)
			next_state = g_upfour;
			
		else
			next_state = not_moving;
			
	g_upfour:
		if (direction_guard == 3'b011)
			next_state = g_upone;
			
		else
			next_state = not_moving;
		
	endcase
	
	case(cur_state)
	
	// Stationary one
	not_moving:
		begin
			g_reddown = gdpalette_red;
			g_greendown = gdpalette_green;
			g_bluedown = gdpalette_blue;
		end
	
	// add first motion palette RGB
	g_leftone:
		begin
		g_redleft  = glpalette_red;
		g_greenleft = glpalette_green;
		g_blueleft = glpalette_blue;
		end
		
	g_lefttwo:
		begin
		g_redleft  = glpalette_red;
		g_greenleft = glpalette_green;
		g_blueleft = glpalette_blue;
		end
	
   // add second motion palette RGB	
	g_leftthree:
		begin
		g_redleft  = gl2palette_red;
		g_greenleft = gl2palette_green;
		g_blueleft = gl2palette_blue;
		end
		
	g_leftfour:
		begin
		g_redleft  = gl2palette_red;
		g_greenleft = gl2palette_green;
		g_blueleft = gl2palette_blue;
		end
		
	// add first motion palette RGB		
	g_rightone:
		begin
		g_redright = grpalette_red;
		g_greenright = grpalette_green;
		g_blueright = grpalette_blue;
		end
		
	g_righttwo:
		begin
		g_redright = grpalette_red;
		g_greenright = grpalette_green;
		g_blueright = grpalette_blue;
		end
		
   // add second motion palette RGB
	g_rightthree:
		begin
		g_redright = gr2palette_red;
		g_greenright = gr2palette_green;
		g_blueright = gr2palette_blue;
		end
		
	g_rightfour:
		begin
		g_redright = gr2palette_red;
		g_greenright = gr2palette_green;
		g_blueright = gr2palette_blue;
		end
		
	// add first motion palette RGB	
	g_upone:
		begin
		g_redup = gupalette_red;
		g_greenup = gupalette_green;
		g_blueup = gupalette_blue;
		end
		
	g_uptwo:
		begin
		g_redup = gupalette_red;
		g_greenup = gupalette_green;
		g_blueup = gupalette_blue;
		end

   // add second motion palette RGB		
	g_upthree:
		begin
		g_redup = gu2palette_red;
		g_greenup = gu2palette_green;
		g_blueup = gu2palette_blue;
		end
	
	g_upfour:
		begin
		g_redup = gu2palette_red;
		g_greenup = gu2palette_green;
		g_blueup = gu2palette_blue;
		end

	// add first motion palette RGB		
	g_downone:
		begin
		g_reddown = gdpalette_red;
		g_greendown = gdpalette_green;
		g_bluedown = gdpalette_blue;
		end
		
	g_downtwo:
		begin
		g_reddown = gdpalette_red;
		g_greendown = gdpalette_green;
		g_bluedown = gdpalette_blue;
		end
		
   // add second motion palette RGB	
	g_downthree:
		begin
		g_reddown = gd2palette_red;
		g_greendown = gd2palette_green;
		g_bluedown = gd2palette_blue;
		end
		
	g_downfour:
		begin
		g_reddown = gd2palette_red;
		g_greendown = gd2palette_green;
		g_bluedown = gd2palette_blue;
		end
	
	endcase
	

	

	
	
end

endmodule




