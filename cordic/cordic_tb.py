from math import atan, cos, pi, sin
import cocotb
from cocotb.triggers import Timer, ClockCycles
from cocotb.clock import Clock
from atan_table import f_point


def to_float(fixed: int, res: int, pos: int = 2) -> float:
    if int(fixed) > 2 ** (res):
        return round(int(fixed) * 2 ** (pos - res) - 8, 3)
    return round(int(fixed) * 2 ** (pos - res), 3)


@cocotb.test()
async def test_cordic_core(dut):
    res = dut.BITS.value
    step = dut.STEPS.value
    buff = (pi / 3, 1, 0)
    print(buff)
    dut.Bin.value = f_point(buff[0], res - 2)
    dut.Xin.value = f_point(buff[1], res - 2)
    dut.Yin.value = f_point(buff[2], res - 2)
    for i in range(step - 1):
        dut.step.value = i
        if buff[0] > 0:
            tmp = (
                buff[0] - atan(2**-i),
                buff[1] - buff[2] / 2**i,
                buff[1] / 2**i + buff[2],
            )
        else:
            tmp = (
                buff[0] + atan(2**-i),
                buff[1] + buff[2] / 2**i,
                -buff[1] / 2**i + buff[2],
            )
        buff = tmp
        await Timer(1, "ns")
        assert int(dut.atan) == f_point(atan(2**-i), res-2)
        assert abs(int(dut.Xout) - f_point(buff[1], res-2)) <= 2
        assert abs(int(dut.Yout) - f_point(buff[2], res-2)) <= 2
        print(f"{dut.Xin.value=}")
        print(f"{dut.Yin.value=}")
        print(f"{dut.Bin.value=}")
        
        dut.Bin.value = dut.Bout.value
        dut.Xin.value = dut.Xout.value
        dut.Yin.value = dut.Yout.value


@cocotb.test()
async def test_cordic_pipelined(dut):
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())
    for angle in (pi / 3,):
        res = dut.BITS.value
        step = dut.STEPS.value
        dut.angle.value = f_point(angle, res - 2)
        await ClockCycles(dut.clk, 3)        
        assert abs(int(dut.sinus) - f_point(sin(angle) / 0.6072540283203125, res-2)) <= 2
        assert abs(int(dut.cosinus) - f_point(cos(angle) / 0.6072540283203125, res-2)) <= 2
