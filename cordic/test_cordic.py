import os
from cocotb_test.simulator import run
def test_cordic_pipelined():
	run(
		verilog_sources=["cordic/cordic.v"],
		toplevel="cordic_pipelined",
		module="cordic_tb",
		timescale="1ns/1ps",
		work_dir=os.path.join(os.curdir, "cordic"),
	    testcase="test_cordic_pipelined"
	)
	
def test_cordic_core():
	run(
		verilog_sources=["cordic/cordic.v"],
		toplevel="cordic_core",
		module="cordic_tb",
		timescale="1ns/1ps",
		work_dir=os.path.join(os.curdir, "cordic"),
	    testcase="test_cordic_core"
	)
