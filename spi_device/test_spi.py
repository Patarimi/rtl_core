import os
from cocotb_test.simulator import run
def test_spi():
	run(
		verilog_sources=["spi_device/spi_device.v"],
		toplevel="spi_device",
		module="spi_device_tb",
		timescale="1ns/1ps",
		work_dir=os.path.join(os.curdir, "spi_device"),
	)
