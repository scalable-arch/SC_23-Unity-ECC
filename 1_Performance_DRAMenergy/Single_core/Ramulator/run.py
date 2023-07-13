import sys
import os
import time

# 아래 꺼는 mapping option 해놓은거 주석 달아놓음!
#os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_bzip2.txt --mapping mappings/row_interleaving_16R_2B_3BG_11C.map cputraces/401.bzip2 &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_bzip2.txt cputraces/401.bzip2 &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_gcc.txt cputraces/403.gcc &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_mcf.txt cputraces/429.mcf &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_milc.txt cputraces/433.milc &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_zeusmp.txt cputraces/434.zeusmp &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_gromcas.txt cputraces/435.gromacs &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_cactusADM.txt cputraces/436.cactusADM &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_leslie3d.txt cputraces/437.leslie3d &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_namd.txt cputraces/444.namd &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_gobmk.txt cputraces/445.gobmk &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_dealII.txt cputraces/447.dealII &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_soplex.txt cputraces/450.soplex &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_hmmer.txt cputraces/456.hmmer &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_sjeng.txt cputraces/458.sjeng &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_GemsFDTD.txt cputraces/459.GemsFDTD &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_libquantum.txt cputraces/462.libquantum &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_h264ref.txt cputraces/464.h264ref &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_lbm.txt cputraces/470.lbm &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_omnetpp.txt cputraces/471.omnetpp &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_astar.txt cputraces/473.astar &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_wrf.txt cputraces/481.wrf &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_sphinx3.txt cputraces/482.sphinx3 &")
os.system("./ramulator configs/DDR4-config.cfg --mode=cpu --stats result/DDR4_16Gb_x4_4800/LP_wET_xalancbmk.txt cputraces/483.xalancbmk &")

"""
 -> LP는 Low performance benchmark 라는 뜻이다.
 -> wET는 with Early Termination 이라는 뜻이다.
 -> xalanbmk은 benchmark 이름이다.
 -> 이때 configs/~.cfg 파일에서 record_cmd_trace = on으로 변경해서 돌려야 한다. (이래야 cmd~.cmdtrace 결과파일 나온다.)
 -> 이때 --mapping mappings/row_interleaving_16R_2B_3BG_11C.map cputraces/경로에 있는 파일들이 gz으로 압축되어 있다면, 압축을 해제하고 실행하자.
 -> 이때 result 폴더를 만들고 실행하자.
 -> --mapping 옵션은 address mapping을 변경하고 싶을때 넣는 옵션이다. 해당 경우에는 mappings/row_interleaving_16R_2B_3BG_11C.map 파일을 적용하여 address mapping 적용 (없을시 default로 실행. Memory.h 코드 내용 참조!)
"""