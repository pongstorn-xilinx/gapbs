# See LICENSE.txt for license details.
# use g++ from /tools/batonroot/rodin/devkits/lnx64/gcc-8.3.0/bin/
# if not statically link, export LD_LIBRARY_PATH=/tools/batonroot/rodin/devkits/lnx64/gcc-8.3.0/lib64/:$LD_LIBRARY_PATH
SERIAL = 1

#CXX_FLAGS += -std=c++11 -O3 -Wall
#CXX_FLAGS += -std=c++11 -O3 -Wall -static
CXX_FLAGS += -std=c++11 -g -Wall -static
PAR_FLAG = -fopenmp

ifneq (,$(findstring icpc,$(CXX)))
	PAR_FLAG = -openmp
endif

ifneq (,$(findstring sunCC,$(CXX)))
	CXX_FLAGS = -std=c++11 -xO3 -m64 -xtarget=native
	PAR_FLAG = -xopenmp
endif

ifneq ($(SERIAL), 1)
	CXX_FLAGS += $(PAR_FLAG)
endif

KERNELS = bc bfs cc cc_sv pr pr_spmv sssp tc
SUITE = $(KERNELS) converter

.PHONY: all
#all: $(SUITE); $(info $$CXX_FLAGS is [${CXX_FLAGS}])
all: $(SUITE); $(info $$CXX is [${CXX}])
	

% : src/%.cc src/*.h
	$(CXX) $(CXX_FLAGS) $< -o $@

# Testing
include test/test.mk

# Benchmark Automation
include benchmark/bench.mk


.PHONY: clean
clean:
	rm -f $(SUITE) test/out/*
