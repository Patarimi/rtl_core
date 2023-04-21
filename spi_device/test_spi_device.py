import cocotb
from cocotb.triggers import Timer, FallingEdge, RisingEdge
from cocotb.clock import Clock


@cocotb.test()
async def test_device(dut):
    data = "01101010"
    addr = "001"
    w_nr = "1"
    trame = get_trame(w_nr, addr, data)
    cocotb.start_soon(Clock(dut.spi_clk, 1, units="ns").start())
    dut.spi_sel.value = 1
    await Timer(1, units="ns")
    dut.spi_sel.value = 0
    await program(trame, dut)
    await FallingEdge(dut.spi_clk)
    await RisingEdge(dut.spi_clk)
    assert dut.reg_dir.value == int(w_nr, 2)
    assert dut.reg_addr.value == int(addr[::-1], 2)


def get_trame(w_nr, addr, data):
    return w_nr + addr + "0000" + data


async def program(data, dut):
    for i in range(16):
        await RisingEdge(dut.spi_clk)
        dut.spi_mosi.value = int(data[i], 2)
        if i > 8:
            await FallingEdge(dut.spi_clk)
            assert dut.reg_bus.value == int(data[i], 2)
