module=$(shell find * -maxdepth 0 -type d)
test-module=$(module:%=test-%)

.PHONY: test-all
test-all: $(test-module)

test-%:
	make -C $*

clean-module=$(module:%=clean-%)

.PHONY:clean-all
clean-all: $(clean-module)

clean-%:
	make -C $* clean

