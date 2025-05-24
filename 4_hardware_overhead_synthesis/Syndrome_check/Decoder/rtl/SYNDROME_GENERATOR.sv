module SYNDROME_GENERATOR(input [79:0] codeword_in,
                      output [15:0] syndrome_out
                      );
  // codeword_in: 80-bit RS codeword input
  // syndrome_out : 16-bit syndrome output (two 8-bit syndromes)

  // over GF(2^8) primitive polynomial, syndrome generator
  // primitive polynomial = x^8 + x6 + x^4 + x^3 + x^2 + x + 1

  /*
    G-Matrix

    1 0 0 0 0 0 0 0 a^25  a^50
    0 1 0 0 0 0 0 0 a^39  a^78
    0 0 1 0 0 0 0 0 a^63  a^126
    0 0 0 1 0 0 0 0 a^108 a^216
    0 0 0 0 1 0 0 0 a^141 a^27
    0 0 0 0 0 1 0 0 a^184 a^113
    0 0 0 0 0 0 1 0 a^215 a^175
    0 0 0 0 0 0 0 1 a^230 a^205

    H-Matrix

    a^25  a^39  a^63  a^108  a^141  a^184  a^215  a^230  a^0  0
    a^50  a^78  a^126 a^216  a^27   a^113  a^175  a^205  0    a^0

  */


  wire [7:0] parity_1 [8:0]; // front [7:0] => each element is a size of 8bit, backward [8:0] => nine elements
  wire [7:0] parity_2 [8:0]; // front [7:0] => each element is a size of 8bit, backward [8:0] => nine elements

  // first syndrome
  GFMULT gmult_00(codeword_in[79:72],8'b1110_0011, parity_1[8]); // codeword[79:72] x a^25 = parity[7] (8bit)
  GFMULT gmult_01(codeword_in[71:64],8'b1011_0100, parity_1[7]); // codeword[71:64] x a^39 = parity[6] (8bit)
  GFMULT gmult_02(codeword_in[63:56],8'b1110_0101, parity_1[6]); // codeword[63:56] x a^63 = parity[5] (8bit)
  GFMULT gmult_03(codeword_in[55:48],8'b0010_1010, parity_1[5]); // codeword[55:48] x a^108 = parity[4] (8bit)
  GFMULT gmult_04(codeword_in[47:40],8'b0011_0101, parity_1[4]); // codeword[47:40] x a^141 = parity[3] (8bit)
  GFMULT gmult_05(codeword_in[39:32],8'b0011_1000, parity_1[3]); // codeword[39:32] x a^184 = parity[2] (8bit)
  GFMULT gmult_06(codeword_in[31:24],8'b1001_1100, parity_1[2]); // codeword[31:24] x a^215 = parity[1] (8bit)
  GFMULT gmult_07(codeword_in[23:16],8'b0111_1110, parity_1[1]); // codeword[23:16] x a^230 = parity[0] (8bit)
  GFMULT gmult_08(codeword_in[15:8] ,8'b0000_0001, parity_1[0]); // codeword[15:8] x a^0 = parity[0] (8bit)

  // second syndrome
  GFMULT gmult_09(codeword_in[79:72],8'b0010_0100, parity_2[8]); // codeword[79:72] x a^50 = parity[7] (8bit)
  GFMULT gmult_10(codeword_in[71:64],8'b1110_0010, parity_2[7]); // codeword[71:64] x a^78 = parity[6] (8bit)
  GFMULT gmult_11(codeword_in[63:56],8'b0011_0000, parity_2[6]); // codeword[63:56] x a^126 = parity[5] (8bit)
  GFMULT gmult_12(codeword_in[55:48],8'b0110_0111, parity_2[5]); // codeword[55:48] x a^216 = parity[4] (8bit)
  GFMULT gmult_13(codeword_in[47:40],8'b0110_1101, parity_2[4]); // codeword[47:40] x a^27 = parity[3] (8bit)
  GFMULT gmult_14(codeword_in[39:32],8'b0011_1100, parity_2[3]); // codeword[39:32] x a^113 = parity[2] (8bit)
  GFMULT gmult_15(codeword_in[31:24],8'b1000_0001, parity_2[2]); // codeword[31:24] x a^175 = parity[1] (8bit)
  GFMULT gmult_16(codeword_in[23:16],8'b1010_0100, parity_2[1]); // codeword[23:16] x a^205 = parity[0] (8bit)
  GFMULT gmult_17(codeword_in[7:0]  ,8'b0000_0001, parity_2[0]); // codeword[7:0]   x a^0 = parity[0] (8bit) 

  assign syndrome_out[15:8] = parity_1[8] ^ parity_1[7] ^ parity_1[6] ^ parity_1[5] ^ parity_1[4] ^ parity_1[3] ^ parity_1[2] ^ parity_1[1] ^ parity_1[0];
  assign syndrome_out[7:0]  = parity_2[8] ^ parity_2[7] ^ parity_2[6] ^ parity_2[5] ^ parity_2[4] ^ parity_2[3] ^ parity_2[2] ^ parity_2[1] ^ parity_2[0];

endmodule

