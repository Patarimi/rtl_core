import cocotb
from cocotb.triggers import Timer, FallingEdge
from cocotb.clock import Clock


@cocotb.test()
async def fonctionnal_test_1(dut):
    await fonctionnal_test_n(dut, 1)


@cocotb.test()
async def fonctionnal_test_2(dut):
    await fonctionnal_test_n(dut, 2)


async def fonctionnal_test_n(dut, incr):
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())
    dut.reset.value = 1
    dut.incr.value = incr
    await Timer(1, units="ns")
    dut.reset.value = 0
    await Timer(20, units="ns")
    await FallingEdge(dut.clk)
    dut._log.info(f"{dut.count.value=}")
    assert dut.count.value == 21 * incr
