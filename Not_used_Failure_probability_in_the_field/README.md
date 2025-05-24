# Failure probability in the field (Not used in [SC'23] Unity ECC)

# Prerequisite
- You need to read the Fault-sim (TACO'15) paper **[2]**
- This exercise applied the **Fault-masking** method from this paper, and the code is written in a simpler manner

# Code flows (main.cc, Tester.cc)
- 1. **(Start loop)** Calculate the future time point when the fault is expected to occur by inputting the FIT value into the Poisson function. (Tester.cc -> TesterSystem::advance)
- 2. If the expected time point is after the interval used for reliability measurement, we bypass the fault-masking and return to step '1'.
- 3. For instance, in this evaluation, the reliability measurement period is 15 years. If the fault occurs 10 years later, we skip the fault-masking process.
- 4. Scrub the soft error.
- 5. If the time point falls within the reliability measurement interval, we apply fault-masking and record that time. (Tester.cc -> hr += advance(dg->getFaultRate());)
- 6. Generate a fault.
- 7. Based on the fault, generate an error and proceed with decoding using **On-Die ECC (OD-ECC) and Rank-Level ECC(RL-ECC)**.
- 8. **(End loop)** Record the results of Retire, DUE, and SDC, and go back to step 1 to repeat a certain number of times.
- 9. For actual experiments, it is recommended to do it more than 1,000,000 times to ensure reliability.

# DIMM configuration (main.cc, Config.hh)
- DDR5 ECC-DIMM
- Num of rank: 1
- Beat length: 40 bit
- Burst length: 16
- Num of data chips: 8
- Num of parity chips: 2
- Chip capacity: 16Gb
- Num of DQ: 4 (x4 chip)

# ECC configuration
- OD-ECC: (136, 128) Hamming SEC code **[1]**
- RL-ECC: (80,64) Chipkill-correct ECC

# Fault model configuration (FaultRateInfo.hh)
- **[3]** DDR2 Jaguar system

# Getting Started
- $ make clean
- $ make
- $ python run.py

# References
- **[1]** Hamming, Richard W. "Error detecting and error correcting codes." The Bell system technical journal 29.2 (1950): 147-160.
- **[2]** Nair, Prashant J., David A. Roberts, and Moinuddin K. Qureshi. "Faultsim: A fast, configurable memory-reliability simulator for conventional and 3d-stacked systems." ACM Transactions on Architecture and Code Optimization (TACO) 12.4 (2015): 1-24.
- **[3]** Sridharan, Vilas, and Dean Liberty. "A study of DRAM failures in the field." SC'12: Proceedings of the International Conference on High Performance Computing, Networking, Storage and Analysis. IEEE, 2012.
