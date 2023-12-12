import sys
import os
import time

for i in range(30):
    os.system("./nogada DFS_based_SSC_DEC_result_{0:02d}.txt {1:d} &".format(i,i))
    time.sleep(2) # rand seed 값 다르게 하기 위해 2초 간격으로 실행 시작하기
