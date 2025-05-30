# No Multi-core

- I'm not uploaded Multi-core code **(Gem5 + Ramulator)**
- It has too large sizes (14GB...)
- Below is the description and execution method related to Multi-core

# Mix-base
- Low (6 applications): bzip2, GCC, dealII, omnetpp, wrf, xalancbmk
- High (4 applications): mcf, cactusADM, leslie3d, libquantum

# 9 mix workloads (4-core)
- ('L') mix1: gcc, dealII, wrf, xalancbmk
- ('L') mix2: bzip2, gcc, omnetpp, xalancbmk
- ('L') mix3: gcc, dealII, omnetpp, leslie3d
- ('L') mix4: gcc, dealII, xalancbmk, libquantum
- ('M') mix5: bzip2, wrf, mcf, cactusADM
- ('M') mix6: bzip2, xalancbmk, cactusADM, libquantum
- ('H') mix7: bzip2, mcf, cactusADM, leslie3d
- ('H') mix8: wrf, mcf, cactusADM, libquantum
- ('H') mix9: mcf, cactusADM, leslie3d, libquantum

# Method of measuring IPC (4-core)
- Calculated the IPC for each of the 4-cores and then took the **average of the 4 IPCs**
- **Note!** It's not the sum of the instructions for the 4-cores divided by the number of cycles!
- It calculates the IPC for each core and then takes the average

# Getting started
- !!!!!WARNING!! First and foremost, the following path's compression must be unzip
- (1) You must unzip the files in benchspec/CPU2006 (as it appears in run.py)!
- (2) Build
>> $ cd gem5_ramulator

>> $ cd gem5_v20.1_ramulator

>> Modify ext/ramulator/Ramulator/src/DDR4.h

>> $ scons ./build/X86/gem5.opt -j 20
- (3) DRAM config
>> Modify DDR4 config

>> $ cd script/ramulator_config/DDR4.cfg

>> $ cd script/gem5_multicore/DDR4_1GB_GEM5_Multicore_backup.cfg
- (4) Run script
>> Execute script

>> $ python gem5.py -f gem5_multicore/DDR4_1GB_GEM5_Multicore.cfg

>> Results: script/out/~167.result => active/dram cycle, IPC, request, hit/miss, conflict, etc.
