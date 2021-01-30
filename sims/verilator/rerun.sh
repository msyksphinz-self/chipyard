#!/bin/sh

REPO_DIR=`git rev-parse --show-toplevel`

verilator --cc --exe -O3 -CFLAGS \
          " -O1 -std=c++11 -I${RISCV}/include -I${REPO_DIR}/tools/DRAMSim2 -D__STDC_FORMAT_MACROS  -DTEST_HARNESS=VTestHarness -DVERILATOR" -CFLAGS "-I${REPO_DIR}/sims/verilator/generated-src/chipyard.TestHarness.MSRHConfig -include ${REPO_DIR}/sims/verilator/generated-src/chipyard.TestHarness.MSRHConfig/chipyard.TestHarness.MSRHConfig.plusArgs -include ${REPO_DIR}/sims/verilator/generated-src/chipyard.TestHarness.MSRHConfig/verilator.h" \
          -LDFLAGS " -L${REPO_DIR}/sims/verilator -lpthread" \
          ${RISCV}/lib/libfesvr.a \
          ${REPO_DIR}/tools/DRAMSim2/libdramsim.a \
          --timescale 1ns/1ps \
          --top-module TestHarness \
          -Wno-fatal \
          --assert \
          --output-split 10000 \
          --output-split-cfuncs 100 \
          --max-num-width 1048576 \
          -f ${REPO_DIR}/sims/verilator/generated-src/chipyard.TestHarness.MSRHConfig/sim_files.common.f \
          ${REPO_DIR}/sims/verilator/generated-src/chipyard.TestHarness.MSRHConfig/chipyard.TestHarness.MSRHConfig.top.v \
          ${REPO_DIR}/sims/verilator/generated-src/chipyard.TestHarness.MSRHConfig/chipyard.TestHarness.MSRHConfig.harness.v \
          ${REPO_DIR}/sims/verilator/generated-src/chipyard.TestHarness.MSRHConfig/chipyard.TestHarness.MSRHConfig.top.mems.v \
          ${REPO_DIR}/sims/verilator/generated-src/chipyard.TestHarness.MSRHConfig/chipyard.TestHarness.MSRHConfig.harness.mems.v \
          +define+PRINTF_COND=\$c\(\"verbose\",\"\&\&\"\,\"done_reset\"\) \
          +define+STOP_COND=\$c\(\"done_reset\"\) \
          -o ${REPO_DIR}/sims/verilator/simulator-chipyard-MSRHConfig-debug \
          --trace \
    	  --trace-fst \
    	  --trace-params \
    	  --trace-structs \
    	  --trace-threads 4 \
    	  --trace-underscore \
          -Mdir ${REPO_DIR}/sims/verilator/generated-src/chipyard.TestHarness.MSRHConfig/chipyard.TestHarness.MSRHConfig.debug \
          -CFLAGS "-include ${REPO_DIR}/sims/verilator/generated-src/chipyard.TestHarness.MSRHConfig/chipyard.TestHarness.MSRHConfig.debug/VTestHarness.h"

make VM_PARALLEL_BUILDS=1 -C ${REPO_DIR}/sims/verilator/generated-src/chipyard.TestHarness.MSRHConfig/chipyard.TestHarness.MSRHConfig.debug -f VTestHarness.mk
