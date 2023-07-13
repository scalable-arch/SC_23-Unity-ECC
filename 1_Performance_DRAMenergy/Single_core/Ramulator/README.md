# Single-core performance (Figure 7)

- Ramulator 설명 **[1]** 참고 (Ramulator: A DRAM Simulator)


!!!!!주의!! 일단 첫번째로 cputraces에 있는 파일들의 압축을 풀어야 한다 (run.py에 있는 모양대로 나옴!)

(1) Timing paramter 변경 & 컴파일 : configs/~.cfg, src/DDR4.h 수정 후 make clean, make -j4
 -> 코드 수정해도 compile 돌리기!!
(2) 코드 실행법 : python run.py

결과물 (여기에서는 result/~.txt 이다.)
-> IPC(cpu instruction number/cpu cycle number), read/write request# 등등
-> cmd (RD/WR/PR)
-> DRAMPower를 재려면 생성되는 cmd~.txt 파일을 DRAMPower 내부 폴더로 옮겨서 진행하자!!!!!!
 ex) cmd-trace-astar-chan-0-rank.txt

주의사항!!!! => cfg 파일에서 Cache 구성 (L1L2, L3..) , warmup_instr 등은 잘 생각해보고 조절해서 돌리기!


# References
- **[1]** https://github.com/CMU-SAFARI/ramulator
