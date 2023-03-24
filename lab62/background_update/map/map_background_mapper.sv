module map_background_mapper (
	input logic [9:0] DrawX, DrawY,
	input logic vga_clk, blank,
	
	// Sprite movement
	input [7:0] keycode,
	// Sprite
	input [9:0] SnakeX, SnakeY, SnakeS, SnakeSY,
	
	// background
	output logic [3:0] red, green, blue);

logic [19:0] rom_address;
logic [4:0] rom_q;
logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX*640/640) + (DrawY*480/480 * 640);


// Sprite variables	 
logic [9:0] sDistX, sDistY;
				
assign sDistX = DrawX - SnakeX;
assign sDistY = DrawY - SnakeY;


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

// Sprite Initialization
logic [10:0] sdown_rom_address, sup_rom_address, sleft_rom_address, sright_rom_address;
logic [4:0] sdown_rom_q, sup_rom_q, sleft_rom_q, sright_rom_q;
// down
logic [3:0] sdpalette_red, sdpalette_green, sdpalette_blue,
				supalette_red, supalette_green, supalette_blue,
				srpalette_red, srpalette_green, srpalette_blue,
				slpalette_red, slpalette_green, slpalette_blue; 


// Creates sprite
// down
snake_down_rom snake_down_rom (
	.clock   (vga_clk),
	.address (sdown_rom_address),
	.q       (sdown_rom_q)
);

snake_down_palette snake_down_palette (
	.index (sdown_rom_q),
	.red   (sdpalette_red),
	.green (sdpalette_green),
	.blue  (sdpalette_blue)
);

// up
snake_up_rom snake_up_rom (
	.clock   (vga_clk),
	.address (sup_rom_address),
	.q       (sup_rom_q)
);

snake_up_palette snake_up_palette (
	.index (sup_rom_q),
	.red   (supalette_red),
	.green (supalette_green),
	.blue  (supalette_blue)
);

// right
snake_right_rom snake_right_rom (
	.clock   (vga_clk),
	.address (sright_rom_address),
	.q       (sright_rom_q)
);

snake_right_palette snake_right_palette (
	.index (sright_rom_q),
	.red   (srpalette_red),
	.green (srpalette_green),
	.blue  (srpalette_blue)
);

// left
snake_left_rom snake_left_rom (
	.clock   (vga_clk),
	.address (sleft_rom_address),
	.q       (sleft_rom_q)
);

snake_left_palette snake_left_palette (
	.index (sleft_rom_q),
	.red   (slpalette_red),
	.green (slpalette_green),
	.blue  (slpalette_blue)
);



always_ff @ (posedge vga_clk) begin
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;
	
	// For actual game test
	if (blank) begin
		red <= palette_red;
		green <= palette_green;
		blue <= palette_blue;
		
		// down
		case (keycode)
		8'h16 : begin			// Down
			if (sDistX < SnakeS && sDistY < SnakeSY)
			begin
			red <= sdpalette_red;
			green <= sdpalette_green;
			blue <= sdpalette_blue;
			end
		end

		8'h1A : begin			// Up
			if (sDistX < SnakeS && sDistY < SnakeSY)
			begin
			red <= supalette_red;
			green <= supalette_green;
			blue <= supalette_blue;
			end
		end
		
		8'h04 : begin        // Left
			if (sDistX < SnakeS && sDistY < SnakeSY)
			begin
			red <= slpalette_red;
			green <= slpalette_green;
			blue <= slpalette_blue;
			end
		end
			
		8'h07 : begin			// Right
			if (sDistX < SnakeS && sDistY < SnakeSY)
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
				red <= sdpalette_red;
				green <= sdpalette_green;
				blue <= sdpalette_blue;
				end
			end
			
	endcase
	
	end
	
	
	// For code development/multiple compilation only
//	if (blank) begin
//		red <= palette_red;
//		green <= palette_green;
//		blue <= palette_blue;
//	end
	
end


assign sdown_rom_address = ((DrawX - SnakeX) + (DrawY - SnakeY) * 21);
assign sup_rom_address = ((DrawX - SnakeX) + (DrawY - SnakeY) * 21);
assign sleft_rom_address = ((DrawX - SnakeX) + (DrawY - SnakeY) * 21);
assign sright_rom_address = ((DrawX - SnakeX) + (DrawY - SnakeY) * 21);

endmodule
