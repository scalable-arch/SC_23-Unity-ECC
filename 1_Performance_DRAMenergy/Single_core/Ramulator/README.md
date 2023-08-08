# Single-core Performance (Ramulator)
- Refer to Ramulator description **[1]** (Ramulator: A CPU Simulator)

# Getting Started
- First and foremost, you must **unzip the files in the cputraces folder** (as it appears in run.py)!
- Change timing parameter & compile: Edit configs/~.cfg, src/DDR4.h
- $ make clean
- $ make -j4
>> Even if the code is modified, run compile!!
- $ python run.py

# Results (in this case, it is result/~.txt)
- You can find the following contents in the corresponding result files
- IPC (cpu instruction number/cpu cycle number)
- Num of read/write requests
- Num of cmd (RD/WR/PR)

# DRAM Power implementation
- To measure DRAMPower, move the generated cmd~.txt file to the DRAMPower internal folder and proceed!!!!!!
>> e.g, cmd-trace-astar-chan-0-rank.txt

# Caution
- Consider the Cache configuration (L1L2, L3..), warmup_instr, etc., and adjust accordingly when running!

# References
- **[1]** https://github.com/CMU-SAFARI/ramulator
