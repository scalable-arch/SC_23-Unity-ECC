import numpy as np
from pandas import DataFrame

OECC = ['NoOECC_', 'Hsiao_','SEC-BADAEC_']
FAULT = ['badae_badae','de_badae','de_de','chipkill_badae','chipkill_de','chipkill_chipkill']
 
for ecc in OECC:
    for fault in FAULT:
        name = './'+ecc+fault+'.S'
        f = open(name,'r')
        for i in range(6):
            f.readline()
        CE = int(f.readline().split(": ")[1])
        DUE = int(f.readline().split(": ")[1])
        SDC = int(f.readline().split(": ")[1])
        TOT = CE+DUE+SDC
        print(round(CE/TOT*100,1),round(DUE/TOT*100,1),round(SDC/TOT*100,1))
