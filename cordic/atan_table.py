import math
from sys import argv


def f_point(n: float, shift: int):
    """
    Convert a float to a fixed point integer.
    """
    return int(round(n * 2**shift, 0))


def verilog_b(n: float, resolution: int):
    """
    Convert a float to a string representing a fixed point integer.
    """
    return f"{resolution}'b{f_point(n,resolution-2):>0{resolution}b}"


if __name__ == "__main__":
    try:
        resolution = int(argv[1])
    except IndexError:
        print("Please give the resolution.")
        quit()
    cumul = 1
    for i in range(resolution):
        atan_i = math.atan(2 ** (-i))
        if atan_i < 2 ** (2 - resolution):
            print(f"required STEPS: {i}")
            break
        print(f"{int(resolution/4)}'h{i:x} : atan <= {verilog_b(atan_i, resolution)};")
        cumul *= 1 / math.sqrt(1 + 2 ** (-2 * i))
    print(f"Cumul: {verilog_b(cumul, resolution)}")
    print(f"pi  ={verilog_b(math.pi, resolution)}")
    print(f"pi/2={verilog_b(math.pi/2, resolution)}")
