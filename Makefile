#build 32 bits in ubuntu
# I can't build in centos
TARGET := 32

# See LICENSE.txt for license details.
# use g++ from /tools/batonroot/rodin/devkits/lnx64/gcc-8.3.0/bin/
# if not statically link, export LD_LIBRARY_PATH=/tools/batonroot/rodin/devkits/lnx64/gcc-8.3.0/lib64/:$LD_LIBRARY_PATH
SERIAL = 1

#CXX_FLAGS += -std=c++11 -O3 -Wall
#CXX_FLAGS += -std=c++11 -O3 -Wall -static
# I don't see 64bits addr in the trace, while neighbor use them. need to try 32 bit version
# I use -g so that I can see the target function in objdump
#CXX_FLAGS += -m32 -std=c++11 -g -Wall -static 
CXX_FLAGS += -std=c++11 -g -Wall -static 
#CXX_FLAGS +=  -std=c++11 -g -Wall -static 
PAR_FLAG = -fopenmp
#LIBDIR = /tools/batonroot/rodin/devkits/lnx32/gcc-6.2.0/lib/
LIBDIR = 
#LDFLAGS = -m32 -L$(LIBDIR)
#LDFLAGS = -m32 
LDFLAGS = 
LDLIBS = 

ifeq ($(TARGET),32)
  CXX_FLAGS += -m32
  LDFLAGS   += -m32 
endif

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
	$(CXX) $(CXX_FLAGS) $< -o $@ $(LDFLAGS) $(LDLIBS)

# Testing
include test/test.mk

# Benchmark Automation
include benchmark/bench.mk


.PHONY: clean
clean:
	rm -f $(SUITE) test/out/*
