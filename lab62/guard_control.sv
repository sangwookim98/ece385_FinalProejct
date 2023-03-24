module guard_control (input logic Reset, Clk,
							 				
							 output [2:0] direction_guard 			
);

logic flag;

reg[31:0] count;

// State names
enum logic [4:0] {start, up_guard, down_guard, left_guard, right_guard, hold_1, hold_2, hold_3, hold_4} cur_state, next_state;

// direction:
//000 : left
//001 : right
//010 : down
//011 : top

//100 : no movement


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
	begin
		cur_state <= right_guard;
		flag <= 1'b0;
	end
	else if (count > 100000050)
	begin
		cur_state <= next_state;
		flag <= 1'b1;
	end
	
	else
		flag <= 1'b0;
end		


always_comb
begin
	direction_guard = 3'b100;
   next_state = cur_state;
	
	unique case (cur_state)
	start:
		next_state = up_guard;
			
	up_guard:
		next_state = hold_1;
		
	hold_1:
		next_state = right_guard;
					
	right_guard:
		next_state = hold_2;
		
	hold_2:
		next_state = down_guard;

	down_guard:
		next_state = hold_3;
		
	hold_3:
		next_state = left_guard;
		
	left_guard:
		next_state = hold_4;
		
	hold_4:
		next_state = up_guard;
		

			
	default :
		next_state = right_guard;

	endcase

case (cur_state)
	start:	
		direction_guard = 3'b011;
	
	right_guard:
		direction_guard = 3'b001;
		
	hold_1:
		direction_guard = 3'b100;
		
	down_guard:
		direction_guard = 3'b010;
		
	hold_2:
		direction_guard = 3'b100;
		
	left_guard:
		direction_guard = 3'b000;
		
	hold_3:
		direction_guard = 3'b100;
		
	up_guard:
		direction_guard = 3'b011;
		
	hold_4:
		direction_guard = 3'b100;
		
	default :
		direction_guard = 3'b100;

	
	endcase
end
	
endmodule
