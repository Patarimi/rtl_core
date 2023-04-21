`default_nettype none

module decimator #(
    parameter osr = 6
)(
    input stream_in,
    input clk,
    input rst_n,
    output reg [15:0] dec_out
);
    reg [(osr+3):0] count;
    reg [15:0] out;

       always@(posedge clk)begin
               if(!rst_n)begin
                       out <= 'd0;
                       count <= 'd0;
               end else begin
                       out <= out + stream_in;
                       case(count)
                           {(osr+2){1'b1}}: begin
                               count <= 0;
                               dec_out <= out;
                           end
                           'b0: begin
                               count <= count + 1;
                               out <= stream_in;
                           end
                           default: count <= count + 1;
                       endcase
               end
       end

endmodule

