module guard_control (input logic Reset, Clk,
							 input [9:0] vision_startX, vision_startY, vision_endX, vision_endY,
							 input [9:0] GuardX, GuardY, GuardS, GuardSY,
					
							 output logic [2:0] direction_guard 			
);

logic flag;
reg[31:0] count;

// State names
enum logic [4:0] {start, up_guard, down_guard, left_guard, right_guard, hold_1, hold_2, hold_3, hold_4} cur_state, next_state

always@(posedge Clk)
begin
	if(flag) 
		count <= 0;
	
	else
		count <= count + 1;
end



always_ff @ (posedge Clk or posedge Reset)
begin
	if (Reset)
		cur_state <= start;
	else if (count > 250)
	begin
		cur_state <= next_state;
		flag <= 1'b1;
	end
	
	else
		flag <= 1'b0;
end		


endmodule
