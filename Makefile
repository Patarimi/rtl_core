test-%:
	@echo "testing $*"
	@iverilog -l ./$*/$*.v ./$*/$*_tb.v -s bench -o ./$*/$*.out
	@# fails if no error message are present in the bench.
	@if ! grep -q "failed" ./$*/$*_tb.v; then exit 1; fi
	@#remove old res files
	@-rm ./$*/*.res
	@./$*/$*.out >> ./$*/$*.res
	@# fails if error message found in the simulation log.
	@if grep -q "failed" ./$*/$*.res; then echo "   $* failed"; exit 1; else echo "   $* succeed !"; fi

module=$(shell find * -maxdepth 0 -type d)
test-module=$(module:%=test-%)

.PHONY: test-all
test-all: $(test-module)

.PHONY:clean
clean:
	@-rm -r ./*.res ./*.out ./*.vcd

