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
	inout vcc, vss,
`endif
	//spi interface
	input 	spi_mosi,
	input 	spi_clk,
	input 	spi_sel,
	output reg  spi_miso,

	//registers interface
	inout 	   reg_bus,
	output reg [SPI_ADDR_WIDTH-1:0]reg_addr,
	output reg reg_dir,
	output 	   reg_clk
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
reg [$clog2(max(SPI_CMD_WIDTH, SPI_DATA_WIDTH))-1:0] t;

//store mosi value during read_cmd state
reg [SPI_CMD_WIDTH:0] reg_cmd;
//trame composition
assign reg_dir = reg_cmd[0];
assign reg_addr = reg_cmd[SPI_ADDR_WIDTH:1];


//refresh state on clk edge
always @(posedge spi_clk, posedge spi_sel) begin
	if (spi_sel) begin
		pres_state <= iddle;
	end
	else begin
		pres_state <= next_state;
	end
end

//keep track of time
always @(posedge spi_clk, posedge spi_sel) begin
	if (spi_sel) begin
		t <= 0;
	end
	else begin
		if (pres_state != next_state)
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
			reg_clk = 0;
			if (!spi_sel) begin
				next_state = read_cmd;
			end
		end
		read_cmd : begin
			reg_cmd[t] = spi_mosi;
			if (t >= SPI_CMD_WIDTH) begin
				next_state = tsfr_data;
			end
		end
		tsfr_data : begin
			reg_clk = spi_clk;
			if (reg_dir) begin
				reg_bus = spi_mosi;
			end
			else begin
				spi_miso = reg_bus;
			end
			if (t >= SPI_DATA_WIDTH) begin
				next_state = read_cmd;
			end
		end
	endcase
end
endmodule

module spi_register
#(
	parameter REG_DATA_WIDTH = 8,
	parameter REG_ADDR_WIDTH = 3,
	parameter REG_ADDR = 0
)(
`ifdef USE_POWER_PINS
	inout vcc, vss,
`endif
	//register interface
	inout reg_bus,
	input [REG_ADDR_WIDTH-1:0]reg_addr,
	input reg_dir,
	input reg_clk,
	output reg [REG_DATA_WIDTH-1:0]reg_data
);

//store elapsed time
reg [$clog2(REG_DATA_WIDTH)-1:0] t;
//keep track of time
always @(posedge reg_clk) begin
	if (t >= REG_DATA_WIDTH)
		t <= 0;
	else
		t <= t + 1;
end

always @* begin
	if (reg_addr == REG_ADDR) begin
		if (reg_dir) begin
			reg_data[t] = reg_bus;
		end else begin
			reg_bus = reg_data[t];
		end
	end
end
endmodule

`default_nettype wire
