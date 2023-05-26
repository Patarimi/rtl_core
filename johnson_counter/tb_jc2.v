module tb_jc2;

reg go_left;
reg go_right;
reg stop;
reg clk;
wire [3:0] q;

initial begin
    $from_myhdl(
        go_left,
        go_right,
        stop,
        clk
    );
    $to_myhdl(
        q
    );
end

jc2 dut(
    go_left,
    go_right,
    stop,
    clk,
    q
);

endmodule
