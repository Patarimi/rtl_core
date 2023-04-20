module counter #(
    parameter BITS = 32
)(
    input clk,
    input [BITS-1:0] incr,
    input reset,
    output reg [BITS-1:0] count
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end else begin
            count <= count + incr;
        end
    end
endmodule
