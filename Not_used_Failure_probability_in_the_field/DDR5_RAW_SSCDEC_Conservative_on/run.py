import sys
import os
import time

runNum=1000000000 # 실행 횟수

os.system("./test.out 1 {0:d} 0 S &".format(runNum)) # 1 : AMDCHIPKILL 사용, 1000000000 : 실행 횟수, 0 : module 설정 (DDR4, channel 크기 등등....)