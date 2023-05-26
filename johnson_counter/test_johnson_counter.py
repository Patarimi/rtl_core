from myhdl import *
from johnson_counter import jc2

ACTIVE, INACTIVE = bool(0), bool(1)


@block
def test_counter():
    go_left, go_right, stop, clk = [Signal(INACTIVE) for i in range(4)]
    q = Signal(intbv(0)[4:])

    @always(delay(10))
    def clk_gen():
        clk.next = not clk

    jc2_inst = jc2(go_left, go_right, stop, clk, q)

    @instance
    def stimulus():
        for i in range(3):
            yield clk.negedge
        for sig, nr_cycles in ((go_left, 10), (stop, 3), (go_right, 10)):
            sig.next = ACTIVE
            yield clk.negedge
            sig.next = INACTIVE
            for i in range(nr_cycles - 1):
                yield clk.negedge
        raise StopSimulation

    @instance
    def monitor():
        print("go_left go_right stop clk q")
        print("------------------------------")
        while True:
            yield clk.negedge
            yield delay(1)
            pStr = f"{int(go_left):^6} {int(go_right):^6} {int(stop):^5} "
            yield clk.posedge
            pStr += " C "
            yield delay(1)
            pStr += " " + bin(q, 4)
            print(pStr)

    return clk_gen, jc2_inst, stimulus, monitor


if __name__ == "__main__":
    simInst = test_counter()
    simInst.config_sim(trace=True, tracebackup=False)
    simInst.run_sim()
