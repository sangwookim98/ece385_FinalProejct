module bg_switch(input [7:0] keycode,
					input logic Reset, vga_clk,
				   input [9:0] DrawX, DrawY, 
					
					output logic [3:0] back_red, back_green, back_blue,
					output logic [3:0] ss_out_red, ss_out_green, ss_out_blue
					);
					
					
// start screen variables
logic [19:0] startscrn_rom_address;
logic [4:0] startscrn_rom_q;
logic [3:0] sspalette_red, sspalette_green, sspalette_blue;
logic start_screen;

//logic [3:0] ss_out_red, ss_out_green, ss_out_blue;

assign startscrn_rom_address = (DrawX*256/640) + (DrawY*256/480 * 256);

// background variables
logic [19:0] rom_address;
logic [4:0] rom_q;
logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX*256/640) + (DrawY*256/480 * 256);

// Background map intialization
map_background_rom map_background_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

map_background_palette map_background_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);


intro_rom start_rom(
	.clock   (vga_clk),
	.address (startscrn_rom_address),
	.q       (startscrn_rom_q)
);

intro_palette start_palette (
	.index (startscrn_rom_q),
	.red   (sspalette_red),
	.green (sspalette_green),
	.blue  (sspalette_blue)
);

enum logic [2:0] { start_bground, game_bground, end_bground} cur_state, next_state;

logic game_overflag;

always_ff @ (posedge vga_clk or posedge Reset)
begin
	if (Reset)
		cur_state <= start_bground;
	
	
	else
		cur_state <= next_state;

end


always_comb
begin
	next_state = cur_state;
	back_red   = sspalette_red;
	back_green = sspalette_blue;
	back_blue  = sspalette_green;

unique case (cur_state)
	start_bground: 
		begin
		case(keycode)
		
		
		// start -> game screen
		10'd40 : begin	
			next_state = game_bground;
		end
		endcase
		
		case(game_overflag)
		
		// gamescreen -> game_over
		1'b1 : begin
			next_state = end_bground;
		end	
		
		endcase
	end
	
	// states
	start_bground :
	if (keycode == 10'd40)
		next_state = game_bground;
		
	else
		next_state = start_bground;
		
	game_bground :
	if (game_overflag == 1'b1)
		next_state = end_bground;
		
	else
		next_state = game_bground;
		
	end_bground :
		next_state = end_bground;
		
	endcase
		
	case(cur_state)
	start_bground :
		begin
		back_red   = sspalette_red;
		back_green = sspalette_green;
		back_blue  = sspalette_blue;
		end
	
	game_bground :
		begin
		back_red   = palette_red;
		back_green = palette_green;
		back_blue  = palette_blue;
		end
	
//	end_bground :
//		begin

	endcase
	
	end
	
	
assign ss_out_red = sspalette_red;
assign ss_out_green = sspalette_green;
assign ss_out_blue = sspalette_blue;

endmodule
		
		
		
		