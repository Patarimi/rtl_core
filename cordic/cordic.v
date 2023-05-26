module cordic_pipelined
#(
	parameter BITS = 16,
	parameter STEPS = 15
)
(
	input signed [BITS:0] angle, // angle to be compute between -pi and pi
	input clk,
	output reg signed [BITS:0] sinus, cosinus //sinus ans cosinus value. /!\ it is not normalised by 0.60725293651701.
);

reg signed [BITS:0] beta [STEPS:0];
reg [BITS-1:0] Xm [STEPS:0];
reg [BITS-1:0] Ym [STEPS:0];
wire [BITS:0] cos, sin;
reg cos_signe;

// pi  =16'b1100100100010000;
localparam pi_2=16'b0110010010001000;

assign cos_signe = (angle > pi_2 ) || (angle < -pi_2);
assign beta[0] = angle<0 ? -angle : angle;
assign Xm[0] = {2'b1, 14'b0};
assign Ym[0] = {16'b0};
assign cos[BITS:0] = {1'b0, Xm[STEPS]};
assign sin[BITS:0] = angle<0 ? -Ym[STEPS] : {1'b0, Ym[STEPS]};

always @(posedge clk) begin
	sinus <= sin;
	cosinus <= cos;
end

generate
genvar i;
	for (i=0; i < STEPS; i = i+1) begin
		cordic_core #(.BITS(BITS), .STEPS(STEPS))
			c_core (.Bin(beta[i]),
					.Xin(Xm[i]),
					.Yin(Ym[i]),
					.step(i),
					.Bout(beta[i+1]),
					.Xout(Xm[i+1]),
					.Yout(Ym[i+1]));
	end 
endgenerate
endmodule


module cordic_core
// this module compute one step of the CORDIC algorithm. It uses fixed point representation for all number (MSB is 2).
#(
	//run atan_table.py to update the table and the STEPS value after editing BITS.
	parameter BITS = 16, // bit width of input and output data
	parameter STEPS = 15 // number of step of the CORDIC algorithm
)
(
	input  signed [BITS:0] Bin,   //angle from previous step (angle to be compute for first step)
	input  [BITS-1:0] Xin,	 //result from previous step (1 for first step)
	input  [BITS-1:0] Yin,	 //result from previous step (0 for first step)
	input  [$clog2(STEPS)-1:0] step,
	output reg [BITS-1 :0] Xout,
	output reg [BITS-1 :0] Yout,
	output reg signed [BITS :0] Bout
);

wire [BITS-1:0] atan;

atan_table #(.BITS(BITS), .STEPS(STEPS)) atan_rom (.step(step), .atan(atan));

always @* begin
	if (Bin[BITS] == 1) begin //beta is negative, sigma = -1
		Xout <= Xin + (Yin >> step);
		Yout <= Yin - (Xin >> step);
		Bout <= atan + Bin;
	end else begin
		if (Bin == {BITS{1'b0}}) begin
			Xout <= Xin;
			Yout <= Yin;
			Bout <= Bin;
		end else begin
			Xout <= Xin - (Yin >> step);
			Yout <= Yin + (Xin >> step);
			Bout <= Bin - atan;
		end
	end
end

endmodule


module atan_table
#(
	parameter BITS = 16,
	parameter STEPS = 15
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
		4'he : atan <= 16'b0000000000000001;
	endcase
end
endmodule
