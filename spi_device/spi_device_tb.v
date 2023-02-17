`timescale 1ns / 1ps

module bench;
    parameter delay = 700;
    localparam SPI_ADDR_WIDTH = 'd3;
    
    
    reg clk, iMOSI, iSS;
    wire [SPI_ADDR_WIDTH-1:0] reg_addr;
    wire iMISO, reg_dir, reg_bus, reg_clk;
    wire [7:0] reg_data;
    
    spi_device #('d8, 'd8, SPI_ADDR_WIDTH) ctrl (
        .spi_mosi(iMOSI),
	    .spi_clk(clk),
	    .spi_sel(iSS),
	    .spi_miso(iMISO),
        .reg_bus(reg_bus),
        .reg_addr(reg_addr),
        .reg_dir(reg_dir),
        .reg_clk(reg_clk)
    );
    
    spi_register #('d8, SPI_ADDR_WIDTH, {(SPI_ADDR_WIDTH){1'b1}}) spi_reg0 (
        .reg_dir(reg_dir),
	    .reg_bus(reg_bus),
	    .reg_clk(reg_clk),
	    .reg_addr(reg_addr),
    	.reg_data(reg_data)
    );


    integer step;
    
    initial begin
        $dumpfile("spi.vcd");
        $dumpvars(0, bench);
    //variables initialisation
        clk <= 1'b0;
        iSS <= 1'b1;
        
        #delay conf_mem({(SPI_ADDR_WIDTH){1'b1}}, 1'b1, 8'b01101010);
        
        #delay conf_mem({(SPI_ADDR_WIDTH){1'b1}}, 1'b0, 8'b0);
        wait(reg_data == 8'b01101010);
        #5 $finish;
    end
    //clock generation for spi @100 MHz (2x50 ns)
    always #12.5 clk <= (clk === 1'b0);

    initial begin
        repeat (100) @(posedge clk);
        $display("Monitor: Timeout, test failed");
        $finish;
    end
    
    task conf_mem
        (
        input [SPI_ADDR_WIDTH-1:0] add,
        input w_nr,
        input [7:0] data
        );
        integer i;
        reg [0:15] cmd;
        begin
            cmd = {w_nr, add, {(7-SPI_ADDR_WIDTH){1'b0}}, data};
            @(negedge clk);
            #5 iSS <= 0;
            for (i = 0; i < 16; i = i +1) begin
                @(posedge clk);
                iMOSI <= cmd[i];
                @(negedge clk);
            end
            #5 iSS <= 1;
        end
    endtask
endmodule

