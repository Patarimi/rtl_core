`timescale 1ns / 1ps

module bench;
    parameter delay = 700;
    
    reg clk, res, ce;
    reg signed [15:0] din;
    wire signed [15:0] out_d;
    wire dout;
    
    sdm_2o dac (
        .clk(clk),
        .rst_n(res),
        .din(din), 
        .dout(dout)
    );

    decimator dec(
        .stream_in(dout),
        .clk(clk),
        .rst_n(res),
        .dec_out(out_d)
    );

    integer step;
    
    initial begin
        $dumpfile("sigma_delta_2.vcd");
        $dumpvars(0, bench);
    //variables initialisation
        clk <= 1'b0;
        res <= 1'b0;
        
        #20 res <= 1'b1;
        
        din <= 16'b0100000000000000;
        
        wait(out_d == 'd191);
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

