from math import atan
import cocotb
from cocotb.triggers import Timer
from atan_table import f_point

@cocotb.test()
async def test_cordic(dut):
	res = 16
	for i in range(res-2):
		dut.step.value = i
		await Timer(1, "ns")
		assert int(dut.atan.value) == f_point(atan(2**-i), res-2)
    
