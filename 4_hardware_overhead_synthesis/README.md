# Hardware Overheads (Table 5)

# Synthesis setup
- Compiler: Synopsys Design Compiler
- Logic libraries: UMC 28nm SVT/LVT cells (Choose the worst condition) 
- Clock uncertainty 60% (40% margin)
- Budget of gate delay: 0.25ns (1/2.4GHz * 0.6)
- Activity factor switching: 10%
- Target frequency: 2400MHz (DDR5 4800Mbps)
- Corner: ss
- PVT (28nm, 0.9V, 125'C)

# Getting Started (Testbench)
- $ cd ~/sim
- $ ./run compile
- $ ./run tb

# Getting Started (Synthesis)
- $ cd ~/syn
- $ ./run synth
