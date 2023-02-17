`default_nettype none

module spi_device
#(
	//the spi trame is composed of 2 parts :
	//the command (register adress, read/write mode, ...)
	parameter SPI_CMD_WIDTH = 8,
	// and the data (read mode -> reg_bus write to miso, write mode -> mosi write to reg_bus)
	parameter SPI_DATA_WIDTH = 8,
	parameter SPI_ADDR_WIDTH = 3
) (
`ifdef USE_POWER_PINS
	inout vccd1, vssd1,
`endif
	//spi interface
	input 	spi_mosi,
	input 	spi_clk,
	input 	spi_sel,
	output reg  spi_miso,

	//registers interface
	inout      reg_bus,
	output     [SPI_ADDR_WIDTH-1:0]reg_addr,
	output     reg_dir, // 1 if write into the register
	output reg reg_clk
);

//list of state in the machine
localparam [1:0]
	iddle = 0,
	read_cmd = 1,
	tsfr_data = 2;
//store the pres_state and the future state
reg [1:0] pres_state, next_state;

function integer max(input integer a, b);
begin
	if(a > b) begin
		max = a;
	end else
		max = b;
	end
endfunction
//store elapsed time
reg [$clog2(max(SPI_CMD_WIDTH, SPI_DATA_WIDTH)):0] t;

//store mosi value during read_cmd state
reg [SPI_CMD_WIDTH:0] reg_cmd;
// store reg_bus value during trsf_state
reg reg_mosi;
//trame composition
assign reg_dir = reg_cmd[0];
assign reg_addr = reg_cmd[SPI_ADDR_WIDTH:1];
//reg_bus is high_z during writing
assign reg_bus = (reg_dir == 1) ? reg_mosi : 'bz;

//refresh state on clk edge and keep track of time
always @(negedge spi_clk) begin
	if (spi_sel) begin
		pres_state <= iddle;
		t <= 0;
	end
	else begin
		pres_state <= next_state;
		if ((pres_state != next_state) || (pres_state == iddle))
			t <= 0;
		else
			t <= t + 1;
	end
end

//compute next state and output states
always @* begin
	next_state = pres_state;
	case (pres_state)
		iddle : begin
			reg_cmd = 0;
			reg_clk = 1;
			if (!spi_sel) begin
				next_state = read_cmd;
			end
		end
		read_cmd : begin
			if (t >= SPI_CMD_WIDTH-1) begin
				next_state = tsfr_data;
			end
		end
		tsfr_data : begin
			reg_clk = spi_clk;
			if (~reg_dir) begin
				spi_miso = reg_bus;
		    end
			else begin
			    reg_mosi = spi_mosi;
			end
			if (t >= SPI_DATA_WIDTH-1) begin
				next_state = read_cmd;
			end
		end
	endcase
end
always @(posedge spi_clk) begin
    if (pres_state == read_cmd) begin
        reg_cmd[t] <= spi_mosi;
    end
end
endmodule

module spi_register
#(
	parameter REG_DATA_WIDTH = 8,
	parameter REG_ADDR_WIDTH = 3,
	parameter REG_ADDR = 0
)(
`ifdef USE_POWER_PINS
	inout vccd1, vssd1,
`endif
	//register interface
	inout reg_bus,
	input [REG_ADDR_WIDTH-1:0]reg_addr,
	input reg_dir,
	input reg_clk,
	output reg [REG_DATA_WIDTH-1:0]reg_data
);

//store elapsed time
reg [$clog2(REG_DATA_WIDTH):0] t;
reg data_t;
//reg_bus is high_z during writing
assign reg_bus = (reg_dir == 0) ? data_t : 1'bz;

//keep track of time
always @(negedge reg_clk) begin
	if (t < REG_DATA_WIDTH-1)
		t <= t + 1;
	else
		t <= 0;
end

always @(t) begin
	if ((reg_addr == REG_ADDR) && (reg_dir == 1)) begin
			reg_data[REG_DATA_WIDTH-t-1] = reg_bus;
	end
end

always @(posedge reg_clk) begin
	if ((reg_addr == REG_ADDR) && (reg_dir == 0)) begin
			data_t = reg_data[REG_DATA_WIDTH-t-1];
	end
end
endmodule

`default_nettype wire
