from math import atan, cos, pi
import cocotb
from cocotb.triggers import Timer
from atan_table import f_point


def to_float(fixed: int, res: int, pos: int = 2) -> float:
    if int(fixed) > 2 ** (res):
        return round(int(fixed) * 2 ** (pos - res) - 8, 3)
    return round(int(fixed) * 2 ** (pos - res), 3)


"""@cocotb.test()
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
        assert to_float(dut.atan, res) == round(atan(2**-i), 3)
        assert to_float(dut.Xout, res) == round(buff[1], 3)
        assert to_float(dut.Yout, res) == round(buff[2], 3)
        dut.Bin.value = dut.Bout.value
        dut.Xin.value = dut.Xout.value
        dut.Yin.value = dut.Yout.value"""

@cocotb.test()
async def test_cordic_pipelined(dut):
	angle = pi/3
	res = dut.BITS.value
	step = dut.STEPS.value
	dut.angle.value = f_point(angle, res - 2)
	await Timer(4, "ns")
	assert to_float(dut.sinus, res) == round(cos(pi/2-angle)/0.60725293651701, 3)
	assert to_float(dut.cosinus, res) == round(cos(angle)/0.60725293651701, 3)
	
