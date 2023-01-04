`default_nettype none

module spi_device
    #(
    parameter WORD_WIDTH = 8
    ) (
    //spi interface
    input mosi,
    input sck,
    input ssn,
    output reg miso,
    //memory interface
    output reg [WORD_WIDTH-1:0] rword,
    input [WORD_WIDTH-1:0] sword,
    output reg ovalid,
    input oready
    );
    reg [WORD_WIDTH-1:0] rbuffer;
    reg [$clog2(WORD_WIDTH-1):0] count;
    
    initial begin
        count = 0;
        ovalid = 0;
    end

    always @(posedge sck) begin
        if (ovalid == 0 & ssn == 0) begin
            miso <= sword[count];
            rbuffer[count] <= mosi;
            if (count >= WORD_WIDTH-1) begin
                ovalid <= 1;
                count <= 0;
            end else begin
                count <= count+1;
            end
        end
        if (oready == 1) ovalid <= 0;
    end
    always @(posedge ovalid) rword <= rbuffer;
endmodule
