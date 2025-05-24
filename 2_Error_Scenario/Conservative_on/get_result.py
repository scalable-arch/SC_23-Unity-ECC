import numpy as np
from pandas import DataFrame

OECC = ['RAW_', 'HSIAO_']
RECC = ['AMDCHIPKILL_','SSC_DEC_']
FAULT = ['SE_NE_NE','SE_SE_NE', 'SE_SE_SE', 'CHIPKILL_NE_NE', 'CHIPKILL_SE_NE', 'CHIPKILL_CHIPKILL_NE', 'DE_NE_NE', 'DE_DE_NE', 'DE_DE_DE', 'CHIPKILL_DE_NE']
 
for oecc in OECC:
    for recc in RECC:
        for fault in FAULT:
            name = './'+oecc+recc+fault+'.S'
            f = open(name,'r')
            for i in range(6):
                f.readline()
            CE = int(f.readline().split(": ")[1])
            DUE = int(f.readline().split(": ")[1])
            SDC = int(f.readline().split(": ")[1])
            TOT = CE+DUE+SDC
            print(round(CE/TOT*100,1),round(DUE/TOT*100,1),round(SDC/TOT*100,1))
