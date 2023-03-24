module snake_down_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

logic [11:0] palette [16];
assign {red, green, blue} = palette[index];

always_comb begin
	palette[00] = {4'h0, 4'h0, 4'h0};
	palette[01] = {4'h0, 4'h4, 4'h1};
	palette[02] = {4'hB, 4'h9, 4'h7};
	palette[03] = {4'h0, 4'h0, 4'h0};
	palette[04] = {4'h7, 4'h5, 4'h0};
	palette[05] = {4'h0, 4'h8, 4'h4};
	palette[06] = {4'h3, 4'h2, 4'h0};
	palette[07] = {4'h8, 4'h6, 4'h5};
	palette[08] = {4'h1, 4'h1, 4'h0};
	palette[09] = {4'h0, 4'h4, 4'h1};
	palette[10] = {4'h6, 4'h4, 4'h0};
	palette[11] = {4'hA, 4'h6, 4'h0};
	palette[12] = {4'h0, 4'h6, 4'h3};
	palette[13] = {4'h5, 4'h4, 4'h4};
	palette[14] = {4'hD, 4'hB, 4'h8};
	palette[15] = {4'h0, 4'h2, 4'h0};
end

endmodule
