`timescale 1ns / 1ps

module bench;
    reg clk, res;
    wire [31:0] dout;

    counter dut (
        .clk(clk),
        .reset(res),
        .count(dout)
    );

    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, bench);
    //variables initialisation
        clk <= 1'b0;
        res <= 1'b1;

        #20 res <= 1'b0;

        wait(dout == 'd11);
        #5 $finish;
    end
    //clock generation for spi @100 MHz (2x50 ns)
    always #12.5 clk <= ~clk;

    initial begin
        repeat (1000) @(posedge clk);
        $display("Monitor: Timeout, test failed");
        $finish;
    end
endmodule
