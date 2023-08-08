- Refer to Ramulator description **[1]** (Ramulator: A DRAM Simulator)

!!!!!WARNING!! First and foremost, you must unzip the files in the cputraces folder (as it appears in run.py)!

(1) Change timing parameter & compile: Edit configs/~.cfg, src/DDR4.h, then make clean, make -j4
 -> Even if the code is modified, run compile!!
(2) How to run the code: python run.py

Results (in this case, it is result/~.txt)
- IPC (cpu instruction number/cpu cycle number), read/write request# etc.
- cmd (RD/WR/PR)
- To measure DRAMPower, move the generated cmd~.txt file to the DRAMPower internal folder and proceed!!!!!!
 e.g.) cmd-trace-astar-chan-0-rank.txt

CAUTION!!!! => Consider the Cache configuration (L1L2, L3..), warmup_instr, etc., and adjust accordingly when running!

# References
- **[1]** https://github.com/CMU-SAFARI/ramulator
