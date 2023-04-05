%-test:
	@iverilog -l ./$*/$*.v ./$*/$*_tb.v -o ./$*/$*.out
	@# fails if no error message are present in the bench.
	@if ! grep -q "failed" ./$*/$*_tb.v; then exit 1; fi
	@./$*/$*.out >> ./$*/$*.res
	@# fails if error message found in the simulation log.
	@if grep -q "failed" ./$*/$*.res; then echo "$* failed"; exit 1; fi
