import cocotb
from cocotb.triggers import Timer, FallingEdge
from cocotb.clock import Clock


@cocotb.test()
async def fonctionnal_test(dut):
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())
    dut.rst_n.value = 0
    dut.din.value = 50
    await Timer(1, units="ns")
    dut.rst_n.value = 1
    await Timer(512, units="ns")
    for it in range(3):
        cnt = 0
        for v in range(256):
            await FallingEdge(dut.clk)
            cnt += dut.dout.value
        assert cnt == 128 or cnt == 129
