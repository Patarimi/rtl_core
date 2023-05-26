from myhdl import *
from johnson_counter import jc2

ACTIVE, INACTIVE = bool(0), bool(1)


@block
def test_counter():
    goLeft, goRight, stop, clk = [Signal(INACTIVE) for i in range(4)]
    q = Signal(intbv(0)[4:])

    @always(delay(10))
    def clkgen():
        clk.next = not clk

    jc2_inst = jc2(goLeft, goRight, stop, clk, q)

    @instance
    def stimulus():
        for i in range(3):
            yield clk.negedge
        for sig, nrcycles in ((goLeft, 10), (stop, 3), (goRight, 10)):
            sig.next = ACTIVE
            yield clk.negedge
            sig.next = INACTIVE
            for i in range(nrcycles - 1):
                yield clk.negedge
        raise StopSimulation

    @instance
    def monitor():
        print("goLeft goRight stop clk q")
        print("------------------------------")
        while True:
            yield clk.negedge
            yield delay(1)
            pStr = str(
                "{:^6} {:^6} {:^5} ".format(int(goLeft), int(goRight), int(stop))
            )
            yield clk.posedge
            pStr += " C "
            yield delay(1)
            pStr += " " + bin(q, 4)
            print(pStr)

    return clkgen, jc2_inst, stimulus, monitor


if __name__ == "__main__":
    simInst = test_counter()
    simInst.config_sim(trace=True, tracebackup=False)
    simInst.run_sim()
