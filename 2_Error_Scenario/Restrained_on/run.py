from multiprocessing import Pool
import sys
import os
import time

oecc = [1] # 0 : no-ecc, 1 : SEC (Hsiao)
fault = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] # SE_NE_NE=0, SE_SE_NE=1, SE_SE_SE=2, CHIPKILL_NE_NE=3, CHIPKILL_SE_NE=4, CHIPKILL_CHIPKILL_NE=5, DE_NE_NE=6, DE_DE_NE=7, DE_DE_DE=8, CHIPKILL_DE_NE=9
recc = [1] # 0 : AMD Chipkill, 1 : SSC-DEC, 2 : NO Rank-level ECC

for oecc_param in oecc:
    for fault_param in fault:
        for recc_param in recc:
            os.system("./Fault_sim_start {0:d} {1:d} {2:d} &".format(oecc_param, fault_param, recc_param))
