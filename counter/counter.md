*counter*

Simple counter. Increase _count_ on each rising edge of _clk_ by _incr_.

Parameter are:
	- BITS: width of the output counter
Input are:
	- clk: input clock.
	- reset: reset counter output to 0 on next clk tick.
	- incr: increment. On each rise edge of clk, incr is added to counter output

Output are:
	- count: cumulative value reach so far.
	

