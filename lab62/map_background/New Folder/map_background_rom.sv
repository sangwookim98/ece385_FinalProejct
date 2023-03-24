module map_background_rom (
//	input logic clock,
//	input logic [18:0] address,
//	output logic [3:0] q
//);
//
//logic [3:0] memory [0:307199] /* synthesis ram_init_file = "./background_update.mif" */;
//
//always_ff @ (posedge clock) begin
//	q <= memory[address];
//end
//
//endmodule
	input logic clock,
	input logic [15:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:65535] /* synthesis ram_init_file = "./reduce_background.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule