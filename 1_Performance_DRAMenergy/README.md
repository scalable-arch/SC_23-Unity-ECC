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
