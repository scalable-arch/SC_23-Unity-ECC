module DE_CORRECTOR(input [79:0] codeword_in,
                     input [15:0] syndrome_in,
                      output decode_result_out,
                      output [63:0] data_out
                      );
  // Syndome_in : 16bit syndrome 입력
  // error_location_out : error (symbol) 위치 출력 (0~9, DUE/NE면 1111 출력)
  // error_value_out : error 값 출력 (0000_0000 ~ 1111_1111)
  // decode_result_out : NE/CE(0), DUE(1) 결과 출력

  // GF(2^8)에서의 primitive polynomial 기반 systematic-encoding 진행
  // primitive polynomial = x^8 + x6 + x^4 + x^3 + x^2 + x + 1 => Unity ECC와 같다.

  /*
    G-Matrix는 아래와 같다.

    1 0 0 0 0 0 0 0 a^25  a^50
    0 1 0 0 0 0 0 0 a^39  a^78
    0 0 1 0 0 0 0 0 a^63  a^126
    0 0 0 1 0 0 0 0 a^108 a^216
    0 0 0 0 1 0 0 0 a^141 a^27
    0 0 0 0 0 1 0 0 a^184 a^113
    0 0 0 0 0 0 1 0 a^215 a^175
    0 0 0 0 0 0 0 1 a^230 a^205

    H-Matrix는 아래와 같다.

    a^25  a^39  a^63  a^108  a^141  a^184  a^215  a^230  a^0  0
    a^50  a^78  a^126 a^216  a^27   a^113  a^175  a^205  0    a^0

  */

  reg decode_result;
  reg [79:0] codeword;
   always_comb begin
     codeword=codeword_in;
     case(syndrome_in[15:0])
         // NE
         16'b0000000000000000 : begin decode_result=1'b0; end
         // CE (2-bit error not in single symbol)
         16'b0110000000101000 : begin codeword[79]^=1'b1; codeword[71]^=1'b1; decode_result=1'b0; end
         16'b1110011100111111 : begin codeword[79]^=1'b1; codeword[70]^=1'b1; decode_result=1'b0; end
         16'b0000101110011011 : begin codeword[79]^=1'b1; codeword[69]^=1'b1; decode_result=1'b0; end
         16'b0111110111001001 : begin codeword[79]^=1'b1; codeword[68]^=1'b1; decode_result=1'b0; end
         16'b0100011011100000 : begin codeword[79]^=1'b1; codeword[67]^=1'b1; decode_result=1'b0; end
         16'b1111010001011011 : begin codeword[79]^=1'b1; codeword[66]^=1'b1; decode_result=1'b0; end
         16'b1010110110101001 : begin codeword[79]^=1'b1; codeword[65]^=1'b1; decode_result=1'b0; end
         16'b0010111011010000 : begin codeword[79]^=1'b1; codeword[64]^=1'b1; decode_result=1'b0; end
         16'b1011011100000011 : begin codeword[78]^=1'b1; codeword[71]^=1'b1; decode_result=1'b0; end
         16'b0011000000010100 : begin codeword[78]^=1'b1; codeword[70]^=1'b1; decode_result=1'b0; end
         16'b1101110010110000 : begin codeword[78]^=1'b1; codeword[69]^=1'b1; decode_result=1'b0; end
         16'b1010101011100010 : begin codeword[78]^=1'b1; codeword[68]^=1'b1; decode_result=1'b0; end
         16'b1001000111001011 : begin codeword[78]^=1'b1; codeword[67]^=1'b1; decode_result=1'b0; end
         16'b0010001101110000 : begin codeword[78]^=1'b1; codeword[66]^=1'b1; decode_result=1'b0; end
         16'b0111101010000010 : begin codeword[78]^=1'b1; codeword[65]^=1'b1; decode_result=1'b0; end
         16'b1111100111111011 : begin codeword[78]^=1'b1; codeword[64]^=1'b1; decode_result=1'b0; end
         16'b0111001110111001 : begin codeword[77]^=1'b1; codeword[71]^=1'b1; decode_result=1'b0; end
         16'b1111010010101110 : begin codeword[77]^=1'b1; codeword[70]^=1'b1; decode_result=1'b0; end
         16'b0001100000001010 : begin codeword[77]^=1'b1; codeword[69]^=1'b1; decode_result=1'b0; end
         16'b0110111001011000 : begin codeword[77]^=1'b1; codeword[68]^=1'b1; decode_result=1'b0; end
         16'b0101010101110001 : begin codeword[77]^=1'b1; codeword[67]^=1'b1; decode_result=1'b0; end
         16'b1110011111001010 : begin codeword[77]^=1'b1; codeword[66]^=1'b1; decode_result=1'b0; end
         16'b1011111000111000 : begin codeword[77]^=1'b1; codeword[65]^=1'b1; decode_result=1'b0; end
         16'b0011110101000001 : begin codeword[77]^=1'b1; codeword[64]^=1'b1; decode_result=1'b0; end
         16'b0001000111100100 : begin codeword[76]^=1'b1; codeword[71]^=1'b1; decode_result=1'b0; end
         16'b1001011011110011 : begin codeword[76]^=1'b1; codeword[70]^=1'b1; decode_result=1'b0; end
         16'b0111101001010111 : begin codeword[76]^=1'b1; codeword[69]^=1'b1; decode_result=1'b0; end
         16'b0000110000000101 : begin codeword[76]^=1'b1; codeword[68]^=1'b1; decode_result=1'b0; end
         16'b0011011100101100 : begin codeword[76]^=1'b1; codeword[67]^=1'b1; decode_result=1'b0; end
         16'b1000010110010111 : begin codeword[76]^=1'b1; codeword[66]^=1'b1; decode_result=1'b0; end
         16'b1101110001100101 : begin codeword[76]^=1'b1; codeword[65]^=1'b1; decode_result=1'b0; end
         16'b0101111100011100 : begin codeword[76]^=1'b1; codeword[64]^=1'b1; decode_result=1'b0; end
         16'b0010000001100101 : begin codeword[75]^=1'b1; codeword[71]^=1'b1; decode_result=1'b0; end
         16'b1010011101110010 : begin codeword[75]^=1'b1; codeword[70]^=1'b1; decode_result=1'b0; end
         16'b0100101111010110 : begin codeword[75]^=1'b1; codeword[69]^=1'b1; decode_result=1'b0; end
         16'b0011110110000100 : begin codeword[75]^=1'b1; codeword[68]^=1'b1; decode_result=1'b0; end
         16'b0000011010101101 : begin codeword[75]^=1'b1; codeword[67]^=1'b1; decode_result=1'b0; end
         16'b1011010000010110 : begin codeword[75]^=1'b1; codeword[66]^=1'b1; decode_result=1'b0; end
         16'b1110110111100100 : begin codeword[75]^=1'b1; codeword[65]^=1'b1; decode_result=1'b0; end
         16'b0110111010011101 : begin codeword[75]^=1'b1; codeword[64]^=1'b1; decode_result=1'b0; end
         16'b1001011110001010 : begin codeword[74]^=1'b1; codeword[71]^=1'b1; decode_result=1'b0; end
         16'b0001000010011101 : begin codeword[74]^=1'b1; codeword[70]^=1'b1; decode_result=1'b0; end
         16'b1111110000111001 : begin codeword[74]^=1'b1; codeword[69]^=1'b1; decode_result=1'b0; end
         16'b1000101001101011 : begin codeword[74]^=1'b1; codeword[68]^=1'b1; decode_result=1'b0; end
         16'b1011000101000010 : begin codeword[74]^=1'b1; codeword[67]^=1'b1; decode_result=1'b0; end
         16'b0000001111111001 : begin codeword[74]^=1'b1; codeword[66]^=1'b1; decode_result=1'b0; end
         16'b0101101000001011 : begin codeword[74]^=1'b1; codeword[65]^=1'b1; decode_result=1'b0; end
         16'b1101100101110010 : begin codeword[74]^=1'b1; codeword[64]^=1'b1; decode_result=1'b0; end
         16'b0110001101010010 : begin codeword[73]^=1'b1; codeword[71]^=1'b1; decode_result=1'b0; end
         16'b1110010001000101 : begin codeword[73]^=1'b1; codeword[70]^=1'b1; decode_result=1'b0; end
         16'b0000100011100001 : begin codeword[73]^=1'b1; codeword[69]^=1'b1; decode_result=1'b0; end
         16'b0111111010110011 : begin codeword[73]^=1'b1; codeword[68]^=1'b1; decode_result=1'b0; end
         16'b0100010110011010 : begin codeword[73]^=1'b1; codeword[67]^=1'b1; decode_result=1'b0; end
         16'b1111011100100001 : begin codeword[73]^=1'b1; codeword[66]^=1'b1; decode_result=1'b0; end
         16'b1010111011010011 : begin codeword[73]^=1'b1; codeword[65]^=1'b1; decode_result=1'b0; end
         16'b0010110110101010 : begin codeword[73]^=1'b1; codeword[64]^=1'b1; decode_result=1'b0; end
         16'b0001100100111110 : begin codeword[72]^=1'b1; codeword[71]^=1'b1; decode_result=1'b0; end
         16'b1001111000101001 : begin codeword[72]^=1'b1; codeword[70]^=1'b1; decode_result=1'b0; end
         16'b0111001010001101 : begin codeword[72]^=1'b1; codeword[69]^=1'b1; decode_result=1'b0; end
         16'b0000010011011111 : begin codeword[72]^=1'b1; codeword[68]^=1'b1; decode_result=1'b0; end
         16'b0011111111110110 : begin codeword[72]^=1'b1; codeword[67]^=1'b1; decode_result=1'b0; end
         16'b1000110101001101 : begin codeword[72]^=1'b1; codeword[66]^=1'b1; decode_result=1'b0; end
         16'b1101010010111111 : begin codeword[72]^=1'b1; codeword[65]^=1'b1; decode_result=1'b0; end
         16'b0101011111000110 : begin codeword[72]^=1'b1; codeword[64]^=1'b1; decode_result=1'b0; end
         16'b1110000111111000 : begin codeword[79]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b0000100001010111 : begin codeword[79]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b1101001110101111 : begin codeword[79]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b0001000111010011 : begin codeword[79]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b0111000011101101 : begin codeword[79]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b1110111111110010 : begin codeword[79]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b0000111101010010 : begin codeword[79]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b0111111100000010 : begin codeword[79]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b0011011011010011 : begin codeword[78]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b1101111101111100 : begin codeword[78]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b0000010010000100 : begin codeword[78]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b1100011011111000 : begin codeword[78]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b1010011111000110 : begin codeword[78]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b0011100011011001 : begin codeword[78]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b1101100001111001 : begin codeword[78]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b1010100000101001 : begin codeword[78]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b1111001001101001 : begin codeword[77]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b0001101111000110 : begin codeword[77]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b1100000000111110 : begin codeword[77]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b0000001001000010 : begin codeword[77]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b0110001101111100 : begin codeword[77]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b1111110001100011 : begin codeword[77]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b0001110011000011 : begin codeword[77]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b0110110010010011 : begin codeword[77]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b1001000000110100 : begin codeword[76]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b0111100110011011 : begin codeword[76]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b1010001001100011 : begin codeword[76]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b0110000000011111 : begin codeword[76]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b0000000100100001 : begin codeword[76]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b1001111000111110 : begin codeword[76]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b0111111010011110 : begin codeword[76]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b0000111011001110 : begin codeword[76]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b1010000110110101 : begin codeword[75]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b0100100000011010 : begin codeword[75]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b1001001111100010 : begin codeword[75]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b0101000110011110 : begin codeword[75]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b0011000010100000 : begin codeword[75]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b1010111110111111 : begin codeword[75]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b0100111100011111 : begin codeword[75]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b0011111101001111 : begin codeword[75]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b0001011001011010 : begin codeword[74]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b1111111111110101 : begin codeword[74]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b0010010000001101 : begin codeword[74]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b1110011001110001 : begin codeword[74]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b1000011101001111 : begin codeword[74]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b0001100001010000 : begin codeword[74]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b1111100011110000 : begin codeword[74]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b1000100010100000 : begin codeword[74]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b1110001010000010 : begin codeword[73]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b0000101100101101 : begin codeword[73]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b1101000011010101 : begin codeword[73]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b0001001010101001 : begin codeword[73]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b0111001110010111 : begin codeword[73]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b1110110010001000 : begin codeword[73]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b0000110000101000 : begin codeword[73]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b0111110001111000 : begin codeword[73]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b1001100011101110 : begin codeword[72]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b0111000101000001 : begin codeword[72]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b1010101010111001 : begin codeword[72]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b0110100011000101 : begin codeword[72]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b0000100111111011 : begin codeword[72]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b1001011011100100 : begin codeword[72]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b0111011001000100 : begin codeword[72]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b0000011000010100 : begin codeword[72]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b0110101010011000 : begin codeword[79]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1110001001100111 : begin codeword[79]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1010011010110111 : begin codeword[79]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1000010011011111 : begin codeword[79]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1001010111101011 : begin codeword[79]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0011001011110001 : begin codeword[79]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1100111011111100 : begin codeword[79]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1011000001010101 : begin codeword[79]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b1011110110110011 : begin codeword[78]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b0011010101001100 : begin codeword[78]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b0111000110011100 : begin codeword[78]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b0101001111110100 : begin codeword[78]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b0100001011000000 : begin codeword[78]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b1110010111011010 : begin codeword[78]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b0001100111010111 : begin codeword[78]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b0110011101111110 : begin codeword[78]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0111100100001001 : begin codeword[77]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1111000111110110 : begin codeword[77]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1011010100100110 : begin codeword[77]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1001011101001110 : begin codeword[77]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1000011001111010 : begin codeword[77]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0010000101100000 : begin codeword[77]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1101110101101101 : begin codeword[77]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1010001111000100 : begin codeword[77]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0001101101010100 : begin codeword[76]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1001001110101011 : begin codeword[76]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1101011101111011 : begin codeword[76]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1111010100010011 : begin codeword[76]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1110010000100111 : begin codeword[76]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0100001100111101 : begin codeword[76]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1011111100110000 : begin codeword[76]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1100000110011001 : begin codeword[76]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0010101011010101 : begin codeword[75]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1010001000101010 : begin codeword[75]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1110011011111010 : begin codeword[75]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1100010010010010 : begin codeword[75]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1101010110100110 : begin codeword[75]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0111001010111100 : begin codeword[75]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1000111010110001 : begin codeword[75]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1111000000011000 : begin codeword[75]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b1001110100111010 : begin codeword[74]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b0001010111000101 : begin codeword[74]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b0101000100010101 : begin codeword[74]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b0111001101111101 : begin codeword[74]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b0110001001001001 : begin codeword[74]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b1100010101010011 : begin codeword[74]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b0011100101011110 : begin codeword[74]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b0100011111110111 : begin codeword[74]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0110100111100010 : begin codeword[73]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1110000100011101 : begin codeword[73]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1010010111001101 : begin codeword[73]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1000011110100101 : begin codeword[73]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1001011010010001 : begin codeword[73]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0011000110001011 : begin codeword[73]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1100110110000110 : begin codeword[73]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1011001100101111 : begin codeword[73]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0001001110001110 : begin codeword[72]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1001101101110001 : begin codeword[72]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1101111110100001 : begin codeword[72]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1111110111001001 : begin codeword[72]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1110110011111101 : begin codeword[72]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0100101111100111 : begin codeword[72]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1011011111101010 : begin codeword[72]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1100100101000011 : begin codeword[72]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0110111011100100 : begin codeword[79]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1110000001011001 : begin codeword[79]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1010011110101000 : begin codeword[79]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0010101101111111 : begin codeword[79]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0110110110111011 : begin codeword[79]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0100111011011001 : begin codeword[79]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1111000011101000 : begin codeword[79]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1010111101011111 : begin codeword[79]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b1011100111001111 : begin codeword[78]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b0011011101110010 : begin codeword[78]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b0111000010000011 : begin codeword[78]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b1111110001010100 : begin codeword[78]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b1011101010010000 : begin codeword[78]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b1001100111110010 : begin codeword[78]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b0010011111000011 : begin codeword[78]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b0111100001110100 : begin codeword[78]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0111110101110101 : begin codeword[77]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1111001111001000 : begin codeword[77]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1011010000111001 : begin codeword[77]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0011100011101110 : begin codeword[77]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0111111000101010 : begin codeword[77]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0101110101001000 : begin codeword[77]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1110001101111001 : begin codeword[77]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1011110011001110 : begin codeword[77]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0001111100101000 : begin codeword[76]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1001000110010101 : begin codeword[76]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1101011001100100 : begin codeword[76]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0101101010110011 : begin codeword[76]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0001110001110111 : begin codeword[76]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0011111100010101 : begin codeword[76]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1000000100100100 : begin codeword[76]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1101111010010011 : begin codeword[76]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0010111010101001 : begin codeword[75]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1010000000010100 : begin codeword[75]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1110011111100101 : begin codeword[75]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0110101100110010 : begin codeword[75]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0010110111110110 : begin codeword[75]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0000111010010100 : begin codeword[75]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1011000010100101 : begin codeword[75]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1110111100010010 : begin codeword[75]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b1001100101000110 : begin codeword[74]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b0001011111111011 : begin codeword[74]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b0101000000001010 : begin codeword[74]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b1101110011011101 : begin codeword[74]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b1001101000011001 : begin codeword[74]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b1011100101111011 : begin codeword[74]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b0000011101001010 : begin codeword[74]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b0101100011111101 : begin codeword[74]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0110110110011110 : begin codeword[73]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1110001100100011 : begin codeword[73]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1010010011010010 : begin codeword[73]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0010100000000101 : begin codeword[73]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0110111011000001 : begin codeword[73]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0100110110100011 : begin codeword[73]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1111001110010010 : begin codeword[73]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1010110000100101 : begin codeword[73]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0001011111110010 : begin codeword[72]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1001100101001111 : begin codeword[72]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1101111010111110 : begin codeword[72]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0101001001101001 : begin codeword[72]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0001010010101101 : begin codeword[72]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0011011111001111 : begin codeword[72]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1000100111111110 : begin codeword[72]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1101011001001001 : begin codeword[72]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0111001101100101 : begin codeword[79]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0100000110110110 : begin codeword[79]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0101100001110000 : begin codeword[79]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1111101100010011 : begin codeword[79]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0000010110001101 : begin codeword[79]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0111101011000010 : begin codeword[79]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1110101001001010 : begin codeword[79]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1010001000001110 : begin codeword[79]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1010010001001110 : begin codeword[78]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1001011010011101 : begin codeword[78]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1000111101011011 : begin codeword[78]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0010110000111000 : begin codeword[78]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1101001010100110 : begin codeword[78]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1010110111101001 : begin codeword[78]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0011110101100001 : begin codeword[78]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0111010100100101 : begin codeword[78]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0110000011110100 : begin codeword[77]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0101001000100111 : begin codeword[77]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0100101111100001 : begin codeword[77]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1110100010000010 : begin codeword[77]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0001011000011100 : begin codeword[77]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0110100101010011 : begin codeword[77]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1111100111011011 : begin codeword[77]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1011000110011111 : begin codeword[77]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0000001010101001 : begin codeword[76]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0011000001111010 : begin codeword[76]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0010100110111100 : begin codeword[76]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1000101011011111 : begin codeword[76]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0111010001000001 : begin codeword[76]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0000101100001110 : begin codeword[76]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1001101110000110 : begin codeword[76]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1101001111000010 : begin codeword[76]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0011001100101000 : begin codeword[75]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0000000111111011 : begin codeword[75]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0001100000111101 : begin codeword[75]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1011101101011110 : begin codeword[75]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0100010111000000 : begin codeword[75]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0011101010001111 : begin codeword[75]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1010101000000111 : begin codeword[75]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1110001001000011 : begin codeword[75]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1000010011000111 : begin codeword[74]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1011011000010100 : begin codeword[74]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1010111111010010 : begin codeword[74]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0000110010110001 : begin codeword[74]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1111001000101111 : begin codeword[74]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1000110101100000 : begin codeword[74]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0001110111101000 : begin codeword[74]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0101010110101100 : begin codeword[74]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0111000000011111 : begin codeword[73]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0100001011001100 : begin codeword[73]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0101101100001010 : begin codeword[73]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1111100001101001 : begin codeword[73]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0000011011110111 : begin codeword[73]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0111100110111000 : begin codeword[73]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1110100100110000 : begin codeword[73]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1010000101110100 : begin codeword[73]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0000101001110011 : begin codeword[72]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0011100010100000 : begin codeword[72]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0010000101100110 : begin codeword[72]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1000001000000101 : begin codeword[72]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0111110010011011 : begin codeword[72]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0000001111010100 : begin codeword[72]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1001001101011100 : begin codeword[72]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1101101100011000 : begin codeword[72]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1100111100111100 : begin codeword[79]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0001111100110101 : begin codeword[79]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0111011110011110 : begin codeword[79]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0100001101100100 : begin codeword[79]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0101100100011001 : begin codeword[79]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0101010010001000 : begin codeword[79]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1111110101101111 : begin codeword[79]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0000011010110011 : begin codeword[79]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0001100000010111 : begin codeword[78]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1100100000011110 : begin codeword[78]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1010000010110101 : begin codeword[78]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1001010001001111 : begin codeword[78]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1000111000110010 : begin codeword[78]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1000001110100011 : begin codeword[78]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0010101001000100 : begin codeword[78]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1101000110011000 : begin codeword[78]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1101110010101101 : begin codeword[77]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0000110010100100 : begin codeword[77]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0110010000001111 : begin codeword[77]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0101000011110101 : begin codeword[77]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0100101010001000 : begin codeword[77]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0100011100011001 : begin codeword[77]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1110111011111110 : begin codeword[77]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0001010100100010 : begin codeword[77]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1011111011110000 : begin codeword[76]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0110111011111001 : begin codeword[76]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0000011001010010 : begin codeword[76]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0011001010101000 : begin codeword[76]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0010100011010101 : begin codeword[76]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0010010101000100 : begin codeword[76]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1000110010100011 : begin codeword[76]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0111011101111111 : begin codeword[76]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1000111101110001 : begin codeword[75]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0101111101111000 : begin codeword[75]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0011011111010011 : begin codeword[75]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0000001100101001 : begin codeword[75]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0001100101010100 : begin codeword[75]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0001010011000101 : begin codeword[75]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1011110100100010 : begin codeword[75]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0100011011111110 : begin codeword[75]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0011100010011110 : begin codeword[74]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1110100010010111 : begin codeword[74]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1000000000111100 : begin codeword[74]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1011010011000110 : begin codeword[74]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1010111010111011 : begin codeword[74]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1010001100101010 : begin codeword[74]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0000101011001101 : begin codeword[74]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1111000100010001 : begin codeword[74]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1100110001000110 : begin codeword[73]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0001110001001111 : begin codeword[73]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0111010011100100 : begin codeword[73]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0100000000011110 : begin codeword[73]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0101101001100011 : begin codeword[73]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0101011111110010 : begin codeword[73]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1111111000010101 : begin codeword[73]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0000010111001001 : begin codeword[73]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1011011000101010 : begin codeword[72]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0110011000100011 : begin codeword[72]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0000111010001000 : begin codeword[72]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0011101001110010 : begin codeword[72]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0010000000001111 : begin codeword[72]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0010110110011110 : begin codeword[72]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1000010001111001 : begin codeword[72]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0111111110100101 : begin codeword[72]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1101010110001110 : begin codeword[79]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0001001001101100 : begin codeword[79]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1101111000011101 : begin codeword[79]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1011100010001010 : begin codeword[79]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1000101101101110 : begin codeword[79]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0011110100011100 : begin codeword[79]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0110011000100101 : begin codeword[79]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1110010010010110 : begin codeword[79]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0000001010100101 : begin codeword[78]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1100010101000111 : begin codeword[78]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0000100100110110 : begin codeword[78]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0110111110100001 : begin codeword[78]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0101110001000101 : begin codeword[78]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1110101000110111 : begin codeword[78]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1011000100001110 : begin codeword[78]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0011001110111101 : begin codeword[78]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1100011000011111 : begin codeword[77]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0000000111111101 : begin codeword[77]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1100110110001100 : begin codeword[77]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1010101100011011 : begin codeword[77]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1001100011111111 : begin codeword[77]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0010111010001101 : begin codeword[77]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0111010110110100 : begin codeword[77]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1111011100000111 : begin codeword[77]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1010010001000010 : begin codeword[76]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0110001110100000 : begin codeword[76]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1010111111010001 : begin codeword[76]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1100100101000110 : begin codeword[76]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1111101010100010 : begin codeword[76]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0100110011010000 : begin codeword[76]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0001011111101001 : begin codeword[76]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1001010101011010 : begin codeword[76]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1001010111000011 : begin codeword[75]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0101001000100001 : begin codeword[75]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1001111001010000 : begin codeword[75]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1111100011000111 : begin codeword[75]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1100101100100011 : begin codeword[75]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0111110101010001 : begin codeword[75]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0010011001101000 : begin codeword[75]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1010010011011011 : begin codeword[75]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0010001000101100 : begin codeword[74]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1110010111001110 : begin codeword[74]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0010100110111111 : begin codeword[74]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0100111100101000 : begin codeword[74]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0111110011001100 : begin codeword[74]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1100101010111110 : begin codeword[74]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1001000110000111 : begin codeword[74]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0001001100110100 : begin codeword[74]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1101011011110100 : begin codeword[73]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0001000100010110 : begin codeword[73]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1101110101100111 : begin codeword[73]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1011101111110000 : begin codeword[73]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1000100000010100 : begin codeword[73]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0011111001100110 : begin codeword[73]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0110010101011111 : begin codeword[73]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1110011111101100 : begin codeword[73]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1010110010011000 : begin codeword[72]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0110101101111010 : begin codeword[72]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1010011100001011 : begin codeword[72]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1100000110011100 : begin codeword[72]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1111001001111000 : begin codeword[72]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0100010000001010 : begin codeword[72]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0001111100110011 : begin codeword[72]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1001110110000000 : begin codeword[72]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0001101000110010 : begin codeword[79]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1101101000110010 : begin codeword[79]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1011101000110010 : begin codeword[79]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1000101000110010 : begin codeword[79]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1001001000110010 : begin codeword[79]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1001111000110010 : begin codeword[79]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1001100000110010 : begin codeword[79]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1001101100110010 : begin codeword[79]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1100110100011001 : begin codeword[78]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0000110100011001 : begin codeword[78]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0110110100011001 : begin codeword[78]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0101110100011001 : begin codeword[78]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0100010100011001 : begin codeword[78]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0100100100011001 : begin codeword[78]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0100111100011001 : begin codeword[78]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0100110000011001 : begin codeword[78]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0000100110100011 : begin codeword[77]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1100100110100011 : begin codeword[77]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1010100110100011 : begin codeword[77]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1001100110100011 : begin codeword[77]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1000000110100011 : begin codeword[77]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1000110110100011 : begin codeword[77]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1000101110100011 : begin codeword[77]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1000100010100011 : begin codeword[77]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0110101111111110 : begin codeword[76]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1010101111111110 : begin codeword[76]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1100101111111110 : begin codeword[76]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1111101111111110 : begin codeword[76]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1110001111111110 : begin codeword[76]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1110111111111110 : begin codeword[76]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1110100111111110 : begin codeword[76]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1110101011111110 : begin codeword[76]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0101101001111111 : begin codeword[75]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1001101001111111 : begin codeword[75]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1111101001111111 : begin codeword[75]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1100101001111111 : begin codeword[75]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1101001001111111 : begin codeword[75]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1101111001111111 : begin codeword[75]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1101100001111111 : begin codeword[75]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1101101101111111 : begin codeword[75]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1110110110010000 : begin codeword[74]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0010110110010000 : begin codeword[74]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0100110110010000 : begin codeword[74]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0111110110010000 : begin codeword[74]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0110010110010000 : begin codeword[74]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0110100110010000 : begin codeword[74]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0110111110010000 : begin codeword[74]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0110110010010000 : begin codeword[74]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0001100101001000 : begin codeword[73]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1101100101001000 : begin codeword[73]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1011100101001000 : begin codeword[73]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1000100101001000 : begin codeword[73]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1001000101001000 : begin codeword[73]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1001110101001000 : begin codeword[73]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1001101101001000 : begin codeword[73]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1001100001001000 : begin codeword[73]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0110001100100100 : begin codeword[72]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1010001100100100 : begin codeword[72]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1100001100100100 : begin codeword[72]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1111001100100100 : begin codeword[72]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1110101100100100 : begin codeword[72]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1110011100100100 : begin codeword[72]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1110000100100100 : begin codeword[72]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1110001000100100 : begin codeword[72]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1001101010110010 : begin codeword[79]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1001101001110010 : begin codeword[79]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1001101000010010 : begin codeword[79]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1001101000100010 : begin codeword[79]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1001101000111010 : begin codeword[79]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1001101000110110 : begin codeword[79]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1001101000110000 : begin codeword[79]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1001101000110011 : begin codeword[79]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0100110110011001 : begin codeword[78]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0100110101011001 : begin codeword[78]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0100110100111001 : begin codeword[78]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0100110100001001 : begin codeword[78]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0100110100010001 : begin codeword[78]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0100110100011101 : begin codeword[78]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0100110100011011 : begin codeword[78]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0100110100011000 : begin codeword[78]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1000100100100011 : begin codeword[77]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1000100111100011 : begin codeword[77]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1000100110000011 : begin codeword[77]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1000100110110011 : begin codeword[77]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1000100110101011 : begin codeword[77]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1000100110100111 : begin codeword[77]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1000100110100001 : begin codeword[77]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1000100110100010 : begin codeword[77]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1110101101111110 : begin codeword[76]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1110101110111110 : begin codeword[76]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1110101111011110 : begin codeword[76]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1110101111101110 : begin codeword[76]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1110101111110110 : begin codeword[76]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1110101111111010 : begin codeword[76]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1110101111111100 : begin codeword[76]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1110101111111111 : begin codeword[76]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1101101011111111 : begin codeword[75]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1101101000111111 : begin codeword[75]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1101101001011111 : begin codeword[75]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1101101001101111 : begin codeword[75]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1101101001110111 : begin codeword[75]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1101101001111011 : begin codeword[75]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1101101001111101 : begin codeword[75]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1101101001111110 : begin codeword[75]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0110110100010000 : begin codeword[74]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0110110111010000 : begin codeword[74]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0110110110110000 : begin codeword[74]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0110110110000000 : begin codeword[74]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0110110110011000 : begin codeword[74]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0110110110010100 : begin codeword[74]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0110110110010010 : begin codeword[74]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0110110110010001 : begin codeword[74]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1001100111001000 : begin codeword[73]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1001100100001000 : begin codeword[73]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1001100101101000 : begin codeword[73]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1001100101011000 : begin codeword[73]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1001100101000000 : begin codeword[73]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1001100101001100 : begin codeword[73]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1001100101001010 : begin codeword[73]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1001100101001001 : begin codeword[73]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1110001110100100 : begin codeword[72]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1110001101100100 : begin codeword[72]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1110001100000100 : begin codeword[72]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1110001100110100 : begin codeword[72]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1110001100101100 : begin codeword[72]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1110001100100000 : begin codeword[72]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1110001100100110 : begin codeword[72]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1110001100100101 : begin codeword[72]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1000000111010000 : begin codeword[71]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b0110100001111111 : begin codeword[71]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b1011001110000111 : begin codeword[71]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b0111000111111011 : begin codeword[71]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b0001000011000101 : begin codeword[71]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b1000111111011010 : begin codeword[71]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b0110111101111010 : begin codeword[71]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b0001111100101010 : begin codeword[71]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b0000011011000111 : begin codeword[70]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b1110111101101000 : begin codeword[70]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b0011010010010000 : begin codeword[70]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b1111011011101100 : begin codeword[70]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b1001011111010010 : begin codeword[70]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b0000100011001101 : begin codeword[70]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b1110100001101101 : begin codeword[70]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b1001100000111101 : begin codeword[70]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b1110101001100011 : begin codeword[69]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b0000001111001100 : begin codeword[69]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b1101100000110100 : begin codeword[69]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b0001101001001000 : begin codeword[69]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b0111101101110110 : begin codeword[69]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b1110010001101001 : begin codeword[69]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b0000010011001001 : begin codeword[69]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b0111010010011001 : begin codeword[69]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b1001110000110001 : begin codeword[68]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b0111010110011110 : begin codeword[68]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b1010111001100110 : begin codeword[68]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b0110110000011010 : begin codeword[68]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b0000110100100100 : begin codeword[68]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b1001001000111011 : begin codeword[68]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b0111001010011011 : begin codeword[68]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b0000001011001011 : begin codeword[68]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b1010011100011000 : begin codeword[67]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b0100111010110111 : begin codeword[67]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b1001010101001111 : begin codeword[67]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b0101011100110011 : begin codeword[67]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b0011011000001101 : begin codeword[67]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b1010100100010010 : begin codeword[67]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b0100100110110010 : begin codeword[67]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b0011100111100010 : begin codeword[67]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b0001010110100011 : begin codeword[66]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b1111110000001100 : begin codeword[66]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b0010011111110100 : begin codeword[66]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b1110010110001000 : begin codeword[66]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b1000010010110110 : begin codeword[66]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b0001101110101001 : begin codeword[66]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b1111101100001001 : begin codeword[66]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b1000101101011001 : begin codeword[66]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b0100110001010001 : begin codeword[65]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b1010010111111110 : begin codeword[65]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b0111111000000110 : begin codeword[65]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b1011110001111010 : begin codeword[65]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b1101110101000100 : begin codeword[65]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b0100001001011011 : begin codeword[65]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b1010001011111011 : begin codeword[65]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b1101001010101011 : begin codeword[65]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b1100111100101000 : begin codeword[64]^=1'b1; codeword[63]^=1'b1; decode_result=1'b0; end
         16'b0010011010000111 : begin codeword[64]^=1'b1; codeword[62]^=1'b1; decode_result=1'b0; end
         16'b1111110101111111 : begin codeword[64]^=1'b1; codeword[61]^=1'b1; decode_result=1'b0; end
         16'b0011111100000011 : begin codeword[64]^=1'b1; codeword[60]^=1'b1; decode_result=1'b0; end
         16'b0101111000111101 : begin codeword[64]^=1'b1; codeword[59]^=1'b1; decode_result=1'b0; end
         16'b1100000100100010 : begin codeword[64]^=1'b1; codeword[58]^=1'b1; decode_result=1'b0; end
         16'b0010000110000010 : begin codeword[64]^=1'b1; codeword[57]^=1'b1; decode_result=1'b0; end
         16'b0101000111010010 : begin codeword[64]^=1'b1; codeword[56]^=1'b1; decode_result=1'b0; end
         16'b0000101010110000 : begin codeword[71]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1000001001001111 : begin codeword[71]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1100011010011111 : begin codeword[71]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1110010011110111 : begin codeword[71]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1111010111000011 : begin codeword[71]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0101001011011001 : begin codeword[71]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1010111011010100 : begin codeword[71]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1101000001111101 : begin codeword[71]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b1000110110100111 : begin codeword[70]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b0000010101011000 : begin codeword[70]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b0100000110001000 : begin codeword[70]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b0110001111100000 : begin codeword[70]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b0111001011010100 : begin codeword[70]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b1101010111001110 : begin codeword[70]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b0010100111000011 : begin codeword[70]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b0101011101101010 : begin codeword[70]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0110000100000011 : begin codeword[69]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1110100111111100 : begin codeword[69]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1010110100101100 : begin codeword[69]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1000111101000100 : begin codeword[69]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1001111001110000 : begin codeword[69]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0011100101101010 : begin codeword[69]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1100010101100111 : begin codeword[69]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1011101111001110 : begin codeword[69]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0001011101010001 : begin codeword[68]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1001111110101110 : begin codeword[68]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1101101101111110 : begin codeword[68]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1111100100010110 : begin codeword[68]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1110100000100010 : begin codeword[68]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0100111100111000 : begin codeword[68]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1011001100110101 : begin codeword[68]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1100110110011100 : begin codeword[68]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0010110001111000 : begin codeword[67]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1010010010000111 : begin codeword[67]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1110000001010111 : begin codeword[67]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1100001000111111 : begin codeword[67]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1101001100001011 : begin codeword[67]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0111010000010001 : begin codeword[67]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1000100000011100 : begin codeword[67]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1111011010110101 : begin codeword[67]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b1001111011000011 : begin codeword[66]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b0001011000111100 : begin codeword[66]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b0101001011101100 : begin codeword[66]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b0111000010000100 : begin codeword[66]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b0110000110110000 : begin codeword[66]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b1100011010101010 : begin codeword[66]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b0011101010100111 : begin codeword[66]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b0100010000001110 : begin codeword[66]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b1100011100110001 : begin codeword[65]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b0100111111001110 : begin codeword[65]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b0000101100011110 : begin codeword[65]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b0010100101110110 : begin codeword[65]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b0011100001000010 : begin codeword[65]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b1001111101011000 : begin codeword[65]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b0110001101010101 : begin codeword[65]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b0001110111111100 : begin codeword[65]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0100010001001000 : begin codeword[64]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1100110010110111 : begin codeword[64]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1000100001100111 : begin codeword[64]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1010101000001111 : begin codeword[64]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1011101100111011 : begin codeword[64]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0001110000100001 : begin codeword[64]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1110000000101100 : begin codeword[64]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1001111010000101 : begin codeword[64]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0000111011001100 : begin codeword[71]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1000000001110001 : begin codeword[71]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1100011110000000 : begin codeword[71]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0100101101010111 : begin codeword[71]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0000110110010011 : begin codeword[71]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0010111011110001 : begin codeword[71]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1001000011000000 : begin codeword[71]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1100111101110111 : begin codeword[71]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b1000100111011011 : begin codeword[70]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b0000011101100110 : begin codeword[70]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b0100000010010111 : begin codeword[70]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b1100110001000000 : begin codeword[70]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b1000101010000100 : begin codeword[70]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b1010100111100110 : begin codeword[70]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b0001011111010111 : begin codeword[70]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b0100100001100000 : begin codeword[70]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0110010101111111 : begin codeword[69]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1110101111000010 : begin codeword[69]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1010110000110011 : begin codeword[69]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0010000011100100 : begin codeword[69]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0110011000100000 : begin codeword[69]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0100010101000010 : begin codeword[69]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1111101101110011 : begin codeword[69]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1010010011000100 : begin codeword[69]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0001001100101101 : begin codeword[68]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1001110110010000 : begin codeword[68]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1101101001100001 : begin codeword[68]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0101011010110110 : begin codeword[68]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0001000001110010 : begin codeword[68]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0011001100010000 : begin codeword[68]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1000110100100001 : begin codeword[68]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1101001010010110 : begin codeword[68]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0010100000000100 : begin codeword[67]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1010011010111001 : begin codeword[67]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1110000101001000 : begin codeword[67]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0110110110011111 : begin codeword[67]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0010101101011011 : begin codeword[67]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0000100000111001 : begin codeword[67]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1011011000001000 : begin codeword[67]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1110100110111111 : begin codeword[67]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b1001101010111111 : begin codeword[66]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b0001010000000010 : begin codeword[66]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b0101001111110011 : begin codeword[66]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b1101111100100100 : begin codeword[66]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b1001100111100000 : begin codeword[66]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b1011101010000010 : begin codeword[66]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b0000010010110011 : begin codeword[66]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b0101101100000100 : begin codeword[66]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b1100001101001101 : begin codeword[65]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b0100110111110000 : begin codeword[65]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b0000101000000001 : begin codeword[65]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b1000011011010110 : begin codeword[65]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b1100000000010010 : begin codeword[65]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b1110001101110000 : begin codeword[65]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b0101110101000001 : begin codeword[65]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b0000001011110110 : begin codeword[65]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0100000000110100 : begin codeword[64]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1100111010001001 : begin codeword[64]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1000100101111000 : begin codeword[64]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0000010110101111 : begin codeword[64]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0100001101101011 : begin codeword[64]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0110000000001001 : begin codeword[64]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1101111000111000 : begin codeword[64]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1000000110001111 : begin codeword[64]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0001001101001101 : begin codeword[71]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0010000110011110 : begin codeword[71]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0011100001011000 : begin codeword[71]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1001101100111011 : begin codeword[71]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0110010110100101 : begin codeword[71]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0001101011101010 : begin codeword[71]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1000101001100010 : begin codeword[71]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1100001000100110 : begin codeword[71]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1001010001011010 : begin codeword[70]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1010011010001001 : begin codeword[70]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1011111101001111 : begin codeword[70]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0001110000101100 : begin codeword[70]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1110001010110010 : begin codeword[70]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1001110111111101 : begin codeword[70]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0000110101110101 : begin codeword[70]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0100010100110001 : begin codeword[70]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0111100011111110 : begin codeword[69]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0100101000101101 : begin codeword[69]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0101001111101011 : begin codeword[69]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1111000010001000 : begin codeword[69]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0000111000010110 : begin codeword[69]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0111000101011001 : begin codeword[69]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1110000111010001 : begin codeword[69]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1010100110010101 : begin codeword[69]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0000111010101100 : begin codeword[68]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0011110001111111 : begin codeword[68]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0010010110111001 : begin codeword[68]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1000011011011010 : begin codeword[68]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0111100001000100 : begin codeword[68]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0000011100001011 : begin codeword[68]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1001011110000011 : begin codeword[68]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1101111111000111 : begin codeword[68]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0011010110000101 : begin codeword[67]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0000011101010110 : begin codeword[67]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0001111010010000 : begin codeword[67]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1011110111110011 : begin codeword[67]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0100001101101101 : begin codeword[67]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0011110000100010 : begin codeword[67]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1010110010101010 : begin codeword[67]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1110010011101110 : begin codeword[67]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1000011100111110 : begin codeword[66]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1011010111101101 : begin codeword[66]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1010110000101011 : begin codeword[66]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0000111101001000 : begin codeword[66]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1111000111010110 : begin codeword[66]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1000111010011001 : begin codeword[66]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0001111000010001 : begin codeword[66]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0101011001010101 : begin codeword[66]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1101111011001100 : begin codeword[65]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1110110000011111 : begin codeword[65]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1111010111011001 : begin codeword[65]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0101011010111010 : begin codeword[65]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1010100000100100 : begin codeword[65]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1101011101101011 : begin codeword[65]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0100011111100011 : begin codeword[65]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0000111110100111 : begin codeword[65]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0101110110110101 : begin codeword[64]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0110111101100110 : begin codeword[64]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0111011010100000 : begin codeword[64]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1101010111000011 : begin codeword[64]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0010101101011101 : begin codeword[64]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0101010000010010 : begin codeword[64]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1100010010011010 : begin codeword[64]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1000110011011110 : begin codeword[64]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1010111100010100 : begin codeword[71]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0111111100011101 : begin codeword[71]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0001011110110110 : begin codeword[71]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0010001101001100 : begin codeword[71]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0011100100110001 : begin codeword[71]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0011010010100000 : begin codeword[71]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1001110101000111 : begin codeword[71]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0110011010011011 : begin codeword[71]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0010100000000011 : begin codeword[70]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1111100000001010 : begin codeword[70]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1001000010100001 : begin codeword[70]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1010010001011011 : begin codeword[70]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1011111000100110 : begin codeword[70]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1011001110110111 : begin codeword[70]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0001101001010000 : begin codeword[70]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1110000110001100 : begin codeword[70]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1100010010100111 : begin codeword[69]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0001010010101110 : begin codeword[69]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0111110000000101 : begin codeword[69]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0100100011111111 : begin codeword[69]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0101001010000010 : begin codeword[69]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0101111100010011 : begin codeword[69]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1111011011110100 : begin codeword[69]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0000110100101000 : begin codeword[69]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1011001011110101 : begin codeword[68]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0110001011111100 : begin codeword[68]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0000101001010111 : begin codeword[68]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0011111010101101 : begin codeword[68]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0010010011010000 : begin codeword[68]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0010100101000001 : begin codeword[68]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1000000010100110 : begin codeword[68]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0111101101111010 : begin codeword[68]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1000100111011100 : begin codeword[67]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0101100111010101 : begin codeword[67]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0011000101111110 : begin codeword[67]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0000010110000100 : begin codeword[67]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0001111111111001 : begin codeword[67]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0001001001101000 : begin codeword[67]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1011101110001111 : begin codeword[67]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0100000001010011 : begin codeword[67]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0011101101100111 : begin codeword[66]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1110101101101110 : begin codeword[66]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1000001111000101 : begin codeword[66]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1011011100111111 : begin codeword[66]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1010110101000010 : begin codeword[66]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1010000011010011 : begin codeword[66]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0000100100110100 : begin codeword[66]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1111001011101000 : begin codeword[66]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0110001010010101 : begin codeword[65]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1011001010011100 : begin codeword[65]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1101101000110111 : begin codeword[65]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1110111011001101 : begin codeword[65]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1111010010110000 : begin codeword[65]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1111100100100001 : begin codeword[65]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0101000011000110 : begin codeword[65]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1010101100011010 : begin codeword[65]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1110000111101100 : begin codeword[64]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0011000111100101 : begin codeword[64]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0101100101001110 : begin codeword[64]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0110110110110100 : begin codeword[64]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0111011111001001 : begin codeword[64]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0111101001011000 : begin codeword[64]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1101001110111111 : begin codeword[64]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0010100001100011 : begin codeword[64]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1011010110100110 : begin codeword[71]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0111001001000100 : begin codeword[71]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1011111000110101 : begin codeword[71]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1101100010100010 : begin codeword[71]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1110101101000110 : begin codeword[71]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0101110100110100 : begin codeword[71]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0000011000001101 : begin codeword[71]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1000010010111110 : begin codeword[71]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0011001010110001 : begin codeword[70]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1111010101010011 : begin codeword[70]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0011100100100010 : begin codeword[70]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0101111110110101 : begin codeword[70]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0110110001010001 : begin codeword[70]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1101101000100011 : begin codeword[70]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1000000100011010 : begin codeword[70]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0000001110101001 : begin codeword[70]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1101111000010101 : begin codeword[69]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0001100111110111 : begin codeword[69]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1101010110000110 : begin codeword[69]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1011001100010001 : begin codeword[69]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1000000011110101 : begin codeword[69]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0011011010000111 : begin codeword[69]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0110110110111110 : begin codeword[69]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1110111100001101 : begin codeword[69]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1010100001000111 : begin codeword[68]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0110111110100101 : begin codeword[68]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1010001111010100 : begin codeword[68]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1100010101000011 : begin codeword[68]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1111011010100111 : begin codeword[68]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0100000011010101 : begin codeword[68]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0001101111101100 : begin codeword[68]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1001100101011111 : begin codeword[68]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1001001101101110 : begin codeword[67]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0101010010001100 : begin codeword[67]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1001100011111101 : begin codeword[67]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1111111001101010 : begin codeword[67]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1100110110001110 : begin codeword[67]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0111101111111100 : begin codeword[67]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0010000011000101 : begin codeword[67]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1010001001110110 : begin codeword[67]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0010000111010101 : begin codeword[66]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1110011000110111 : begin codeword[66]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0010101001000110 : begin codeword[66]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0100110011010001 : begin codeword[66]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0111111100110101 : begin codeword[66]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1100100101000111 : begin codeword[66]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1001001001111110 : begin codeword[66]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0001000011001101 : begin codeword[66]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0111100000100111 : begin codeword[65]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1011111111000101 : begin codeword[65]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0111001110110100 : begin codeword[65]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0001010100100011 : begin codeword[65]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0010011011000111 : begin codeword[65]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1001000010110101 : begin codeword[65]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1100101110001100 : begin codeword[65]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0100100100111111 : begin codeword[65]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1111101101011110 : begin codeword[64]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0011110010111100 : begin codeword[64]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1111000011001101 : begin codeword[64]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1001011001011010 : begin codeword[64]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1010010110111110 : begin codeword[64]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0001001111001100 : begin codeword[64]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0100100011110101 : begin codeword[64]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1100101001000110 : begin codeword[64]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0111101000011010 : begin codeword[71]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1011101000011010 : begin codeword[71]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1101101000011010 : begin codeword[71]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1110101000011010 : begin codeword[71]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1111001000011010 : begin codeword[71]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1111111000011010 : begin codeword[71]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1111100000011010 : begin codeword[71]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1111101100011010 : begin codeword[71]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1111110100001101 : begin codeword[70]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0011110100001101 : begin codeword[70]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0101110100001101 : begin codeword[70]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0110110100001101 : begin codeword[70]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0111010100001101 : begin codeword[70]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0111100100001101 : begin codeword[70]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0111111100001101 : begin codeword[70]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0111110000001101 : begin codeword[70]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0001000110101001 : begin codeword[69]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1101000110101001 : begin codeword[69]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1011000110101001 : begin codeword[69]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1000000110101001 : begin codeword[69]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1001100110101001 : begin codeword[69]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1001010110101001 : begin codeword[69]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1001001110101001 : begin codeword[69]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1001000010101001 : begin codeword[69]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0110011111111011 : begin codeword[68]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1010011111111011 : begin codeword[68]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1100011111111011 : begin codeword[68]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1111011111111011 : begin codeword[68]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1110111111111011 : begin codeword[68]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1110001111111011 : begin codeword[68]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1110010111111011 : begin codeword[68]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1110011011111011 : begin codeword[68]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0101110011010010 : begin codeword[67]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1001110011010010 : begin codeword[67]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1111110011010010 : begin codeword[67]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1100110011010010 : begin codeword[67]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1101010011010010 : begin codeword[67]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1101100011010010 : begin codeword[67]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1101111011010010 : begin codeword[67]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1101110111010010 : begin codeword[67]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1110111001101001 : begin codeword[66]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0010111001101001 : begin codeword[66]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0100111001101001 : begin codeword[66]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0111111001101001 : begin codeword[66]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0110011001101001 : begin codeword[66]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0110101001101001 : begin codeword[66]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0110110001101001 : begin codeword[66]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0110111101101001 : begin codeword[66]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1011011110011011 : begin codeword[65]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0111011110011011 : begin codeword[65]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0001011110011011 : begin codeword[65]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0010011110011011 : begin codeword[65]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0011111110011011 : begin codeword[65]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0011001110011011 : begin codeword[65]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0011010110011011 : begin codeword[65]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0011011010011011 : begin codeword[65]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0011010011100010 : begin codeword[64]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1111010011100010 : begin codeword[64]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1001010011100010 : begin codeword[64]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1010010011100010 : begin codeword[64]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1011110011100010 : begin codeword[64]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1011000011100010 : begin codeword[64]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1011011011100010 : begin codeword[64]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1011010111100010 : begin codeword[64]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1111101010011010 : begin codeword[71]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1111101001011010 : begin codeword[71]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1111101000111010 : begin codeword[71]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1111101000001010 : begin codeword[71]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1111101000010010 : begin codeword[71]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1111101000011110 : begin codeword[71]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1111101000011000 : begin codeword[71]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1111101000011011 : begin codeword[71]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0111110110001101 : begin codeword[70]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0111110101001101 : begin codeword[70]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0111110100101101 : begin codeword[70]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0111110100011101 : begin codeword[70]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0111110100000101 : begin codeword[70]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0111110100001001 : begin codeword[70]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0111110100001111 : begin codeword[70]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0111110100001100 : begin codeword[70]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1001000100101001 : begin codeword[69]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1001000111101001 : begin codeword[69]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1001000110001001 : begin codeword[69]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1001000110111001 : begin codeword[69]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1001000110100001 : begin codeword[69]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1001000110101101 : begin codeword[69]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1001000110101011 : begin codeword[69]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1001000110101000 : begin codeword[69]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1110011101111011 : begin codeword[68]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1110011110111011 : begin codeword[68]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1110011111011011 : begin codeword[68]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1110011111101011 : begin codeword[68]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1110011111110011 : begin codeword[68]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1110011111111111 : begin codeword[68]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1110011111111001 : begin codeword[68]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1110011111111010 : begin codeword[68]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1101110001010010 : begin codeword[67]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1101110010010010 : begin codeword[67]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1101110011110010 : begin codeword[67]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1101110011000010 : begin codeword[67]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1101110011011010 : begin codeword[67]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1101110011010110 : begin codeword[67]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1101110011010000 : begin codeword[67]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1101110011010011 : begin codeword[67]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0110111011101001 : begin codeword[66]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0110111000101001 : begin codeword[66]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0110111001001001 : begin codeword[66]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0110111001111001 : begin codeword[66]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0110111001100001 : begin codeword[66]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0110111001101101 : begin codeword[66]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0110111001101011 : begin codeword[66]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0110111001101000 : begin codeword[66]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0011011100011011 : begin codeword[65]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0011011111011011 : begin codeword[65]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0011011110111011 : begin codeword[65]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0011011110001011 : begin codeword[65]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0011011110010011 : begin codeword[65]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0011011110011111 : begin codeword[65]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0011011110011001 : begin codeword[65]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0011011110011010 : begin codeword[65]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1011010001100010 : begin codeword[64]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1011010010100010 : begin codeword[64]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1011010011000010 : begin codeword[64]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1011010011110010 : begin codeword[64]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1011010011101010 : begin codeword[64]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1011010011100110 : begin codeword[64]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1011010011100000 : begin codeword[64]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1011010011100011 : begin codeword[64]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1000101101100000 : begin codeword[63]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b0000001110011111 : begin codeword[63]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b0100011101001111 : begin codeword[63]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b0110010100100111 : begin codeword[63]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b0111010000010011 : begin codeword[63]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b1101001100001001 : begin codeword[63]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b0010111100000100 : begin codeword[63]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b0101000110101101 : begin codeword[63]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0110001011001111 : begin codeword[62]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1110101000110000 : begin codeword[62]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1010111011100000 : begin codeword[62]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1000110010001000 : begin codeword[62]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1001110110111100 : begin codeword[62]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0011101010100110 : begin codeword[62]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1100011010101011 : begin codeword[62]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1011100000000010 : begin codeword[62]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b1011100100110111 : begin codeword[61]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b0011000111001000 : begin codeword[61]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b0111010100011000 : begin codeword[61]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b0101011101110000 : begin codeword[61]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b0100011001000100 : begin codeword[61]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b1110000101011110 : begin codeword[61]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b0001110101010011 : begin codeword[61]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b0110001111111010 : begin codeword[61]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0111101101001011 : begin codeword[60]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1111001110110100 : begin codeword[60]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1011011101100100 : begin codeword[60]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1001010100001100 : begin codeword[60]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1000010000111000 : begin codeword[60]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0010001100100010 : begin codeword[60]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1101111100101111 : begin codeword[60]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1010000110000110 : begin codeword[60]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0001101001110101 : begin codeword[59]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1001001010001010 : begin codeword[59]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1101011001011010 : begin codeword[59]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1111010000110010 : begin codeword[59]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1110010100000110 : begin codeword[59]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0100001000011100 : begin codeword[59]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1011111000010001 : begin codeword[59]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1100000010111000 : begin codeword[59]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b1000010101101010 : begin codeword[58]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b0000110110010101 : begin codeword[58]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b0100100101000101 : begin codeword[58]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b0110101100101101 : begin codeword[58]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b0111101000011001 : begin codeword[58]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b1101110100000011 : begin codeword[58]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b0010000100001110 : begin codeword[58]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b0101111110100111 : begin codeword[58]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0110010111001010 : begin codeword[57]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1110110100110101 : begin codeword[57]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1010100111100101 : begin codeword[57]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1000101110001101 : begin codeword[57]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1001101010111001 : begin codeword[57]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0011110110100011 : begin codeword[57]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1100000110101110 : begin codeword[57]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1011111100000111 : begin codeword[57]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b0001010110011010 : begin codeword[56]^=1'b1; codeword[55]^=1'b1; decode_result=1'b0; end
         16'b1001110101100101 : begin codeword[56]^=1'b1; codeword[54]^=1'b1; decode_result=1'b0; end
         16'b1101100110110101 : begin codeword[56]^=1'b1; codeword[53]^=1'b1; decode_result=1'b0; end
         16'b1111101111011101 : begin codeword[56]^=1'b1; codeword[52]^=1'b1; decode_result=1'b0; end
         16'b1110101011101001 : begin codeword[56]^=1'b1; codeword[51]^=1'b1; decode_result=1'b0; end
         16'b0100110111110011 : begin codeword[56]^=1'b1; codeword[50]^=1'b1; decode_result=1'b0; end
         16'b1011000111111110 : begin codeword[56]^=1'b1; codeword[49]^=1'b1; decode_result=1'b0; end
         16'b1100111101010111 : begin codeword[56]^=1'b1; codeword[48]^=1'b1; decode_result=1'b0; end
         16'b1000111100011100 : begin codeword[63]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b0000000110100001 : begin codeword[63]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b0100011001010000 : begin codeword[63]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b1100101010000111 : begin codeword[63]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b1000110001000011 : begin codeword[63]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b1010111100100001 : begin codeword[63]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b0001000100010000 : begin codeword[63]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b0100111010100111 : begin codeword[63]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0110011010110011 : begin codeword[62]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1110100000001110 : begin codeword[62]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1010111111111111 : begin codeword[62]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0010001100101000 : begin codeword[62]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0110010111101100 : begin codeword[62]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0100011010001110 : begin codeword[62]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1111100010111111 : begin codeword[62]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1010011100001000 : begin codeword[62]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b1011110101001011 : begin codeword[61]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b0011001111110110 : begin codeword[61]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b0111010000000111 : begin codeword[61]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b1111100011010000 : begin codeword[61]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b1011111000010100 : begin codeword[61]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b1001110101110110 : begin codeword[61]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b0010001101000111 : begin codeword[61]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b0111110011110000 : begin codeword[61]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0111111100110111 : begin codeword[60]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1111000110001010 : begin codeword[60]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1011011001111011 : begin codeword[60]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0011101010101100 : begin codeword[60]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0111110001101000 : begin codeword[60]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0101111100001010 : begin codeword[60]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1110000100111011 : begin codeword[60]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1011111010001100 : begin codeword[60]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0001111000001001 : begin codeword[59]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1001000010110100 : begin codeword[59]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1101011101000101 : begin codeword[59]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0101101110010010 : begin codeword[59]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0001110101010110 : begin codeword[59]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0011111000110100 : begin codeword[59]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1000000000000101 : begin codeword[59]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1101111110110010 : begin codeword[59]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b1000000100010110 : begin codeword[58]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b0000111110101011 : begin codeword[58]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b0100100001011010 : begin codeword[58]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b1100010010001101 : begin codeword[58]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b1000001001001001 : begin codeword[58]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b1010000100101011 : begin codeword[58]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b0001111100011010 : begin codeword[58]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b0100000010101101 : begin codeword[58]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0110000110110110 : begin codeword[57]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1110111100001011 : begin codeword[57]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1010100011111010 : begin codeword[57]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0010010000101101 : begin codeword[57]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0110001011101001 : begin codeword[57]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0100000110001011 : begin codeword[57]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1111111110111010 : begin codeword[57]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1010000000001101 : begin codeword[57]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0001000111100110 : begin codeword[56]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1001111101011011 : begin codeword[56]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1101100010101010 : begin codeword[56]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0101010001111101 : begin codeword[56]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0001001010111001 : begin codeword[56]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0011000111011011 : begin codeword[56]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1000111111101010 : begin codeword[56]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1101000001011101 : begin codeword[56]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b1001001010011101 : begin codeword[63]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1010000001001110 : begin codeword[63]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1011100110001000 : begin codeword[63]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0001101011101011 : begin codeword[63]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1110010001110101 : begin codeword[63]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1001101100111010 : begin codeword[63]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0000101110110010 : begin codeword[63]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0100001111110110 : begin codeword[63]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0111101100110010 : begin codeword[62]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0100100111100001 : begin codeword[62]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0101000000100111 : begin codeword[62]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1111001101000100 : begin codeword[62]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0000110111011010 : begin codeword[62]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0111001010010101 : begin codeword[62]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1110001000011101 : begin codeword[62]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1010101001011001 : begin codeword[62]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1010000011001010 : begin codeword[61]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1001001000011001 : begin codeword[61]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1000101111011111 : begin codeword[61]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0010100010111100 : begin codeword[61]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1101011000100010 : begin codeword[61]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1010100101101101 : begin codeword[61]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0011100111100101 : begin codeword[61]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0111000110100001 : begin codeword[61]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0110001010110110 : begin codeword[60]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0101000001100101 : begin codeword[60]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0100100110100011 : begin codeword[60]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1110101011000000 : begin codeword[60]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0001010001011110 : begin codeword[60]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0110101100010001 : begin codeword[60]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1111101110011001 : begin codeword[60]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1011001111011101 : begin codeword[60]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0000001110001000 : begin codeword[59]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0011000101011011 : begin codeword[59]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0010100010011101 : begin codeword[59]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1000101111111110 : begin codeword[59]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0111010101100000 : begin codeword[59]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0000101000101111 : begin codeword[59]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1001101010100111 : begin codeword[59]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1101001011100011 : begin codeword[59]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1001110010010111 : begin codeword[58]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1010111001000100 : begin codeword[58]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1011011110000010 : begin codeword[58]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0001010011100001 : begin codeword[58]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1110101001111111 : begin codeword[58]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1001010100110000 : begin codeword[58]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0000010110111000 : begin codeword[58]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0100110111111100 : begin codeword[58]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0111110000110111 : begin codeword[57]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0100111011100100 : begin codeword[57]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0101011100100010 : begin codeword[57]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1111010001000001 : begin codeword[57]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0000101011011111 : begin codeword[57]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0111010110010000 : begin codeword[57]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1110010100011000 : begin codeword[57]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1010110101011100 : begin codeword[57]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0000110001100111 : begin codeword[56]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0011111010110100 : begin codeword[56]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0010011101110010 : begin codeword[56]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1000010000010001 : begin codeword[56]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0111101010001111 : begin codeword[56]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0000010111000000 : begin codeword[56]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1001010101001000 : begin codeword[56]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1101110100001100 : begin codeword[56]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0010111011000100 : begin codeword[63]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1111111011001101 : begin codeword[63]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1001011001100110 : begin codeword[63]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1010001010011100 : begin codeword[63]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1011100011100001 : begin codeword[63]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1011010101110000 : begin codeword[63]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0001110010010111 : begin codeword[63]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1110011101001011 : begin codeword[63]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1100011101101011 : begin codeword[62]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0001011101100010 : begin codeword[62]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0111111111001001 : begin codeword[62]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0100101100110011 : begin codeword[62]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0101000101001110 : begin codeword[62]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0101110011011111 : begin codeword[62]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1111010100111000 : begin codeword[62]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0000111011100100 : begin codeword[62]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0001110010010011 : begin codeword[61]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1100110010011010 : begin codeword[61]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1010010000110001 : begin codeword[61]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1001000011001011 : begin codeword[61]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1000101010110110 : begin codeword[61]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1000011100100111 : begin codeword[61]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0010111011000000 : begin codeword[61]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1101010100011100 : begin codeword[61]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1101111011101111 : begin codeword[60]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0000111011100110 : begin codeword[60]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0110011001001101 : begin codeword[60]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0101001010110111 : begin codeword[60]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0100100011001010 : begin codeword[60]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0100010101011011 : begin codeword[60]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1110110010111100 : begin codeword[60]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0001011101100000 : begin codeword[60]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1011111111010001 : begin codeword[59]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0110111111011000 : begin codeword[59]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0000011101110011 : begin codeword[59]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0011001110001001 : begin codeword[59]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0010100111110100 : begin codeword[59]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0010010001100101 : begin codeword[59]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1000110110000010 : begin codeword[59]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0111011001011110 : begin codeword[59]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0010000011001110 : begin codeword[58]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1111000011000111 : begin codeword[58]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1001100001101100 : begin codeword[58]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1010110010010110 : begin codeword[58]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1011011011101011 : begin codeword[58]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1011101101111010 : begin codeword[58]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0001001010011101 : begin codeword[58]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1110100101000001 : begin codeword[58]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1100000001101110 : begin codeword[57]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0001000001100111 : begin codeword[57]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0111100011001100 : begin codeword[57]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0100110000110110 : begin codeword[57]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0101011001001011 : begin codeword[57]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0101101111011010 : begin codeword[57]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1111001000111101 : begin codeword[57]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0000100111100001 : begin codeword[57]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1011000000111110 : begin codeword[56]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0110000000110111 : begin codeword[56]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0000100010011100 : begin codeword[56]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0011110001100110 : begin codeword[56]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0010011000011011 : begin codeword[56]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0010101110001010 : begin codeword[56]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1000001001101101 : begin codeword[56]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0111100110110001 : begin codeword[56]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0011010001110110 : begin codeword[63]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1111001110010100 : begin codeword[63]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0011111111100101 : begin codeword[63]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0101100101110010 : begin codeword[63]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0110101010010110 : begin codeword[63]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1101110011100100 : begin codeword[63]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1000011111011101 : begin codeword[63]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0000010101101110 : begin codeword[63]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1101110111011001 : begin codeword[62]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0001101000111011 : begin codeword[62]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1101011001001010 : begin codeword[62]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1011000011011101 : begin codeword[62]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1000001100111001 : begin codeword[62]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0011010101001011 : begin codeword[62]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0110111001110010 : begin codeword[62]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1110110011000001 : begin codeword[62]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0000011000100001 : begin codeword[61]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1100000111000011 : begin codeword[61]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0000110110110010 : begin codeword[61]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0110101100100101 : begin codeword[61]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0101100011000001 : begin codeword[61]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1110111010110011 : begin codeword[61]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1011010110001010 : begin codeword[61]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0011011100111001 : begin codeword[61]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1100010001011101 : begin codeword[60]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0000001110111111 : begin codeword[60]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1100111111001110 : begin codeword[60]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1010100101011001 : begin codeword[60]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1001101010111101 : begin codeword[60]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0010110011001111 : begin codeword[60]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0111011111110110 : begin codeword[60]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1111010101000101 : begin codeword[60]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1010010101100011 : begin codeword[59]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0110001010000001 : begin codeword[59]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1010111011110000 : begin codeword[59]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1100100001100111 : begin codeword[59]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1111101110000011 : begin codeword[59]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0100110111110001 : begin codeword[59]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0001011011001000 : begin codeword[59]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1001010001111011 : begin codeword[59]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0011101001111100 : begin codeword[58]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1111110110011110 : begin codeword[58]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0011000111101111 : begin codeword[58]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0101011101111000 : begin codeword[58]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0110010010011100 : begin codeword[58]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1101001011101110 : begin codeword[58]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1000100111010111 : begin codeword[58]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0000101101100100 : begin codeword[58]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1101101011011100 : begin codeword[57]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0001110100111110 : begin codeword[57]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1101000101001111 : begin codeword[57]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1011011111011000 : begin codeword[57]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1000010000111100 : begin codeword[57]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0011001001001110 : begin codeword[57]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0110100101110111 : begin codeword[57]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1110101111000100 : begin codeword[57]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1010101010001100 : begin codeword[56]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0110110101101110 : begin codeword[56]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1010000100011111 : begin codeword[56]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1100011110001000 : begin codeword[56]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1111010001101100 : begin codeword[56]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0100001000011110 : begin codeword[56]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0001100100100111 : begin codeword[56]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1001101110010100 : begin codeword[56]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1111101111001010 : begin codeword[63]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0011101111001010 : begin codeword[63]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0101101111001010 : begin codeword[63]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0110101111001010 : begin codeword[63]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0111001111001010 : begin codeword[63]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0111111111001010 : begin codeword[63]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0111100111001010 : begin codeword[63]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0111101011001010 : begin codeword[63]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0001001001100101 : begin codeword[62]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1101001001100101 : begin codeword[62]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1011001001100101 : begin codeword[62]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1000001001100101 : begin codeword[62]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1001101001100101 : begin codeword[62]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1001011001100101 : begin codeword[62]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1001000001100101 : begin codeword[62]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1001001101100101 : begin codeword[62]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1100100110011101 : begin codeword[61]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0000100110011101 : begin codeword[61]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0110100110011101 : begin codeword[61]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0101100110011101 : begin codeword[61]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0100000110011101 : begin codeword[61]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0100110110011101 : begin codeword[61]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0100101110011101 : begin codeword[61]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0100100010011101 : begin codeword[61]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0000101111100001 : begin codeword[60]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1100101111100001 : begin codeword[60]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1010101111100001 : begin codeword[60]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1001101111100001 : begin codeword[60]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1000001111100001 : begin codeword[60]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1000111111100001 : begin codeword[60]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1000100111100001 : begin codeword[60]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1000101011100001 : begin codeword[60]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0110101011011111 : begin codeword[59]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1010101011011111 : begin codeword[59]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1100101011011111 : begin codeword[59]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1111101011011111 : begin codeword[59]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1110001011011111 : begin codeword[59]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1110111011011111 : begin codeword[59]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1110100011011111 : begin codeword[59]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1110101111011111 : begin codeword[59]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1111010111000000 : begin codeword[58]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0011010111000000 : begin codeword[58]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0101010111000000 : begin codeword[58]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0110010111000000 : begin codeword[58]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0111110111000000 : begin codeword[58]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0111000111000000 : begin codeword[58]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0111011111000000 : begin codeword[58]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0111010011000000 : begin codeword[58]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0001010101100000 : begin codeword[57]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1101010101100000 : begin codeword[57]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1011010101100000 : begin codeword[57]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1000010101100000 : begin codeword[57]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1001110101100000 : begin codeword[57]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1001000101100000 : begin codeword[57]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1001011101100000 : begin codeword[57]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1001010001100000 : begin codeword[57]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0110010100110000 : begin codeword[56]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1010010100110000 : begin codeword[56]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1100010100110000 : begin codeword[56]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1111010100110000 : begin codeword[56]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1110110100110000 : begin codeword[56]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1110000100110000 : begin codeword[56]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1110011100110000 : begin codeword[56]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1110010000110000 : begin codeword[56]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0111101101001010 : begin codeword[63]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0111101110001010 : begin codeword[63]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0111101111101010 : begin codeword[63]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0111101111011010 : begin codeword[63]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0111101111000010 : begin codeword[63]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0111101111001110 : begin codeword[63]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0111101111001000 : begin codeword[63]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0111101111001011 : begin codeword[63]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1001001011100101 : begin codeword[62]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1001001000100101 : begin codeword[62]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1001001001000101 : begin codeword[62]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1001001001110101 : begin codeword[62]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1001001001101101 : begin codeword[62]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1001001001100001 : begin codeword[62]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1001001001100111 : begin codeword[62]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1001001001100100 : begin codeword[62]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0100100100011101 : begin codeword[61]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0100100111011101 : begin codeword[61]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0100100110111101 : begin codeword[61]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0100100110001101 : begin codeword[61]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0100100110010101 : begin codeword[61]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0100100110011001 : begin codeword[61]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0100100110011111 : begin codeword[61]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0100100110011100 : begin codeword[61]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1000101101100001 : begin codeword[60]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1000101110100001 : begin codeword[60]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1000101111000001 : begin codeword[60]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1000101111110001 : begin codeword[60]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1000101111101001 : begin codeword[60]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1000101111100101 : begin codeword[60]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1000101111100011 : begin codeword[60]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1000101111100000 : begin codeword[60]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1110101001011111 : begin codeword[59]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1110101010011111 : begin codeword[59]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1110101011111111 : begin codeword[59]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1110101011001111 : begin codeword[59]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1110101011010111 : begin codeword[59]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1110101011011011 : begin codeword[59]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1110101011011101 : begin codeword[59]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1110101011011110 : begin codeword[59]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0111010101000000 : begin codeword[58]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0111010110000000 : begin codeword[58]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0111010111100000 : begin codeword[58]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0111010111010000 : begin codeword[58]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0111010111001000 : begin codeword[58]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0111010111000100 : begin codeword[58]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0111010111000010 : begin codeword[58]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0111010111000001 : begin codeword[58]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1001010111100000 : begin codeword[57]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1001010100100000 : begin codeword[57]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1001010101000000 : begin codeword[57]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1001010101110000 : begin codeword[57]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1001010101101000 : begin codeword[57]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1001010101100100 : begin codeword[57]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1001010101100010 : begin codeword[57]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1001010101100001 : begin codeword[57]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1110010110110000 : begin codeword[56]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1110010101110000 : begin codeword[56]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1110010100010000 : begin codeword[56]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1110010100100000 : begin codeword[56]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1110010100111000 : begin codeword[56]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1110010100110100 : begin codeword[56]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1110010100110010 : begin codeword[56]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1110010100110001 : begin codeword[56]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0000010001111100 : begin codeword[55]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1000101011000001 : begin codeword[55]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1100110100110000 : begin codeword[55]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0100000111100111 : begin codeword[55]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0000011100100011 : begin codeword[55]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0010010001000001 : begin codeword[55]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1001101001110000 : begin codeword[55]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1100010111000111 : begin codeword[55]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b1000110010000011 : begin codeword[54]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b0000001000111110 : begin codeword[54]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b0100010111001111 : begin codeword[54]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b1100100100011000 : begin codeword[54]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b1000111111011100 : begin codeword[54]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b1010110010111110 : begin codeword[54]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b0001001010001111 : begin codeword[54]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b0100110100111000 : begin codeword[54]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b1100100001010011 : begin codeword[53]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b0100011011101110 : begin codeword[53]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b0000000100011111 : begin codeword[53]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b1000110111001000 : begin codeword[53]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b1100101100001100 : begin codeword[53]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b1110100001101110 : begin codeword[53]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b0101011001011111 : begin codeword[53]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b0000100111101000 : begin codeword[53]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b1110101000111011 : begin codeword[52]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b0110010010000110 : begin codeword[52]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b0010001101110111 : begin codeword[52]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b1010111110100000 : begin codeword[52]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b1110100101100100 : begin codeword[52]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b1100101000000110 : begin codeword[52]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b0111010000110111 : begin codeword[52]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b0010101110000000 : begin codeword[52]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b1111101100001111 : begin codeword[51]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b0111010110110010 : begin codeword[51]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b0011001001000011 : begin codeword[51]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b1011111010010100 : begin codeword[51]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b1111100001010000 : begin codeword[51]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b1101101100110010 : begin codeword[51]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b0110010100000011 : begin codeword[51]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b0011101010110100 : begin codeword[51]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0101110000010101 : begin codeword[50]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b1101001010101000 : begin codeword[50]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b1001010101011001 : begin codeword[50]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b0001100110001110 : begin codeword[50]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b0101111101001010 : begin codeword[50]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b0111110000101000 : begin codeword[50]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b1100001000011001 : begin codeword[50]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b1001110110101110 : begin codeword[50]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b1010000000011000 : begin codeword[49]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b0010111010100101 : begin codeword[49]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b0110100101010100 : begin codeword[49]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b1110010110000011 : begin codeword[49]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b1010001101000111 : begin codeword[49]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b1000000000100101 : begin codeword[49]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b0011111000010100 : begin codeword[49]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b0110000110100011 : begin codeword[49]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b1101111010110001 : begin codeword[48]^=1'b1; codeword[47]^=1'b1; decode_result=1'b0; end
         16'b0101000000001100 : begin codeword[48]^=1'b1; codeword[46]^=1'b1; decode_result=1'b0; end
         16'b0001011111111101 : begin codeword[48]^=1'b1; codeword[45]^=1'b1; decode_result=1'b0; end
         16'b1001101100101010 : begin codeword[48]^=1'b1; codeword[44]^=1'b1; decode_result=1'b0; end
         16'b1101110111101110 : begin codeword[48]^=1'b1; codeword[43]^=1'b1; decode_result=1'b0; end
         16'b1111111010001100 : begin codeword[48]^=1'b1; codeword[42]^=1'b1; decode_result=1'b0; end
         16'b0100000010111101 : begin codeword[48]^=1'b1; codeword[41]^=1'b1; decode_result=1'b0; end
         16'b0001111100001010 : begin codeword[48]^=1'b1; codeword[40]^=1'b1; decode_result=1'b0; end
         16'b0001100111111101 : begin codeword[55]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0010101100101110 : begin codeword[55]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0011001011101000 : begin codeword[55]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1001000110001011 : begin codeword[55]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0110111100010101 : begin codeword[55]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0001000001011010 : begin codeword[55]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1000000011010010 : begin codeword[55]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1100100010010110 : begin codeword[55]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1001000100000010 : begin codeword[54]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1010001111010001 : begin codeword[54]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1011101000010111 : begin codeword[54]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0001100101110100 : begin codeword[54]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1110011111101010 : begin codeword[54]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1001100010100101 : begin codeword[54]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0000100000101101 : begin codeword[54]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0100000001101001 : begin codeword[54]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1101010111010010 : begin codeword[53]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1110011100000001 : begin codeword[53]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1111111011000111 : begin codeword[53]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0101110110100100 : begin codeword[53]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1010001100111010 : begin codeword[53]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1101110001110101 : begin codeword[53]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0100110011111101 : begin codeword[53]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0000010010111001 : begin codeword[53]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1111011110111010 : begin codeword[52]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1100010101101001 : begin codeword[52]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1101110010101111 : begin codeword[52]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0111111111001100 : begin codeword[52]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1000000101010010 : begin codeword[52]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1111111000011101 : begin codeword[52]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0110111010010101 : begin codeword[52]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0010011011010001 : begin codeword[52]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1110011010001110 : begin codeword[51]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1101010001011101 : begin codeword[51]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1100110110011011 : begin codeword[51]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0110111011111000 : begin codeword[51]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1001000001100110 : begin codeword[51]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1110111100101001 : begin codeword[51]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0111111110100001 : begin codeword[51]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0011011111100101 : begin codeword[51]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0100000110010100 : begin codeword[50]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0111001101000111 : begin codeword[50]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0110101010000001 : begin codeword[50]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1100100111100010 : begin codeword[50]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0011011101111100 : begin codeword[50]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0100100000110011 : begin codeword[50]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1101100010111011 : begin codeword[50]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1001000011111111 : begin codeword[50]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1011110110011001 : begin codeword[49]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1000111101001010 : begin codeword[49]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1001011010001100 : begin codeword[49]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0011010111101111 : begin codeword[49]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1100101101110001 : begin codeword[49]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1011010000111110 : begin codeword[49]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0010010010110110 : begin codeword[49]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0110110011110010 : begin codeword[49]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1100001100110000 : begin codeword[48]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1111000111100011 : begin codeword[48]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1110100000100101 : begin codeword[48]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0100101101000110 : begin codeword[48]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1011010111011000 : begin codeword[48]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1100101010010111 : begin codeword[48]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0101101000011111 : begin codeword[48]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0001001001011011 : begin codeword[48]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1010010110100100 : begin codeword[55]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0111010110101101 : begin codeword[55]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0001110100000110 : begin codeword[55]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0010100111111100 : begin codeword[55]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0011001110000001 : begin codeword[55]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0011111000010000 : begin codeword[55]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1001011111110111 : begin codeword[55]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0110110000101011 : begin codeword[55]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0010110101011011 : begin codeword[54]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1111110101010010 : begin codeword[54]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1001010111111001 : begin codeword[54]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1010000100000011 : begin codeword[54]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1011101101111110 : begin codeword[54]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1011011011101111 : begin codeword[54]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0001111100001000 : begin codeword[54]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1110010011010100 : begin codeword[54]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0110100110001011 : begin codeword[53]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1011100110000010 : begin codeword[53]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1101000100101001 : begin codeword[53]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1110010111010011 : begin codeword[53]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1111111110101110 : begin codeword[53]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1111001000111111 : begin codeword[53]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0101101111011000 : begin codeword[53]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1010000000000100 : begin codeword[53]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0100101111100011 : begin codeword[52]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1001101111101010 : begin codeword[52]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1111001101000001 : begin codeword[52]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1100011110111011 : begin codeword[52]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1101110111000110 : begin codeword[52]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1101000001010111 : begin codeword[52]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0111100110110000 : begin codeword[52]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1000001001101100 : begin codeword[52]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0101101011010111 : begin codeword[51]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1000101011011110 : begin codeword[51]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1110001001110101 : begin codeword[51]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1101011010001111 : begin codeword[51]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1100110011110010 : begin codeword[51]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1100000101100011 : begin codeword[51]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0110100010000100 : begin codeword[51]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1001001101011000 : begin codeword[51]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1111110111001101 : begin codeword[50]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0010110111000100 : begin codeword[50]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0100010101101111 : begin codeword[50]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0111000110010101 : begin codeword[50]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0110101111101000 : begin codeword[50]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0110011001111001 : begin codeword[50]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1100111110011110 : begin codeword[50]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0011010001000010 : begin codeword[50]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0000000111000000 : begin codeword[49]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1101000111001001 : begin codeword[49]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1011100101100010 : begin codeword[49]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1000110110011000 : begin codeword[49]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1001011111100101 : begin codeword[49]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1001101001110100 : begin codeword[49]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0011001110010011 : begin codeword[49]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1100100001001111 : begin codeword[49]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0111111101101001 : begin codeword[48]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1010111101100000 : begin codeword[48]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1100011111001011 : begin codeword[48]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1111001100110001 : begin codeword[48]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1110100101001100 : begin codeword[48]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1110010011011101 : begin codeword[48]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0100110100111010 : begin codeword[48]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1011011011100110 : begin codeword[48]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1011111100010110 : begin codeword[55]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0111100011110100 : begin codeword[55]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1011010010000101 : begin codeword[55]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1101001000010010 : begin codeword[55]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1110000111110110 : begin codeword[55]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0101011110000100 : begin codeword[55]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0000110010111101 : begin codeword[55]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1000111000001110 : begin codeword[55]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0011011111101001 : begin codeword[54]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1111000000001011 : begin codeword[54]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0011110001111010 : begin codeword[54]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0101101011101101 : begin codeword[54]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0110100100001001 : begin codeword[54]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1101111101111011 : begin codeword[54]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1000010001000010 : begin codeword[54]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0000011011110001 : begin codeword[54]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0111001100111001 : begin codeword[53]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1011010011011011 : begin codeword[53]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0111100010101010 : begin codeword[53]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0001111000111101 : begin codeword[53]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0010110111011001 : begin codeword[53]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1001101110101011 : begin codeword[53]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1100000010010010 : begin codeword[53]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0100001000100001 : begin codeword[53]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0101000101010001 : begin codeword[52]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1001011010110011 : begin codeword[52]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0101101011000010 : begin codeword[52]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0011110001010101 : begin codeword[52]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0000111110110001 : begin codeword[52]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1011100111000011 : begin codeword[52]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1110001011111010 : begin codeword[52]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0110000001001001 : begin codeword[52]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0100000001100101 : begin codeword[51]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1000011110000111 : begin codeword[51]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0100101111110110 : begin codeword[51]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0010110101100001 : begin codeword[51]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0001111010000101 : begin codeword[51]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1010100011110111 : begin codeword[51]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1111001111001110 : begin codeword[51]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0111000101111101 : begin codeword[51]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1110011101111111 : begin codeword[50]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0010000010011101 : begin codeword[50]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1110110011101100 : begin codeword[50]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1000101001111011 : begin codeword[50]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1011100110011111 : begin codeword[50]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0000111111101101 : begin codeword[50]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0101010011010100 : begin codeword[50]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1101011001100111 : begin codeword[50]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0001101101110010 : begin codeword[49]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1101110010010000 : begin codeword[49]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0001000011100001 : begin codeword[49]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0111011001110110 : begin codeword[49]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0100010110010010 : begin codeword[49]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1111001111100000 : begin codeword[49]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1010100011011001 : begin codeword[49]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0010101001101010 : begin codeword[49]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0110010111011011 : begin codeword[48]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1010001000111001 : begin codeword[48]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0110111001001000 : begin codeword[48]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0000100011011111 : begin codeword[48]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0011101100111011 : begin codeword[48]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1000110101001001 : begin codeword[48]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1101011001110000 : begin codeword[48]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0101010011000011 : begin codeword[48]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0111000010101010 : begin codeword[55]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1011000010101010 : begin codeword[55]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1101000010101010 : begin codeword[55]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1110000010101010 : begin codeword[55]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1111100010101010 : begin codeword[55]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1111010010101010 : begin codeword[55]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1111001010101010 : begin codeword[55]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1111000110101010 : begin codeword[55]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1111100001010101 : begin codeword[54]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0011100001010101 : begin codeword[54]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0101100001010101 : begin codeword[54]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0110100001010101 : begin codeword[54]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0111000001010101 : begin codeword[54]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0111110001010101 : begin codeword[54]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0111101001010101 : begin codeword[54]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0111100101010101 : begin codeword[54]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1011110010000101 : begin codeword[53]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0111110010000101 : begin codeword[53]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0001110010000101 : begin codeword[53]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0010110010000101 : begin codeword[53]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0011010010000101 : begin codeword[53]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0011100010000101 : begin codeword[53]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0011111010000101 : begin codeword[53]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0011110110000101 : begin codeword[53]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1001111011101101 : begin codeword[52]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0101111011101101 : begin codeword[52]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0011111011101101 : begin codeword[52]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0000111011101101 : begin codeword[52]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0001011011101101 : begin codeword[52]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0001101011101101 : begin codeword[52]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0001110011101101 : begin codeword[52]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0001111111101101 : begin codeword[52]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1000111111011001 : begin codeword[51]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0100111111011001 : begin codeword[51]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0010111111011001 : begin codeword[51]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0001111111011001 : begin codeword[51]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0000011111011001 : begin codeword[51]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0000101111011001 : begin codeword[51]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0000110111011001 : begin codeword[51]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0000111011011001 : begin codeword[51]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0010100011000011 : begin codeword[50]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1110100011000011 : begin codeword[50]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1000100011000011 : begin codeword[50]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1011100011000011 : begin codeword[50]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1010000011000011 : begin codeword[50]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1010110011000011 : begin codeword[50]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1010101011000011 : begin codeword[50]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1010100111000011 : begin codeword[50]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1101010011001110 : begin codeword[49]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0001010011001110 : begin codeword[49]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0111010011001110 : begin codeword[49]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0100010011001110 : begin codeword[49]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0101110011001110 : begin codeword[49]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0101000011001110 : begin codeword[49]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0101011011001110 : begin codeword[49]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0101010111001110 : begin codeword[49]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1010101001100111 : begin codeword[48]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0110101001100111 : begin codeword[48]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0000101001100111 : begin codeword[48]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0011101001100111 : begin codeword[48]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0010001001100111 : begin codeword[48]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0010111001100111 : begin codeword[48]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0010100001100111 : begin codeword[48]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0010101101100111 : begin codeword[48]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1111000000101010 : begin codeword[55]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1111000011101010 : begin codeword[55]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1111000010001010 : begin codeword[55]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1111000010111010 : begin codeword[55]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1111000010100010 : begin codeword[55]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1111000010101110 : begin codeword[55]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1111000010101000 : begin codeword[55]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1111000010101011 : begin codeword[55]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0111100011010101 : begin codeword[54]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0111100000010101 : begin codeword[54]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0111100001110101 : begin codeword[54]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0111100001000101 : begin codeword[54]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0111100001011101 : begin codeword[54]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0111100001010001 : begin codeword[54]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0111100001010111 : begin codeword[54]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0111100001010100 : begin codeword[54]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0011110000000101 : begin codeword[53]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0011110011000101 : begin codeword[53]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0011110010100101 : begin codeword[53]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0011110010010101 : begin codeword[53]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0011110010001101 : begin codeword[53]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0011110010000001 : begin codeword[53]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0011110010000111 : begin codeword[53]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0011110010000100 : begin codeword[53]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0001111001101101 : begin codeword[52]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0001111010101101 : begin codeword[52]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0001111011001101 : begin codeword[52]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0001111011111101 : begin codeword[52]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0001111011100101 : begin codeword[52]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0001111011101001 : begin codeword[52]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0001111011101111 : begin codeword[52]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0001111011101100 : begin codeword[52]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0000111101011001 : begin codeword[51]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0000111110011001 : begin codeword[51]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0000111111111001 : begin codeword[51]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0000111111001001 : begin codeword[51]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0000111111010001 : begin codeword[51]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0000111111011101 : begin codeword[51]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0000111111011011 : begin codeword[51]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0000111111011000 : begin codeword[51]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1010100001000011 : begin codeword[50]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1010100010000011 : begin codeword[50]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1010100011100011 : begin codeword[50]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1010100011010011 : begin codeword[50]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1010100011001011 : begin codeword[50]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1010100011000111 : begin codeword[50]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1010100011000001 : begin codeword[50]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1010100011000010 : begin codeword[50]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0101010001001110 : begin codeword[49]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0101010010001110 : begin codeword[49]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0101010011101110 : begin codeword[49]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0101010011011110 : begin codeword[49]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0101010011000110 : begin codeword[49]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0101010011001010 : begin codeword[49]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0101010011001100 : begin codeword[49]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0101010011001111 : begin codeword[49]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0010101011100111 : begin codeword[48]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0010101000100111 : begin codeword[48]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0010101001000111 : begin codeword[48]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0010101001110111 : begin codeword[48]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0010101001101111 : begin codeword[48]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0010101001100011 : begin codeword[48]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0010101001100101 : begin codeword[48]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0010101001100110 : begin codeword[48]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0001110110000001 : begin codeword[47]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0010111101010010 : begin codeword[47]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0011011010010100 : begin codeword[47]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1001010111110111 : begin codeword[47]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0110101101101001 : begin codeword[47]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0001010000100110 : begin codeword[47]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1000010010101110 : begin codeword[47]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1100110011101010 : begin codeword[47]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1001001100111100 : begin codeword[46]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1010000111101111 : begin codeword[46]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1011100000101001 : begin codeword[46]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0001101101001010 : begin codeword[46]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1110010111010100 : begin codeword[46]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1001101010011011 : begin codeword[46]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0000101000010011 : begin codeword[46]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0100001001010111 : begin codeword[46]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1101010011001101 : begin codeword[45]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1110011000011110 : begin codeword[45]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1111111111011000 : begin codeword[45]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0101110010111011 : begin codeword[45]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1010001000100101 : begin codeword[45]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1101110101101010 : begin codeword[45]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0100110111100010 : begin codeword[45]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0000010110100110 : begin codeword[45]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0101100000011010 : begin codeword[44]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0110101011001001 : begin codeword[44]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0111001100001111 : begin codeword[44]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1101000001101100 : begin codeword[44]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0010111011110010 : begin codeword[44]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0101000110111101 : begin codeword[44]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1100000100110101 : begin codeword[44]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1000100101110001 : begin codeword[44]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0001111011011110 : begin codeword[43]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0010110000001101 : begin codeword[43]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0011010111001011 : begin codeword[43]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1001011010101000 : begin codeword[43]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0110100000110110 : begin codeword[43]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0001011101111001 : begin codeword[43]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1000011111110001 : begin codeword[43]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1100111110110101 : begin codeword[43]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b0011110110111100 : begin codeword[42]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b0000111101101111 : begin codeword[42]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b0001011010101001 : begin codeword[42]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b1011010111001010 : begin codeword[42]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b0100101101010100 : begin codeword[42]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b0011010000011011 : begin codeword[42]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b1010010010010011 : begin codeword[42]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b1110110011010111 : begin codeword[42]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1000001110001101 : begin codeword[41]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1011000101011110 : begin codeword[41]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1010100010011000 : begin codeword[41]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0000101111111011 : begin codeword[41]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1111010101100101 : begin codeword[41]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1000101000101010 : begin codeword[41]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0001101010100010 : begin codeword[41]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0101001011100110 : begin codeword[41]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1101110000111010 : begin codeword[40]^=1'b1; codeword[39]^=1'b1; decode_result=1'b0; end
         16'b1110111011101001 : begin codeword[40]^=1'b1; codeword[38]^=1'b1; decode_result=1'b0; end
         16'b1111011100101111 : begin codeword[40]^=1'b1; codeword[37]^=1'b1; decode_result=1'b0; end
         16'b0101010001001100 : begin codeword[40]^=1'b1; codeword[36]^=1'b1; decode_result=1'b0; end
         16'b1010101011010010 : begin codeword[40]^=1'b1; codeword[35]^=1'b1; decode_result=1'b0; end
         16'b1101010110011101 : begin codeword[40]^=1'b1; codeword[34]^=1'b1; decode_result=1'b0; end
         16'b0100010100010101 : begin codeword[40]^=1'b1; codeword[33]^=1'b1; decode_result=1'b0; end
         16'b0000110101010001 : begin codeword[40]^=1'b1; codeword[32]^=1'b1; decode_result=1'b0; end
         16'b1010000111011000 : begin codeword[47]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0111000111010001 : begin codeword[47]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0001100101111010 : begin codeword[47]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0010110110000000 : begin codeword[47]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0011011111111101 : begin codeword[47]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0011101001101100 : begin codeword[47]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1001001110001011 : begin codeword[47]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0110100001010111 : begin codeword[47]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0010111101100101 : begin codeword[46]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1111111101101100 : begin codeword[46]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1001011111000111 : begin codeword[46]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1010001100111101 : begin codeword[46]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1011100101000000 : begin codeword[46]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1011010011010001 : begin codeword[46]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0001110100110110 : begin codeword[46]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1110011011101010 : begin codeword[46]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0110100010010100 : begin codeword[45]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1011100010011101 : begin codeword[45]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1101000000110110 : begin codeword[45]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1110010011001100 : begin codeword[45]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1111111010110001 : begin codeword[45]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1111001100100000 : begin codeword[45]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0101101011000111 : begin codeword[45]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1010000100011011 : begin codeword[45]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1110010001000011 : begin codeword[44]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0011010001001010 : begin codeword[44]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0101110011100001 : begin codeword[44]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0110100000011011 : begin codeword[44]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0111001001100110 : begin codeword[44]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0111111111110111 : begin codeword[44]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1101011000010000 : begin codeword[44]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0010110111001100 : begin codeword[44]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1010001010000111 : begin codeword[43]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0111001010001110 : begin codeword[43]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0001101000100101 : begin codeword[43]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0010111011011111 : begin codeword[43]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0011010010100010 : begin codeword[43]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0011100100110011 : begin codeword[43]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1001000011010100 : begin codeword[43]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0110101100001000 : begin codeword[43]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1000000111100101 : begin codeword[42]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0101000111101100 : begin codeword[42]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0011100101000111 : begin codeword[42]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0000110110111101 : begin codeword[42]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0001011111000000 : begin codeword[42]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0001101001010001 : begin codeword[42]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1011001110110110 : begin codeword[42]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0100100001101010 : begin codeword[42]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0011111111010100 : begin codeword[41]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1110111111011101 : begin codeword[41]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1000011101110110 : begin codeword[41]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1011001110001100 : begin codeword[41]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1010100111110001 : begin codeword[41]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1010010001100000 : begin codeword[41]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0000110110000111 : begin codeword[41]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1111011001011011 : begin codeword[41]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0110000001100011 : begin codeword[40]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1011000001101010 : begin codeword[40]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1101100011000001 : begin codeword[40]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1110110000111011 : begin codeword[40]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1111011001000110 : begin codeword[40]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1111101111010111 : begin codeword[40]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0101001000110000 : begin codeword[40]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1010100111101100 : begin codeword[40]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1011101101101010 : begin codeword[47]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0111110010001000 : begin codeword[47]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1011000011111001 : begin codeword[47]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1101011001101110 : begin codeword[47]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1110010110001010 : begin codeword[47]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0101001111111000 : begin codeword[47]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0000100011000001 : begin codeword[47]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1000101001110010 : begin codeword[47]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0011010111010111 : begin codeword[46]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1111001000110101 : begin codeword[46]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0011111001000100 : begin codeword[46]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0101100011010011 : begin codeword[46]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0110101100110111 : begin codeword[46]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1101110101000101 : begin codeword[46]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1000011001111100 : begin codeword[46]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0000010011001111 : begin codeword[46]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0111001000100110 : begin codeword[45]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1011010111000100 : begin codeword[45]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0111100110110101 : begin codeword[45]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0001111100100010 : begin codeword[45]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0010110011000110 : begin codeword[45]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1001101010110100 : begin codeword[45]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1100000110001101 : begin codeword[45]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0100001100111110 : begin codeword[45]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1111111011110001 : begin codeword[44]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0011100100010011 : begin codeword[44]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1111010101100010 : begin codeword[44]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1001001111110101 : begin codeword[44]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1010000000010001 : begin codeword[44]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0001011001100011 : begin codeword[44]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0100110101011010 : begin codeword[44]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1100111111101001 : begin codeword[44]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1011100000110101 : begin codeword[43]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0111111111010111 : begin codeword[43]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1011001110100110 : begin codeword[43]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1101010100110001 : begin codeword[43]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1110011011010101 : begin codeword[43]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0101000010100111 : begin codeword[43]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0000101110011110 : begin codeword[43]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1000100100101101 : begin codeword[43]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1001101101010111 : begin codeword[42]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0101110010110101 : begin codeword[42]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1001000011000100 : begin codeword[42]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1111011001010011 : begin codeword[42]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1100010110110111 : begin codeword[42]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0111001111000101 : begin codeword[42]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0010100011111100 : begin codeword[42]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1010101001001111 : begin codeword[42]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0010010101100110 : begin codeword[41]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1110001010000100 : begin codeword[41]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0010111011110101 : begin codeword[41]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0100100001100010 : begin codeword[41]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0111101110000110 : begin codeword[41]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1100110111110100 : begin codeword[41]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1001011011001101 : begin codeword[41]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0001010001111110 : begin codeword[41]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0111101011010001 : begin codeword[40]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1011110100110011 : begin codeword[40]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0111000101000010 : begin codeword[40]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0001011111010101 : begin codeword[40]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0010010000110001 : begin codeword[40]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1001001001000011 : begin codeword[40]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1100100101111010 : begin codeword[40]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0100101111001001 : begin codeword[40]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0111010011010110 : begin codeword[47]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1011010011010110 : begin codeword[47]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1101010011010110 : begin codeword[47]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1110010011010110 : begin codeword[47]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1111110011010110 : begin codeword[47]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1111000011010110 : begin codeword[47]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1111011011010110 : begin codeword[47]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1111010111010110 : begin codeword[47]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1111101001101011 : begin codeword[46]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0011101001101011 : begin codeword[46]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0101101001101011 : begin codeword[46]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0110101001101011 : begin codeword[46]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0111001001101011 : begin codeword[46]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0111111001101011 : begin codeword[46]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0111100001101011 : begin codeword[46]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0111101101101011 : begin codeword[46]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1011110110011010 : begin codeword[45]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0111110110011010 : begin codeword[45]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0001110110011010 : begin codeword[45]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0010110110011010 : begin codeword[45]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0011010110011010 : begin codeword[45]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0011100110011010 : begin codeword[45]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0011111110011010 : begin codeword[45]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0011110010011010 : begin codeword[45]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0011000101001101 : begin codeword[44]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1111000101001101 : begin codeword[44]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1001000101001101 : begin codeword[44]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1010000101001101 : begin codeword[44]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1011100101001101 : begin codeword[44]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1011010101001101 : begin codeword[44]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1011001101001101 : begin codeword[44]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1011000001001101 : begin codeword[44]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0111011110001001 : begin codeword[43]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1011011110001001 : begin codeword[43]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1101011110001001 : begin codeword[43]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1110011110001001 : begin codeword[43]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1111111110001001 : begin codeword[43]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1111001110001001 : begin codeword[43]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1111010110001001 : begin codeword[43]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1111011010001001 : begin codeword[43]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0101010011101011 : begin codeword[42]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1001010011101011 : begin codeword[42]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1111010011101011 : begin codeword[42]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1100010011101011 : begin codeword[42]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1101110011101011 : begin codeword[42]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1101000011101011 : begin codeword[42]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1101011011101011 : begin codeword[42]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1101010111101011 : begin codeword[42]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1110101011011010 : begin codeword[41]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0010101011011010 : begin codeword[41]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0100101011011010 : begin codeword[41]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0111101011011010 : begin codeword[41]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0110001011011010 : begin codeword[41]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0110111011011010 : begin codeword[41]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0110100011011010 : begin codeword[41]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0110101111011010 : begin codeword[41]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1011010101101101 : begin codeword[40]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0111010101101101 : begin codeword[40]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0001010101101101 : begin codeword[40]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0010010101101101 : begin codeword[40]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0011110101101101 : begin codeword[40]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0011000101101101 : begin codeword[40]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0011011101101101 : begin codeword[40]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0011010001101101 : begin codeword[40]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1111010001010110 : begin codeword[47]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1111010010010110 : begin codeword[47]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1111010011110110 : begin codeword[47]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1111010011000110 : begin codeword[47]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1111010011011110 : begin codeword[47]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1111010011010010 : begin codeword[47]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1111010011010100 : begin codeword[47]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1111010011010111 : begin codeword[47]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0111101011101011 : begin codeword[46]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0111101000101011 : begin codeword[46]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0111101001001011 : begin codeword[46]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0111101001111011 : begin codeword[46]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0111101001100011 : begin codeword[46]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0111101001101111 : begin codeword[46]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0111101001101001 : begin codeword[46]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0111101001101010 : begin codeword[46]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0011110100011010 : begin codeword[45]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0011110111011010 : begin codeword[45]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0011110110111010 : begin codeword[45]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0011110110001010 : begin codeword[45]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0011110110010010 : begin codeword[45]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0011110110011110 : begin codeword[45]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0011110110011000 : begin codeword[45]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0011110110011011 : begin codeword[45]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1011000111001101 : begin codeword[44]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1011000100001101 : begin codeword[44]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1011000101101101 : begin codeword[44]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1011000101011101 : begin codeword[44]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1011000101000101 : begin codeword[44]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1011000101001001 : begin codeword[44]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1011000101001111 : begin codeword[44]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1011000101001100 : begin codeword[44]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1111011100001001 : begin codeword[43]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1111011111001001 : begin codeword[43]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1111011110101001 : begin codeword[43]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1111011110011001 : begin codeword[43]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1111011110000001 : begin codeword[43]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1111011110001101 : begin codeword[43]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1111011110001011 : begin codeword[43]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1111011110001000 : begin codeword[43]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1101010001101011 : begin codeword[42]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1101010010101011 : begin codeword[42]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1101010011001011 : begin codeword[42]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1101010011111011 : begin codeword[42]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1101010011100011 : begin codeword[42]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1101010011101111 : begin codeword[42]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1101010011101001 : begin codeword[42]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1101010011101010 : begin codeword[42]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0110101001011010 : begin codeword[41]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0110101010011010 : begin codeword[41]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0110101011111010 : begin codeword[41]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0110101011001010 : begin codeword[41]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0110101011010010 : begin codeword[41]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0110101011011110 : begin codeword[41]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0110101011011000 : begin codeword[41]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0110101011011011 : begin codeword[41]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0011010111101101 : begin codeword[40]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0011010100101101 : begin codeword[40]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0011010101001101 : begin codeword[40]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0011010101111101 : begin codeword[40]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0011010101100101 : begin codeword[40]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0011010101101001 : begin codeword[40]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0011010101101111 : begin codeword[40]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0011010101101100 : begin codeword[40]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1011110001011001 : begin codeword[39]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0110110001010000 : begin codeword[39]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0000010011111011 : begin codeword[39]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0011000000000001 : begin codeword[39]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0010101001111100 : begin codeword[39]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0010011111101101 : begin codeword[39]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1000111000001010 : begin codeword[39]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0111010111010110 : begin codeword[39]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1000111010001010 : begin codeword[38]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0101111010000011 : begin codeword[38]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0011011000101000 : begin codeword[38]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0000001011010010 : begin codeword[38]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0001100010101111 : begin codeword[38]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0001010100111110 : begin codeword[38]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1011110011011001 : begin codeword[38]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0100011100000101 : begin codeword[38]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1001011101001100 : begin codeword[37]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0100011101000101 : begin codeword[37]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0010111111101110 : begin codeword[37]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0001101100010100 : begin codeword[37]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0000000101101001 : begin codeword[37]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0000110011111000 : begin codeword[37]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1010010100011111 : begin codeword[37]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0101111011000011 : begin codeword[37]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0011010000101111 : begin codeword[36]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1110010000100110 : begin codeword[36]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1000110010001101 : begin codeword[36]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1011100001110111 : begin codeword[36]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1010001000001010 : begin codeword[36]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1010111110011011 : begin codeword[36]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0000011001111100 : begin codeword[36]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1111110110100000 : begin codeword[36]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1100101010110001 : begin codeword[35]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0001101010111000 : begin codeword[35]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0111001000010011 : begin codeword[35]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0100011011101001 : begin codeword[35]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0101110010010100 : begin codeword[35]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0101000100000101 : begin codeword[35]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1111100011100010 : begin codeword[35]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0000001100111110 : begin codeword[35]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1011010111111110 : begin codeword[34]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b0110010111110111 : begin codeword[34]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b0000110101011100 : begin codeword[34]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b0011100110100110 : begin codeword[34]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b0010001111011011 : begin codeword[34]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b0010111001001010 : begin codeword[34]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b1000011110101101 : begin codeword[34]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b0111110001110001 : begin codeword[34]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0010010101110110 : begin codeword[33]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1111010101111111 : begin codeword[33]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1001110111010100 : begin codeword[33]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1010100100101110 : begin codeword[33]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1011001101010011 : begin codeword[33]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1011111011000010 : begin codeword[33]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0001011100100101 : begin codeword[33]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1110110011111001 : begin codeword[33]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b0110110100110010 : begin codeword[32]^=1'b1; codeword[31]^=1'b1; decode_result=1'b0; end
         16'b1011110100111011 : begin codeword[32]^=1'b1; codeword[30]^=1'b1; decode_result=1'b0; end
         16'b1101010110010000 : begin codeword[32]^=1'b1; codeword[29]^=1'b1; decode_result=1'b0; end
         16'b1110000101101010 : begin codeword[32]^=1'b1; codeword[28]^=1'b1; decode_result=1'b0; end
         16'b1111101100010111 : begin codeword[32]^=1'b1; codeword[27]^=1'b1; decode_result=1'b0; end
         16'b1111011010000110 : begin codeword[32]^=1'b1; codeword[26]^=1'b1; decode_result=1'b0; end
         16'b0101111101100001 : begin codeword[32]^=1'b1; codeword[25]^=1'b1; decode_result=1'b0; end
         16'b1010010010111101 : begin codeword[32]^=1'b1; codeword[24]^=1'b1; decode_result=1'b0; end
         16'b1010011011101011 : begin codeword[39]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0110000100001001 : begin codeword[39]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1010110101111000 : begin codeword[39]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1100101111101111 : begin codeword[39]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1111100000001011 : begin codeword[39]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0100111001111001 : begin codeword[39]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0001010101000000 : begin codeword[39]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1001011111110011 : begin codeword[39]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1001010000111000 : begin codeword[38]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0101001111011010 : begin codeword[38]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1001111110101011 : begin codeword[38]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1111100100111100 : begin codeword[38]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1100101011011000 : begin codeword[38]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0111110010101010 : begin codeword[38]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0010011110010011 : begin codeword[38]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1010010100100000 : begin codeword[38]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1000110111111110 : begin codeword[37]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0100101000011100 : begin codeword[37]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1000011001101101 : begin codeword[37]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1110000011111010 : begin codeword[37]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1101001100011110 : begin codeword[37]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0110010101101100 : begin codeword[37]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0011111001010101 : begin codeword[37]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1011110011100110 : begin codeword[37]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0010111010011101 : begin codeword[36]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1110100101111111 : begin codeword[36]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0010010100001110 : begin codeword[36]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0100001110011001 : begin codeword[36]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0111000001111101 : begin codeword[36]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1100011000001111 : begin codeword[36]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1001110100110110 : begin codeword[36]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0001111110000101 : begin codeword[36]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1101000000000011 : begin codeword[35]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0001011111100001 : begin codeword[35]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1101101110010000 : begin codeword[35]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1011110100000111 : begin codeword[35]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1000111011100011 : begin codeword[35]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0011100010010001 : begin codeword[35]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0110001110101000 : begin codeword[35]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1110000100011011 : begin codeword[35]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1010111101001100 : begin codeword[34]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0110100010101110 : begin codeword[34]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1010010011011111 : begin codeword[34]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1100001001001000 : begin codeword[34]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1111000110101100 : begin codeword[34]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0100011111011110 : begin codeword[34]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0001110011100111 : begin codeword[34]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1001111001010100 : begin codeword[34]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0011111111000100 : begin codeword[33]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1111100000100110 : begin codeword[33]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0011010001010111 : begin codeword[33]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0101001011000000 : begin codeword[33]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0110000100100100 : begin codeword[33]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1101011101010110 : begin codeword[33]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1000110001101111 : begin codeword[33]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0000111011011100 : begin codeword[33]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0111011110000000 : begin codeword[32]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1011000001100010 : begin codeword[32]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0111110000010011 : begin codeword[32]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0001101010000100 : begin codeword[32]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0010100101100000 : begin codeword[32]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1001111100010010 : begin codeword[32]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1100010000101011 : begin codeword[32]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0100011010011000 : begin codeword[32]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0110100101010111 : begin codeword[39]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1010100101010111 : begin codeword[39]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1100100101010111 : begin codeword[39]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1111100101010111 : begin codeword[39]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1110000101010111 : begin codeword[39]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1110110101010111 : begin codeword[39]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1110101101010111 : begin codeword[39]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1110100001010111 : begin codeword[39]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0101101110000100 : begin codeword[38]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1001101110000100 : begin codeword[38]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1111101110000100 : begin codeword[38]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1100101110000100 : begin codeword[38]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1101001110000100 : begin codeword[38]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1101111110000100 : begin codeword[38]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1101100110000100 : begin codeword[38]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1101101010000100 : begin codeword[38]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0100001001000010 : begin codeword[37]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1000001001000010 : begin codeword[37]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1110001001000010 : begin codeword[37]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1101001001000010 : begin codeword[37]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1100101001000010 : begin codeword[37]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1100011001000010 : begin codeword[37]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1100000001000010 : begin codeword[37]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1100001101000010 : begin codeword[37]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1110000100100001 : begin codeword[36]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0010000100100001 : begin codeword[36]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0100000100100001 : begin codeword[36]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0111000100100001 : begin codeword[36]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0110100100100001 : begin codeword[36]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0110010100100001 : begin codeword[36]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0110001100100001 : begin codeword[36]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0110000000100001 : begin codeword[36]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0001111110111111 : begin codeword[35]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1101111110111111 : begin codeword[35]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1011111110111111 : begin codeword[35]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1000111110111111 : begin codeword[35]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1001011110111111 : begin codeword[35]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1001101110111111 : begin codeword[35]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1001110110111111 : begin codeword[35]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1001111010111111 : begin codeword[35]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0110000011110000 : begin codeword[34]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1010000011110000 : begin codeword[34]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1100000011110000 : begin codeword[34]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1111000011110000 : begin codeword[34]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1110100011110000 : begin codeword[34]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1110010011110000 : begin codeword[34]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1110001011110000 : begin codeword[34]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1110000111110000 : begin codeword[34]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1111000001111000 : begin codeword[33]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0011000001111000 : begin codeword[33]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0101000001111000 : begin codeword[33]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0110000001111000 : begin codeword[33]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0111100001111000 : begin codeword[33]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0111010001111000 : begin codeword[33]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0111001001111000 : begin codeword[33]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0111000101111000 : begin codeword[33]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1011100000111100 : begin codeword[32]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0111100000111100 : begin codeword[32]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0001100000111100 : begin codeword[32]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0010100000111100 : begin codeword[32]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0011000000111100 : begin codeword[32]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0011110000111100 : begin codeword[32]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0011101000111100 : begin codeword[32]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0011100100111100 : begin codeword[32]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1110100111010111 : begin codeword[39]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1110100100010111 : begin codeword[39]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1110100101110111 : begin codeword[39]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1110100101000111 : begin codeword[39]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1110100101011111 : begin codeword[39]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1110100101010011 : begin codeword[39]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1110100101010101 : begin codeword[39]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1110100101010110 : begin codeword[39]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1101101100000100 : begin codeword[38]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1101101111000100 : begin codeword[38]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1101101110100100 : begin codeword[38]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1101101110010100 : begin codeword[38]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1101101110001100 : begin codeword[38]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1101101110000000 : begin codeword[38]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1101101110000110 : begin codeword[38]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1101101110000101 : begin codeword[38]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1100001011000010 : begin codeword[37]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1100001000000010 : begin codeword[37]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1100001001100010 : begin codeword[37]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1100001001010010 : begin codeword[37]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1100001001001010 : begin codeword[37]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1100001001000110 : begin codeword[37]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1100001001000000 : begin codeword[37]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1100001001000011 : begin codeword[37]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0110000110100001 : begin codeword[36]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0110000101100001 : begin codeword[36]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0110000100000001 : begin codeword[36]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0110000100110001 : begin codeword[36]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0110000100101001 : begin codeword[36]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0110000100100101 : begin codeword[36]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0110000100100011 : begin codeword[36]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0110000100100000 : begin codeword[36]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1001111100111111 : begin codeword[35]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1001111111111111 : begin codeword[35]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1001111110011111 : begin codeword[35]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1001111110101111 : begin codeword[35]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1001111110110111 : begin codeword[35]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1001111110111011 : begin codeword[35]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1001111110111101 : begin codeword[35]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1001111110111110 : begin codeword[35]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1110000001110000 : begin codeword[34]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1110000010110000 : begin codeword[34]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1110000011010000 : begin codeword[34]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1110000011100000 : begin codeword[34]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1110000011111000 : begin codeword[34]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1110000011110100 : begin codeword[34]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1110000011110010 : begin codeword[34]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1110000011110001 : begin codeword[34]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0111000011111000 : begin codeword[33]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0111000000111000 : begin codeword[33]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0111000001011000 : begin codeword[33]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0111000001101000 : begin codeword[33]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0111000001110000 : begin codeword[33]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0111000001111100 : begin codeword[33]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0111000001111010 : begin codeword[33]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0111000001111001 : begin codeword[33]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0011100010111100 : begin codeword[32]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0011100001111100 : begin codeword[32]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0011100000011100 : begin codeword[32]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0011100000101100 : begin codeword[32]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0011100000110100 : begin codeword[32]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0011100000111000 : begin codeword[32]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0011100000111110 : begin codeword[32]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0011100000111101 : begin codeword[32]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0001101010110010 : begin codeword[31]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1101110101010000 : begin codeword[31]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0001000100100001 : begin codeword[31]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0111011110110110 : begin codeword[31]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0100010001010010 : begin codeword[31]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1111001000100000 : begin codeword[31]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1010100100011001 : begin codeword[31]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0010101110101010 : begin codeword[31]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1100101010111011 : begin codeword[30]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0000110101011001 : begin codeword[30]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1100000100101000 : begin codeword[30]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1010011110111111 : begin codeword[30]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1001010001011011 : begin codeword[30]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0010001000101001 : begin codeword[30]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0111100100010000 : begin codeword[30]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1111101110100011 : begin codeword[30]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1010001000010000 : begin codeword[29]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0110010111110010 : begin codeword[29]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1010100110000011 : begin codeword[29]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1100111100010100 : begin codeword[29]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1111110011110000 : begin codeword[29]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0100101010000010 : begin codeword[29]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0001000110111011 : begin codeword[29]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1001001100001000 : begin codeword[29]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1001011011101010 : begin codeword[28]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0101000100001000 : begin codeword[28]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1001110101111001 : begin codeword[28]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1111101111101110 : begin codeword[28]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1100100000001010 : begin codeword[28]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0111111001111000 : begin codeword[28]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0010010101000001 : begin codeword[28]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1010011111110010 : begin codeword[28]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1000110010010111 : begin codeword[27]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0100101101110101 : begin codeword[27]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1000011100000100 : begin codeword[27]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1110000110010011 : begin codeword[27]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1101001001110111 : begin codeword[27]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0110010000000101 : begin codeword[27]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0011111100111100 : begin codeword[27]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1011110110001111 : begin codeword[27]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1000000100000110 : begin codeword[26]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0100011011100100 : begin codeword[26]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1000101010010101 : begin codeword[26]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1110110000000010 : begin codeword[26]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1101111111100110 : begin codeword[26]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0110100110010100 : begin codeword[26]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0011001010101101 : begin codeword[26]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1011000000011110 : begin codeword[26]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b0010100011100001 : begin codeword[25]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b1110111100000011 : begin codeword[25]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b0010001101110010 : begin codeword[25]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b0100010111100101 : begin codeword[25]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b0111011000000001 : begin codeword[25]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b1100000001110011 : begin codeword[25]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b1001101101001010 : begin codeword[25]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b0001100111111001 : begin codeword[25]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1101001100111101 : begin codeword[24]^=1'b1; codeword[23]^=1'b1; decode_result=1'b0; end
         16'b0001010011011111 : begin codeword[24]^=1'b1; codeword[22]^=1'b1; decode_result=1'b0; end
         16'b1101100010101110 : begin codeword[24]^=1'b1; codeword[21]^=1'b1; decode_result=1'b0; end
         16'b1011111000111001 : begin codeword[24]^=1'b1; codeword[20]^=1'b1; decode_result=1'b0; end
         16'b1000110111011101 : begin codeword[24]^=1'b1; codeword[19]^=1'b1; decode_result=1'b0; end
         16'b0011101110101111 : begin codeword[24]^=1'b1; codeword[18]^=1'b1; decode_result=1'b0; end
         16'b0110000010010110 : begin codeword[24]^=1'b1; codeword[17]^=1'b1; decode_result=1'b0; end
         16'b1110001000100101 : begin codeword[24]^=1'b1; codeword[16]^=1'b1; decode_result=1'b0; end
         16'b1101010100001110 : begin codeword[31]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0001010100001110 : begin codeword[31]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0111010100001110 : begin codeword[31]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0100010100001110 : begin codeword[31]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0101110100001110 : begin codeword[31]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0101000100001110 : begin codeword[31]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0101011100001110 : begin codeword[31]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0101010000001110 : begin codeword[31]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0000010100000111 : begin codeword[30]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1100010100000111 : begin codeword[30]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1010010100000111 : begin codeword[30]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1001010100000111 : begin codeword[30]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1000110100000111 : begin codeword[30]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1000000100000111 : begin codeword[30]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1000011100000111 : begin codeword[30]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1000010000000111 : begin codeword[30]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0110110110101100 : begin codeword[29]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1010110110101100 : begin codeword[29]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1100110110101100 : begin codeword[29]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1111110110101100 : begin codeword[29]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1110010110101100 : begin codeword[29]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1110100110101100 : begin codeword[29]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1110111110101100 : begin codeword[29]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1110110010101100 : begin codeword[29]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0101100101010110 : begin codeword[28]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1001100101010110 : begin codeword[28]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1111100101010110 : begin codeword[28]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1100100101010110 : begin codeword[28]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1101000101010110 : begin codeword[28]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1101110101010110 : begin codeword[28]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1101101101010110 : begin codeword[28]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1101100001010110 : begin codeword[28]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0100001100101011 : begin codeword[27]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1000001100101011 : begin codeword[27]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1110001100101011 : begin codeword[27]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1101001100101011 : begin codeword[27]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1100101100101011 : begin codeword[27]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1100011100101011 : begin codeword[27]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1100000100101011 : begin codeword[27]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1100001000101011 : begin codeword[27]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0100111010111010 : begin codeword[26]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1000111010111010 : begin codeword[26]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1110111010111010 : begin codeword[26]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1101111010111010 : begin codeword[26]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1100011010111010 : begin codeword[26]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1100101010111010 : begin codeword[26]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1100110010111010 : begin codeword[26]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1100111110111010 : begin codeword[26]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1110011101011101 : begin codeword[25]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0010011101011101 : begin codeword[25]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0100011101011101 : begin codeword[25]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0111011101011101 : begin codeword[25]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0110111101011101 : begin codeword[25]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0110001101011101 : begin codeword[25]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0110010101011101 : begin codeword[25]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0110011001011101 : begin codeword[25]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0001110010000001 : begin codeword[24]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1101110010000001 : begin codeword[24]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1011110010000001 : begin codeword[24]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1000110010000001 : begin codeword[24]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1001010010000001 : begin codeword[24]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1001100010000001 : begin codeword[24]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1001111010000001 : begin codeword[24]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1001110110000001 : begin codeword[24]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0101010110001110 : begin codeword[31]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0101010101001110 : begin codeword[31]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0101010100101110 : begin codeword[31]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0101010100011110 : begin codeword[31]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0101010100000110 : begin codeword[31]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0101010100001010 : begin codeword[31]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0101010100001100 : begin codeword[31]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0101010100001111 : begin codeword[31]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1000010110000111 : begin codeword[30]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1000010101000111 : begin codeword[30]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1000010100100111 : begin codeword[30]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1000010100010111 : begin codeword[30]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1000010100001111 : begin codeword[30]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1000010100000011 : begin codeword[30]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1000010100000101 : begin codeword[30]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1000010100000110 : begin codeword[30]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1110110100101100 : begin codeword[29]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1110110111101100 : begin codeword[29]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1110110110001100 : begin codeword[29]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1110110110111100 : begin codeword[29]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1110110110100100 : begin codeword[29]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1110110110101000 : begin codeword[29]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1110110110101110 : begin codeword[29]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1110110110101101 : begin codeword[29]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1101100111010110 : begin codeword[28]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1101100100010110 : begin codeword[28]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1101100101110110 : begin codeword[28]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1101100101000110 : begin codeword[28]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1101100101011110 : begin codeword[28]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1101100101010010 : begin codeword[28]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1101100101010100 : begin codeword[28]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1101100101010111 : begin codeword[28]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1100001110101011 : begin codeword[27]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1100001101101011 : begin codeword[27]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1100001100001011 : begin codeword[27]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1100001100111011 : begin codeword[27]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1100001100100011 : begin codeword[27]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1100001100101111 : begin codeword[27]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1100001100101001 : begin codeword[27]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1100001100101010 : begin codeword[27]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1100111000111010 : begin codeword[26]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1100111011111010 : begin codeword[26]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1100111010011010 : begin codeword[26]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1100111010101010 : begin codeword[26]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1100111010110010 : begin codeword[26]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1100111010111110 : begin codeword[26]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1100111010111000 : begin codeword[26]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1100111010111011 : begin codeword[26]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0110011111011101 : begin codeword[25]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0110011100011101 : begin codeword[25]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0110011101111101 : begin codeword[25]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0110011101001101 : begin codeword[25]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0110011101010101 : begin codeword[25]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0110011101011001 : begin codeword[25]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0110011101011111 : begin codeword[25]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0110011101011100 : begin codeword[25]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1001110000000001 : begin codeword[24]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1001110011000001 : begin codeword[24]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1001110010100001 : begin codeword[24]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1001110010010001 : begin codeword[24]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1001110010001001 : begin codeword[24]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1001110010000101 : begin codeword[24]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1001110010000011 : begin codeword[24]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1001110010000000 : begin codeword[24]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1100111110111100 : begin codeword[23]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0000111110111100 : begin codeword[23]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0110111110111100 : begin codeword[23]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0101111110111100 : begin codeword[23]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0100011110111100 : begin codeword[23]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0100101110111100 : begin codeword[23]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0100110110111100 : begin codeword[23]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0100111010111100 : begin codeword[23]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0000100001011110 : begin codeword[22]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1100100001011110 : begin codeword[22]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1010100001011110 : begin codeword[22]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1001100001011110 : begin codeword[22]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1000000001011110 : begin codeword[22]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1000110001011110 : begin codeword[22]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1000101001011110 : begin codeword[22]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1000100101011110 : begin codeword[22]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1100010000101111 : begin codeword[21]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0000010000101111 : begin codeword[21]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0110010000101111 : begin codeword[21]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0101010000101111 : begin codeword[21]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0100110000101111 : begin codeword[21]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0100000000101111 : begin codeword[21]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0100011000101111 : begin codeword[21]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0100010100101111 : begin codeword[21]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1010001010111000 : begin codeword[20]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0110001010111000 : begin codeword[20]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0000001010111000 : begin codeword[20]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0011001010111000 : begin codeword[20]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0010101010111000 : begin codeword[20]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0010011010111000 : begin codeword[20]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0010000010111000 : begin codeword[20]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0010001110111000 : begin codeword[20]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1001000101011100 : begin codeword[19]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0101000101011100 : begin codeword[19]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0011000101011100 : begin codeword[19]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0000000101011100 : begin codeword[19]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0001100101011100 : begin codeword[19]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0001010101011100 : begin codeword[19]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0001001101011100 : begin codeword[19]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0001000001011100 : begin codeword[19]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0010011100101110 : begin codeword[18]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1110011100101110 : begin codeword[18]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1000011100101110 : begin codeword[18]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1011011100101110 : begin codeword[18]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1010111100101110 : begin codeword[18]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1010001100101110 : begin codeword[18]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1010010100101110 : begin codeword[18]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1010011000101110 : begin codeword[18]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0111110000010111 : begin codeword[17]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b1011110000010111 : begin codeword[17]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b1101110000010111 : begin codeword[17]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b1110110000010111 : begin codeword[17]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b1111010000010111 : begin codeword[17]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b1111100000010111 : begin codeword[17]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b1111111000010111 : begin codeword[17]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b1111110100010111 : begin codeword[17]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b1111111010100100 : begin codeword[16]^=1'b1; codeword[15]^=1'b1; decode_result=1'b0; end
         16'b0011111010100100 : begin codeword[16]^=1'b1; codeword[14]^=1'b1; decode_result=1'b0; end
         16'b0101111010100100 : begin codeword[16]^=1'b1; codeword[13]^=1'b1; decode_result=1'b0; end
         16'b0110111010100100 : begin codeword[16]^=1'b1; codeword[12]^=1'b1; decode_result=1'b0; end
         16'b0111011010100100 : begin codeword[16]^=1'b1; codeword[11]^=1'b1; decode_result=1'b0; end
         16'b0111101010100100 : begin codeword[16]^=1'b1; codeword[10]^=1'b1; decode_result=1'b0; end
         16'b0111110010100100 : begin codeword[16]^=1'b1; codeword[9 ]^=1'b1; decode_result=1'b0; end
         16'b0111111110100100 : begin codeword[16]^=1'b1; codeword[8 ]^=1'b1; decode_result=1'b0; end
         16'b0100111100111100 : begin codeword[23]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0100111111111100 : begin codeword[23]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0100111110011100 : begin codeword[23]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0100111110101100 : begin codeword[23]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0100111110110100 : begin codeword[23]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0100111110111000 : begin codeword[23]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0100111110111110 : begin codeword[23]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0100111110111101 : begin codeword[23]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1000100011011110 : begin codeword[22]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1000100000011110 : begin codeword[22]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1000100001111110 : begin codeword[22]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1000100001001110 : begin codeword[22]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1000100001010110 : begin codeword[22]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1000100001011010 : begin codeword[22]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1000100001011100 : begin codeword[22]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1000100001011111 : begin codeword[22]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0100010010101111 : begin codeword[21]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0100010001101111 : begin codeword[21]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0100010000001111 : begin codeword[21]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0100010000111111 : begin codeword[21]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0100010000100111 : begin codeword[21]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0100010000101011 : begin codeword[21]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0100010000101101 : begin codeword[21]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0100010000101110 : begin codeword[21]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0010001000111000 : begin codeword[20]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0010001011111000 : begin codeword[20]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0010001010011000 : begin codeword[20]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0010001010101000 : begin codeword[20]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0010001010110000 : begin codeword[20]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0010001010111100 : begin codeword[20]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0010001010111010 : begin codeword[20]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0010001010111001 : begin codeword[20]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0001000111011100 : begin codeword[19]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0001000100011100 : begin codeword[19]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0001000101111100 : begin codeword[19]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0001000101001100 : begin codeword[19]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0001000101010100 : begin codeword[19]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0001000101011000 : begin codeword[19]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0001000101011110 : begin codeword[19]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0001000101011101 : begin codeword[19]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1010011110101110 : begin codeword[18]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1010011101101110 : begin codeword[18]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1010011100001110 : begin codeword[18]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1010011100111110 : begin codeword[18]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1010011100100110 : begin codeword[18]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1010011100101010 : begin codeword[18]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1010011100101100 : begin codeword[18]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1010011100101111 : begin codeword[18]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1111110010010111 : begin codeword[17]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1111110001010111 : begin codeword[17]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1111110000110111 : begin codeword[17]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1111110000000111 : begin codeword[17]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1111110000011111 : begin codeword[17]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1111110000010011 : begin codeword[17]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1111110000010101 : begin codeword[17]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1111110000010110 : begin codeword[17]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0111111000100100 : begin codeword[16]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0111111011100100 : begin codeword[16]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0111111010000100 : begin codeword[16]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0111111010110100 : begin codeword[16]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0111111010101100 : begin codeword[16]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0111111010100000 : begin codeword[16]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0111111010100110 : begin codeword[16]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0111111010100101 : begin codeword[16]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b1000000010000000 : begin codeword[15]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b1000000001000000 : begin codeword[15]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b1000000000100000 : begin codeword[15]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b1000000000010000 : begin codeword[15]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b1000000000001000 : begin codeword[15]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b1000000000000100 : begin codeword[15]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b1000000000000010 : begin codeword[15]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b1000000000000001 : begin codeword[15]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0100000010000000 : begin codeword[14]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0100000001000000 : begin codeword[14]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0100000000100000 : begin codeword[14]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0100000000010000 : begin codeword[14]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0100000000001000 : begin codeword[14]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0100000000000100 : begin codeword[14]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0100000000000010 : begin codeword[14]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0100000000000001 : begin codeword[14]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0010000010000000 : begin codeword[13]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0010000001000000 : begin codeword[13]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0010000000100000 : begin codeword[13]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0010000000010000 : begin codeword[13]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0010000000001000 : begin codeword[13]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0010000000000100 : begin codeword[13]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0010000000000010 : begin codeword[13]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0010000000000001 : begin codeword[13]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0001000010000000 : begin codeword[12]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0001000001000000 : begin codeword[12]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0001000000100000 : begin codeword[12]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0001000000010000 : begin codeword[12]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0001000000001000 : begin codeword[12]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0001000000000100 : begin codeword[12]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0001000000000010 : begin codeword[12]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0001000000000001 : begin codeword[12]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0000100010000000 : begin codeword[11]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0000100001000000 : begin codeword[11]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0000100000100000 : begin codeword[11]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0000100000010000 : begin codeword[11]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0000100000001000 : begin codeword[11]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0000100000000100 : begin codeword[11]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0000100000000010 : begin codeword[11]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0000100000000001 : begin codeword[11]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0000010010000000 : begin codeword[10]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0000010001000000 : begin codeword[10]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0000010000100000 : begin codeword[10]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0000010000010000 : begin codeword[10]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0000010000001000 : begin codeword[10]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0000010000000100 : begin codeword[10]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0000010000000010 : begin codeword[10]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0000010000000001 : begin codeword[10]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0000001010000000 : begin codeword[9 ]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0000001001000000 : begin codeword[9 ]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0000001000100000 : begin codeword[9 ]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0000001000010000 : begin codeword[9 ]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0000001000001000 : begin codeword[9 ]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0000001000000100 : begin codeword[9 ]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0000001000000010 : begin codeword[9 ]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0000001000000001 : begin codeword[9 ]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         16'b0000000110000000 : begin codeword[8 ]^=1'b1; codeword[7 ]^=1'b1; decode_result=1'b0; end
         16'b0000000101000000 : begin codeword[8 ]^=1'b1; codeword[6 ]^=1'b1; decode_result=1'b0; end
         16'b0000000100100000 : begin codeword[8 ]^=1'b1; codeword[5 ]^=1'b1; decode_result=1'b0; end
         16'b0000000100010000 : begin codeword[8 ]^=1'b1; codeword[4 ]^=1'b1; decode_result=1'b0; end
         16'b0000000100001000 : begin codeword[8 ]^=1'b1; codeword[3 ]^=1'b1; decode_result=1'b0; end
         16'b0000000100000100 : begin codeword[8 ]^=1'b1; codeword[2 ]^=1'b1; decode_result=1'b0; end
         16'b0000000100000010 : begin codeword[8 ]^=1'b1; codeword[1 ]^=1'b1; decode_result=1'b0; end
         16'b0000000100000001 : begin codeword[8 ]^=1'b1; codeword[0 ]^=1'b1; decode_result=1'b0; end
         // DUE
         default: begin decode_result=1'b1; end
     endcase
   end
  
  // NE : syndrome_in is all zero
  // CE: double bit errors not in a single symbol
  // otherwise: DUE
  assign decode_result_out = decode_result;
  assign data_out = codeword[79:16];

endmodule
