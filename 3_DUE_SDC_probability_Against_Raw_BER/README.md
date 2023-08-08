# Memory transfer block failure probability against Raw BER (Bit-Error-Ratio) (Figure 10)

# Overview
![An overview of the evaluation](https://github.com/xyz123479/SC_23_Unity-ECC/blob/main/3_DUE_SDC_probability_Against_Raw_BER/Unity%20ECC_Bit%20error.png)

# Code flows (Fault_sim.cpp)
- 1. Reading H-Matrix.txt (OD-ECC)
- 2. Setting output function name: ~.S files
- 3. **(Start loop)** DDR5 ECC-DIMM setup
- 4. Initialize all data in 10 chips to 0: Each chip has 136 bits of data (128-bit) + redundancy (8-bit).
- 5. Error injection: Errors occur based on the BER. **(Caution!) This evaluation has no fault!**
- 6. Apply OD-ECC **[2]**: Implementation
>> Apply the Hamming SEC code of (136, 128) to each chip.

>> After running OD-ECC, the redundancy of OD-ECC does not come out of the chip (128-bit data).
- 7. Apply RL-ECC
>> Run (80, 64) RL-ECC by bundling two beats.

>> 16 Burst Length (BL) creates one memory transfer block (64B cacheline + 16B redundancy)

>> In DDR5 x4 DRAM, because of internal prefetching, only 64bit of data from each chip's 128bit data is actually transferred to the cache

>> For this, create two memory transfer blocks for 128-bit data and compare them (choose worst one)
- 8. Report CE/DUE/SDC results
- 9. **(End loop)** Derive final results

# DIMM configuration (per-sub channel)
- DDR5 ECC-DIMM
- Num of rank: 1
- Beat length: 40 bit
- Burst length: 16
- Num of data chips: 8
- Num of parity chips: 2
- Num of DQ: 4 (x4 chip)

# ECC configuration
- OD-ECC (2 options): No OD-ECC, (136, 128) Hamming SEC code **[1]**
- RL-ECC (3 options): No RL-ECC, [10, 8] Chipkill (using Reed-Solomon code), [10, 8] Unity ECC

# BER scaling
- 10<sup>-9</sup> ~ 10<sup>-2</sup>

# Getting Started
- $ make clean
- $ make
- $ python run.py

# Answer (.S files)
- Errors can be injected randomly, thus there may be slight discrepancies each time it is executed
  
# Additional Information
- NE: no error
- CE: detected and corrected error
- DUE: detected but uncorrected error
- SDC: Silent Data Corruption
- The codeword is in the default all-zero state (No-error state). In other words, the original message is all-zero
- Thus, there's no need to encode
- Reason: Because it's a Linear code, the same syndrome appears regardless of 1->0 or 0->1 error at the same location

# References
- **[1]** Hamming, Richard W. "Error detecting and error correcting codes." The Bell system technical journal 29.2 (1950): 147-160.
- **[2]** M. JEDEC. 2022. DDR5 SDRAM standard, JESD79-5B𝑣 1.20.

