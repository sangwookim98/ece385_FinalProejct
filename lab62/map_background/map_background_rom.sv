module map_background_rom (
	input logic clock,
	input logic [15:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:65535] /* synthesis ram_init_file = "./map_background.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
