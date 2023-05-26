from myhdl import *
from random import randrange
from dff import dff


@block
def test_dff():
    q, d, clk = [Signal(bool(0)) for i in range(3)]

    dff_inst = dff(q, d, clk)

    @always(delay(10))
    def clkgen():
        clk.next = not clk

    @always(clk.negedge)
    def stimulus():
        d.next = randrange(2)

    @always(clk.posedge)
    def monitor():
        assert q == d

    return dff_inst, clkgen, stimulus


def simulate(time_steps):
    sim_inst = test_dff()
    sim_inst.config_sim(trace=True, tracebackup=False)
    sim_inst.run_sim(time_steps, quiet=0)


def convert():
    q, d, clk = [Signal(bool(0)) for i in range(3)]
    conv_inst = dff(q, d, clk)  # , 'Verilog')
    conv_inst.convert(hdl="Verilog")
    conv_inst.convert(hdl="VHDL")


if __name__ == "__main__":
    convert()
    simulate(2000)
