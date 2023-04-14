import cocotb
from cocotb.triggers import Timer, FallingEdge
from cocotb.clock import Clock


@cocotb.test()
async def fonctionnal_test(dut):
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())
    dut.reset.value = 1
    await Timer(1, units="ns")
    dut.reset.value = 0
    await Timer(20, units="ns")
    await FallingEdge(dut.clk)
    dut._log.info(f"{dut.count.value=}")
    assert dut.count.value == 21
