test-%:
	make -C $*

module=$(shell find * -maxdepth 0 -type d)
test-module=$(module:%=test-%)

.PHONY: test-all
test-all: $(test-module)

.PHONY:clean
clean:
	@-rm -r ./*.res ./*.out ./*.vcd

