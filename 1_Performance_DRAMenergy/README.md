# No Multi-core

- I'm not uploaded Multi-core code (Gem5 + Ramulator)
- It has too large sizes (14GB...)

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


# Getting started
- !!!!!주의!! 일단 첫번째로 다음 경로의 압축을 폴어야 함.
(1) benchspec/CPU2006에 있는 파일들의 압축을 풀어야 한다 (run.py에 있는 모양대로 나옴!)

(2) build

- gem5_ramulator
- gem5_v20.1_ramulator
- ext/ramulator/Ramulator/src/DDR4.h 수정
- scons ./build/X86/gem5.opt -j 20

(3) DRAM config

- DDR4 config 수정
- script/ramulator_config/DDR4.cfg
- script/gem5_multicore/DDR4_1GB_GEM5_Multicore_backup.cfg

(4) script 실행

- script 실행
- python gem5.py -f gem5_multicore/DDR4_1GB_GEM5_Multicore.cfg
- 결과: script/out/~167.result => active/dram cycle, IPC, request, hit/miss, conflict 등
