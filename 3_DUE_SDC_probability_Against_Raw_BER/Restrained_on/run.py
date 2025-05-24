import sys
import os
import time

oecc = [0, 1] # 0 : no-ecc, 1 : SEC (Hsiao)
# BER(Bit-Error-Rate) = 10^-3, 3.3 * 10^-3, 10^-4, 3.3 * 10^-4, 10^-5, 3.3 * 10^-5, 10^-6, 3.3 * 10^-6, 10^-7, 3.3 * 10^-7, 10^-8, 3.3 * 10^-8, 10^-9
ber = [100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000]
recc = [0, 1, 2] # 0 : AMD Chipkill, 1 : SSC-DEC, 2 : RECC 없음(RAW)

for oecc_param in oecc:
    for ber_param in ber:
        for recc_param in recc:
            os.system("./Reliability_Against_Raw_BER_sim_start {0:d} {1:d} {2:d} &".format(oecc_param, ber_param, recc_param))