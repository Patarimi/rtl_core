import cocotb
from cocotb.triggers import Timer, FallingEdge
from cocotb.clock import Clock


@cocotb.test()
async def fonctionnal_test(dut):
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())
    dut.rst_n.value = 0
    dut.stream_in.value = 1
    await Timer(1, units="ns")
    dut.rst_n.value = 1
    await Timer(512, units="ns")
    assert dut.dec_out.value == 255

