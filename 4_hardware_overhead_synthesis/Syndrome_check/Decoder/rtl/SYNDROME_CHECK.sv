module SYNDROME_CHECK(input [79:0] codeword_in,
                      output [15:0] syndrome_out,
                      output error_flag_out
                      );
  // codeword_out: 80-bit RS codeword output
  // Error location : 

  // over GF(2^8) primitive polynomial, systematic-encoding
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
  wire [15:0] syndrome;
  wire error_flag;




  // Syndrome generation
  SYNDROME_GENERATOR syndrome_generator(codeword_in,syndrome);
  ERROR_FLAG error_flag00(syndrome, error_flag);
  //SSE_CORRECTOR sse_corrector (codeword_in, syndrome, decode_result_1, data_1);
  //DE_CORRECTOR de_corrector (codeword_in, syndrome, decode_result_2, data_2);
  //DECISION decision(decode_result_1, decode_result_2, data_1, data_2, decode_result, data);


  assign syndrome_out = syndrome; // error location : 0 > 79~72, error location : 1 > 71~64
  assign error_flag_out = error_flag; // (NE or CE)/DUE
  //assign Error_location_out = error_location; // 0000~1001
  //assign error_value_out = error_value; // for debug
  //assign syndrome0_out = syndrome[15:8]; // for debug
  //assign syndrome1_out = syndrome[7:0]; // for debug

endmodule