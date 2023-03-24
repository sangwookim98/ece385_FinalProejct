module map_background_mapper (
	input logic [9:0] DrawX, DrawY,
	input logic vga_clk, blank,
	input logic register,
	
	// Sprite movement
	input [7:0] keycode,
	// Sprite
	input [9:0] SnakeX, SnakeY, SnakeS, SnakeSY,
	// first guard
	input [9:0] GuardX, GuardY, GuardS, GuardSY,
	// second guard
//	input [9:0] Guard2X, Guard2Y, Guard2S, Guard2SY,	
	
	// for background switch control
	input [3:0] back_red, back_green, back_blue,
	
	input [3:0] ss_red, ss_blue, ss_green,
	
	// ending screen
	input [3:0] msgX, msgY, msgS, msgSY,
	
	// key
	input key_enable, 
	input [9:0] keyX, keyY, keyS, keySY,
	
	input [9:0] camX, camY, camS, camSY,
	
	input [2:0] direction_guard,
	input [2:0] direction_snake,
	input	[2:0] direction_secondguard,
	
	
	input [3:0] sdpalette_red, sdpalette_green, sdpalette_blue,
				   supalette_red, supalette_green, supalette_blue,
				   srpalette_red, srpalette_green, srpalette_blue,
				   slpalette_red, slpalette_green, slpalette_blue,
	
	// first guard
	input [3:0] gdpalette_red, gdpalette_green, gdpalette_blue,
				   gupalette_red, gupalette_green, gupalette_blue,
				   grpalette_red, grpalette_green, grpalette_blue,
				   glpalette_red, glpalette_green, glpalette_blue,
					
	// second guard				
//	input [3:0] g2dpalette_red, g2dpalette_green, g2dpalette_blue,
//				   g2upalette_red, g2upalette_green, g2upalette_blue,
//				   g2rpalette_red, g2rpalette_green, g2rpalette_blue,
//				   g2lpalette_red, g2lpalette_green, g2lpalette_blue,	
					
	
	
	// background
	output logic [3:0] red, green, blue
);

//logic [19:0] rom_address;
//logic [4:0] rom_q;
//logic [3:0] palette_red, palette_green, palette_blue;
//
//assign rom_address = (DrawX*256/640) + (DrawY*256/480 * 256);





// camera logic
logic [19:0] cam_rom_address;
logic [4:0] cam_rom_q;
logic [3:0] cpalette_red, cpalette_green, cpalette_blue;

// Sprite variables	 
logic [9:0] sDistX, sDistY, gDistX, gDistY;

// camera variables
logic [9:0] cDistX, cDistY;

assign cam_rom_address = ((DrawX - camX) + (DrawY - camY) * 21);
				
assign sDistX = DrawX - SnakeX;
assign sDistY = DrawY - SnakeY;

// first guard variables
assign gDistX = DrawX - GuardX;
assign gDistY = DrawY - GuardY;

// second guard variables
//assign g2DistX = DrawX - Guard2X;
//assign g2DistY = DrawY - Guard2Y;

// Camera variables
assign cDistX = DrawX - camX;
assign cDistY = DrawY - camY;

// key variables
logic [19:0] key_rom_address;
logic [4:0] key_rom_q;
logic [3:0] kpalette_red, kpalette_green, kpalette_blue;

logic [9:0] kDistX, kDistY;

assign kDistX = DrawX - keyX;
assign kDistY = DrawY - keyY;

assign key_rom_address = ((DrawX - keyX) + (DrawY - keyY) * 20);

// game_over
logic [19:0] msg_rom_address;
logic [4:0] msg_rom_q;
logic [3:0] mpalette_red, mpalette_green, mpalette_blue;

logic [9:0] mDistX, mDistY;

assign mDistX = DrawX - msgX;
assign mDistY = DrawY - msgY;

assign msg_rom_address = ((DrawX - msgX) + (DrawY - msgY) * 100);


//// start screen variables
//logic [19:0] startscrn_rom_address;
//logic [4:0] startscrn_rom_q;
//logic [3:0] sspalette_red, sspalette_green, sspalette_blue;
//logic start_screen;
//
//assign startscrn_rom_address = (DrawX*256/640) + (DrawY*256/480 * 256);
//
//
//// Background map intialization
//map_background_rom map_background_rom (
//	.clock   (vga_clk),
//	.address (rom_address),
//	.q       (rom_q)
//);
//
//map_background_palette map_background_palette (
//	.index (rom_q),
//	.red   (palette_red),
//	.green (palette_green),
//	.blue  (palette_blue)
//);

// Camera sprite intialization
camera_rom cam_rom(
	.clock   (vga_clk),
	.address (cam_rom_address),
	.q       (cam_rom_q)
);

camera_palette cam_palette(
	.index (cam_rom_q),
	.red   (cpalette_red),
	.green (cpalette_green),
	.blue  (cpalette_blue)
);

// key sprite initalization
keycard_rom key_rom(
	.clock   (vga_clk),
	.address (key_rom_address),
	.q       (key_rom_q)
);

keycard_palette key_palette(
	.index (key_rom_q),
	.red   (kpalette_red),
	.green (kpalette_green),
	.blue  (kpalette_blue)
);

// start screen 
//intro_rom start_rom(
//	.clock   (vga_clk),
//	.address (startscrn_rom_address),
//	.q       (startscrn_rom_q)
//);
//
//intro_palette start_palette (
//	.index (startscrn_rom_q),
//	.red   (sspalette_red),
//	.green (sspalette_green),
//	.blue  (sspalette_blue)
//);

game_set_rom gover_rom (
	.clock   (vga_clk),
	.address (msg_rom_address),
	.q       (msg_rom_q)
);

game_set_palette gover_palette (
	.index (msg_rom_q),
	.red   (mpalette_red),
	.green (mpalette_green),
	.blue  (mpalette_blue)
);

logic start_flag;

//---------------------------------------------------------SNAKE SPRITE MOVEMENT------------------------------------------------------
always_ff @ (posedge vga_clk) begin
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;
	start_flag <= 1'b0;
	
	// For actual game test
	if (blank) begin
		
//		if (keycode == 10'd40 && start_flag == 1'b0)
//		begin
//			start_flag <= 1'b1;
//			red <= palette_red;
//			green <= palette_green;
//			blue <= palette_blue;
//		end
//		
//		else
//		begin 
//			red <= sspalette_red;
//			green <= sspalette_green;
//			blue <= sspalette_blue;
//		end

		red <= back_red;
		green <= back_green;
		blue <= back_blue;
		

		
		
		if (cDistX < camS && cDistY < camSY && {cpalette_red, cpalette_green, cpalette_blue} != {4'hF, 4'h0, 4'h0})
			begin
			red <= cpalette_red;
			green <= cpalette_green;
			blue <= cpalette_blue;
			end
		
		// down
		case (keycode)
		8'h16 : begin			// Down
			if (sDistX < SnakeS && sDistY < SnakeSY && {sdpalette_red, sdpalette_green, sdpalette_blue} != {4'hE, 4'h2, 4'h2})
			begin
			red <= sdpalette_red;
			green <= sdpalette_green;
			blue <= sdpalette_blue;
			end
		end

		// IN CASE OF INVISIBLITY MODE
//		8'd10 : begin			// Guard
//			if (sDistX < SnakeS && sDistY < SnakeSY)
//			begin
//			red <= guard_red;
//			green <= guard_green;
//			blue <= guard_blue;
//			end
//		end

		
		8'h1A : begin			// Up
			if (sDistX < SnakeS && sDistY < SnakeSY && {supalette_red, supalette_green, supalette_blue} != {4'hE, 4'h0, 4'h0})
			begin
			red <= supalette_red;
			green <= supalette_green;
			blue <= supalette_blue;
			end
		end
		
		8'h04 : begin        // Left
			if (sDistX < SnakeS && sDistY < SnakeSY && {slpalette_red, slpalette_green, slpalette_blue} != {4'hE, 4'h0, 4'h0})
			begin
			red <= slpalette_red;
			green <= slpalette_green;
			blue <= slpalette_blue;
			end
		end
			
		8'h07 : begin			// Right
			if (sDistX < SnakeS && sDistY < SnakeSY && {srpalette_red, srpalette_green, srpalette_blue} != {4'hE, 4'h0, 4'h0})
			begin
			red <= srpalette_red;
			green <= srpalette_green;
			blue <= srpalette_blue;
			end	
		end
		
		default:
			begin
				if (sDistX < SnakeS && sDistY < SnakeSY)
				begin
					case(direction_snake)
					3'b000: // Left
						begin
						if ({slpalette_red, slpalette_green, slpalette_blue} != {4'hE, 4'h0, 4'h0})
							begin
							red <= slpalette_red;
							green <= slpalette_green;
							blue <= slpalette_blue;
							end
						end
						
					3'b001: //Right
						begin
						if ({srpalette_red, srpalette_green, srpalette_blue} != {4'hE, 4'h0, 4'h0})
							begin
							red <= srpalette_red;
							green <= srpalette_green;
							blue <= srpalette_blue;
							end
						end
					3'b010: // Down
						begin
						if ({sdpalette_red, sdpalette_green, sdpalette_blue} != {4'hE, 4'h2, 4'h2})
							begin
							red <= sdpalette_red;
							green <= sdpalette_green;
							blue <= sdpalette_blue;
							end
						end
						
					3'b011:
						begin
						if ({supalette_red, supalette_green, supalette_blue} != {4'hE, 4'h0, 4'h0})
							begin
							red <= supalette_red;
							green <= supalette_green;
							blue <= supalette_blue;
							end
						end
					
					endcase
				end
			end
			
	endcase
	
//------------------------------------------------------first GUARD SPRITE--------------------------------------------------------------------------------------	
	case (direction_guard)
	3'b000 : begin							// left
		if (gDistX < GuardS && gDistY < GuardSY && {glpalette_red, glpalette_green, glpalette_blue} != {4'h4, 4'h3, 4'h2}) 
		begin
			red <= glpalette_red;
			green <= glpalette_green;
			blue <= glpalette_blue;
		end
	end
	
	3'b001 : begin							// right
		if (gDistX < GuardS && gDistY < GuardSY && {grpalette_red, grpalette_green, grpalette_blue} != {4'h3, 4'h3, 4'h2}) 
		begin
			red <= grpalette_red;
			green <= grpalette_green;
			blue <= grpalette_blue;
		end
	end
	
	3'b010 : begin							// down
		if (gDistX < GuardS && gDistY < GuardSY && {gdpalette_red, gdpalette_green, gdpalette_blue} != {4'h4, 4'h3, 4'h2}) 
		begin
			red <= gdpalette_red;
			green <= gdpalette_green;
			blue <= gdpalette_blue;
		end
	end	
	
	3'b011 : begin							// up
		if (gDistX < GuardS && gDistY < GuardSY && {gupalette_red, gupalette_green, gupalette_blue}  != {4'h3, 4'h2, 4'h2}) 
		begin
			red <= gupalette_red;
			green <= gupalette_green;
			blue <= gupalette_blue;
		end
	end
		
	endcase
	
//-----------------------------------------------------------------second guard sprite----------------------------------------------------------------------	
//	case (direction_secondguard)
//	3'b000 : begin							// left
//		if (g2DistX < Guard2S && g2DistY < Guard2SY && {g2lpalette_red, g2lpalette_green, g2lpalette_blue} != {4'h4, 4'h3, 4'h2}) 
//		begin
//			red <= g2lpalette_red;
//			green <= g2lpalette_green;
//			blue <= g2lpalette_blue;
//		end
//	end
//	
//	3'b001 : begin							// right
//		if (g2DistX < Guard2S && g2DistY < Guard2SY && {g2rpalette_red, g2rpalette_green, g2rpalette_blue} != {4'h3, 4'h3, 4'h2}) 
//		begin
//			red <= g2rpalette_red;
//			green <= g2rpalette_green;
//			blue <= g2rpalette_blue;
//		end
//	end
//	
//	3'b010 : begin							// down
//		if (g2DistX < Guard2S && g2DistY < Guard2SY && {g2dpalette_red, g2dpalette_green, g2dpalette_blue} != {4'h4, 4'h3, 4'h2}) 
//		begin
//			red <= g2dpalette_red;
//			green <= g2dpalette_green;
//			blue <= g2dpalette_blue;
//		end
//	end	
//	
//	3'b011 : begin							// up
//		if (g2DistX < Guard2S && g2DistY < Guard2SY && {g2upalette_red, g2upalette_green, g2upalette_blue}  != {4'h3, 4'h2, 4'h2}) 
//		begin
//			red <= g2upalette_red;
//			green <= g2upalette_green;
//			blue <= g2upalette_blue;
//		end
//	end
//		
//	endcase

// --------------------------------------------------------key enable -----------------------------------------------------
	case (key_enable)
	1'b0 : begin							// no key
		if (kDistX < keyS && kDistY < keySY) 
		begin
			red <= kpalette_red;
			green <= kpalette_green;
			blue <= kpalette_blue;
		end
	end
	
	1'b1 : begin							// key obtained, so gone
		if (kDistX < keyS && kDistY < keySY && key_enable != 1'b1)	
		begin
			red <= back_red;
			green <= back_green;
			blue <= back_blue;
			
			if (mDistX < msgS && mDistY < msgSY && key_enable == 1'b1)
			begin
				red <= mpalette_red;
				green <= mpalette_green;
				blue <= mpalette_blue;
			end

		end
	end
	
	
	endcase
// ----------------------------------------------------------------------------------------------------------------------------	
	end			// for blank
	
	
end				// for always_ff






endmodule
