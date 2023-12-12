# Code Construction (Algorithm 1)

# Overview
![An Overview of the Algorithm](https://github.com/xyz123479/SC_23-Unity-ECC/blob/main/Algorithm1_H_Matrix_Construction/Unity%20ECC_Algorithm1.PNG)

# Code flows (DFS_based_SSC_DEC.cpp)
- Parallel execution in 20 positions
- 0th position: After selecting the 0th column, proceed by selecting a possible column from the 1st column, 2nd column...
- 1st position: After selecting the 12th column, proceed by selecting a possible column from the 13th column, ...

# Getting Started
- $ g++ -O2 DFS_based_SSC_DEC.cpp –o nogada 
- $ python run.py

# Answer (.txt files)
- Indicates the exponents of each column of the H-matrix
- **Ex)** column index (0~254) : 1, 0, 25, 39, 63, 108, 141, 184, 215, 230 'and' **prim_num=4 (x<sup>8</sup> + x<sup>6</sup> + x<sup>4</sup> + x<sup>3</sup> + x<sup>2</sup> + x + 1)**
- It represents the exponent of each column of the H-matrix
- Since SSC-DEC is independent of the order of columns, **it is possible to change the positions between columns**
- For the creation of a systematic code, the first two columns were fixed as an Identity matrix, and after the code construction, they were moved to the back of the H-matrix.
- **H-Matrix row 1: a^25, a^39, a^63,  a^108, a^141, a^184, a^215, a^230, a^0, 0**
- **H-Matrix row 2: a^50, a^78, a^126, a^216, a^27,  a^113, a^175, a^205, 0,   a^0**
