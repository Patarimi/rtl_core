from myhdl import *

ACTIVE = 0
DirType = enum("RIGHT", "LEFT")


@block
def jc2(
    go_left: SignalType,
    go_right: SignalType,
    stop: SignalType,
    clk: SignalType,
    q: SignalType,
):
    """
    A bidirectional 4-bit Johnson counter with stop control.
    Parameters
    ----------
    go_left : input signal to shift left
    go_right : input signal to shift right
    stop : input signal to top counting
    clk : input free-running clock
    q : 4-bit counter output
    """
    dire = Signal(DirType.LEFT)
    run = Signal(False)

    @always(clk.posedge)
    def logic():
        if go_right == ACTIVE:
            dire.next = DirType.RIGHT
            run.next = True
        elif go_left == ACTIVE:
            dire.next = DirType.LEFT
            run.next = True
        if stop == ACTIVE:
            run.next = False

        if run:
            if dire == DirType.LEFT:
                q.next[4:1] = q[3:]
                q.next[0] = not q[3]
            else:
                q.next[3:] = q[4:1]
                q.next[3] = not q[0]

    return logic


if __name__ == "__main__":
    go_left, go_right, stop, clk = [Signal(not ACTIVE) for i in range(4)]
    q = Signal(intbv(0)[4:])
    jc2_inst = jc2(go_left, go_right, stop, clk, q)
    jc2_inst.convert(hdl="Verilog")
    jc2_inst.convert(hdl="VHDL")
