module atan_table
#(
	parameter BITS = 16,
	parameter STEPS = 14
)(
	input  [$clog2(STEPS)-1:0] step,
	output reg [BITS-1:0] atan
);

always @(step) begin
	case(step)
		4'h0 : atan <= 16'b0011001001000100;
		4'h1 : atan <= 16'b0001110110101100;
		4'h2 : atan <= 16'b0000111110101110;
		4'h3 : atan <= 16'b0000011111110101;
		4'h4 : atan <= 16'b0000001111111111;
		4'h5 : atan <= 16'b0000001000000000;
		4'h6 : atan <= 16'b0000000100000000;
		4'h7 : atan <= 16'b0000000010000000;
		4'h8 : atan <= 16'b0000000001000000;
		4'h9 : atan <= 16'b0000000000100000;
		4'ha : atan <= 16'b0000000000010000;
		4'hb : atan <= 16'b0000000000001000;
		4'hc : atan <= 16'b0000000000000100;
		4'hd : atan <= 16'b0000000000000010;
	endcase
end
endmodule


module cordic_core
// this module compute one step of the CORDIC algorithm. It uses fixed point representation for all number (MSB is 2).
#(
	//run atan_table.py to update the table and the STEPS value after editing BITS.
	parameter BITS = 16, // bit width of input and output data
	parameter STEPS = 14 // number of step of the CORDIC algorithm
)
(
	input  signed [BITS:0] Bin,   //angle from previous step (angle to be compute for first step)
	input  [BITS-1:0] Xin,	 //result from previous step (1 for first step)
	input  [BITS-1:0] Yin,	 //result from previous step (0 for first step)
	input  [$clog2(STEPS)-1:0] step,
	output reg [BITS-1 :0] Xout,
	output reg [BITS-1 :0] Yout,
	output reg signed [BITS :0] Bout,
	output reg [$clog2(STEPS)-1:0] step_out
);

wire [BITS-1:0] atan;

atan_table #(.BITS(BITS), .STEPS(STEPS)) atan_rom (.step(step), .atan(atan));

always @* begin
	if (Bin[BITS] == 1) begin //beta is negative, sigma = -1
		Xout <= Xin + (Yin >> step);
		Yout <= Yin - (Xin >> step);
		Bout <= atan + Bin;
	end else begin
		Xout <= Xin - (Yin >> step);
		Yout <= (Xin >> step) + Yin;
		Bout <= Bin - atan;
	end
	step_out <= step+1;
end

endmodule
