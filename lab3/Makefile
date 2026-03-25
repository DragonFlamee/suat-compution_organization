VERILATOR ?= verilator
TOP       ?= sumfoanarithmeticsequence
TB        ?= sim/sumfoanarithmeticsequence.sv
RTL_SRCS  := $(wildcard rtl/*.v)

# Keep warnings actionable but avoid noisy style warnings.
VERILATOR_FLAGS := --top-module $(TOP) -Irtl -Wno-DECLFILENAME -Wno-UNUSEDSIGNAL -Wno-GENUNNAMED

.PHONY: all lint build run clean

all: run

lint:
	$(VERILATOR) --lint-only $(VERILATOR_FLAGS) $(TB) $(RTL_SRCS)

build:
	$(VERILATOR) --binary $(VERILATOR_FLAGS) $(TB) $(RTL_SRCS)

run: build
	./obj_dir/V$(TOP)

clean:
	rm -rf obj_dir
