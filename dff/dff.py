from myhdl import *


@block
def dff(q: SignalType, d: SignalType, clk: SignalType):
    """
    A simple D flip-flop.
    :param q: Output re-synced data
    :param d: Input data
    :param clk: Clock signal
    :return:
    """

    @always(clk.posedge)
    def logic():
        q.next = d

    return logic
