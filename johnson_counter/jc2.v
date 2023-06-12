// File: jc2.v
// Generated by MyHDL 0.11
// Date: Fri May 26 14:30:59 2023


`timescale 1ns/10ps

module jc2 (
    go_left,
    go_right,
    stop,
    clk,
    q
);
// A bidirectional 4-bit Johnson counter with stop control.
// Parameters
// ----------
// go_left : input signal to shift left
// go_right : input signal to shift right
// stop : input signal to top counting
// clk : input free-running clock
// q : 4-bit counter output

input go_left;
input go_right;
input stop;
input clk;
output [3:0] q;
reg [3:0] q;

reg [0:0] dire;
reg run;



always @(posedge clk) begin: JC2_LOGIC
    if ((go_right == 0)) begin
        dire <= 1'b0;
        run <= 1'b1;
    end
    else if ((go_left == 0)) begin
        dire <= 1'b1;
        run <= 1'b1;
    end
    if ((stop == 0)) begin
        run <= 1'b0;
    end
    if (run) begin
        if ((dire == 1'b1)) begin
            q[4-1:1] <= q[3-1:0];
            q[0] <= (!q[3]);
        end
        else begin
            q[3-1:0] <= q[4-1:1];
            q[3] <= (!q[0]);
        end
    end
end

endmodule