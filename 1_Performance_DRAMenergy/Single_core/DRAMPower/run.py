import sys
import os
import time

os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-bzip2-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_bzip2.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-gcc-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_gcc.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-mcf-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_mcf.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-milc-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_milc.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-zeusmp-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_zeusmp.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-gromacs-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_gromacs.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-cactusADM-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_cactusADM.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-leslie3d-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_leslie3d.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-namd-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_namd.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-gobmk-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_gobmk.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-dealII-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_dealII.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-soplex-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_soplex.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-hmmer-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_hmmer.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-sjeng-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_sjeng.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-GemsFDTD-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_GemsFDTD.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-libquantum-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_libquantum.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-h264ref-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_h264ref.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-lbm-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_lbm.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-omnetpp-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_omnetpp.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-astar-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_astar.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-wrf-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_wrf.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-sphinx3-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_sphinx3.txt &")
os.system("./drampower -m memspecs/MICRON_16Gb_DDR4-4800_4bit_A.xml -c result/Dongwhee/DDR4_16Gb_x4_4800/cmd-trace-xalancbmk-chan-0-rank-0.txt -r > result/Dongwhee/DDR4_16Gb_x4_4800/LP_wET_xalancbmk.txt &")


"""
 -> 이때 Gem5_ramulator 에서 나왔던 cmd~.txt 파일을 result/Dongwhee/ 경로로 옮긴 다음에 실행해야 한다.
 -> 결과 파일 : LP_wET_~.txt
"""
