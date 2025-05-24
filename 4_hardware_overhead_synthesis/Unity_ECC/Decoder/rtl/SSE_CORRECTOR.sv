module SSE_CORRECTOR(input [79:0] codeword_in,
                     input [15:0] syndrome_in,
                      output decode_result_out,
                      output [63:0] data_out
                      );
  // Syndome_in : 16bit syndrome input
  // error_location_out : error (symbol) location output (0~9, DUE/NE: 1111)
  // error_value_out : error value output (0000_0000 ~ 1111_1111)
  // decode_result_out : NE(00), CE(01), DUE(10)

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

  reg [1:0] decode_result;
  reg [79:0] codeword;
  //wire [7:0] error_location_gdiv;
  wire [7:0] error_location_gfdiv;
  reg [7:0] error_location_gfexp;
  reg [7:0] error_value;
  wire [7:0] syndrome0,syndrome1;

  //GFDIV gdiv(syndrome_in[7:0], syndrome_in[15:8], error_location_gdiv);
  //GFEXP gfexp(error_location_gdiv, error_location_gfexp);

    GFEXP gfexp_00(syndrome_in[15:8],syndrome0); // S0=a^n => n
    GFEXP gfexp_01(syndrome_in[7:0],syndrome1); // S1=a^m => m
    GFDIV error_value00(syndrome_in[7:0],syndrome_in[15:8], error_location_gfdiv); // a^(50+?, 78+?, ...)/a^(25+?, 39+?, ...) => a^(25, 39, ...)  
    GFDIV error_value01(syndrome_in[15:8], error_location_gfdiv, error_value); // a^(25+?)/a^(a^25) => a^? (error value)
    ERROR_LOCATION error_location(syndrome1, syndrome0, error_location_gfexp); // m-n (25, 39, 63, ...)
    
   always_comb begin
     codeword=codeword_in;
     //$display("syndrome0 : %d",syndrome0);
     //$display("syndrome1 : %d",syndrome1);
     //$display("error location grexp : %d",error_location_gfexp);
     //$display("error vlaue : %b",error_value);
     //$display("error vlaue : %d",error_value);
     if(syndrome_in[7:0]!=8'b0000_0000 && syndrome_in[15:8]!=8'b0000_0000) begin // 0~7th chip errors or DUE
         case(error_location_gfexp)
            8'd25: begin codeword[79:72]^=error_value; decode_result=1'b0; end // 0th chip errors
            8'd39: begin codeword[71:64]^=error_value; decode_result=1'b0; end // 1th chip errors
            8'd63: begin codeword[63:56]^=error_value; decode_result=1'b0; end // 2th chip errors
            8'd108: begin codeword[55:48]^=error_value; decode_result=1'b0; end // 3th chip errors
            8'd141: begin codeword[47:40]^=error_value; decode_result=1'b0; end // 4th chip errors
            8'd184: begin codeword[39:32]^=error_value; decode_result=1'b0; end // 5th chip errors
            8'd215: begin codeword[31:24]^=error_value; decode_result=1'b0; end // 6th chip errors
            8'd230: begin codeword[23:16]^=error_value; decode_result=1'b0; end // 7th chip errors
            default: begin decode_result=1'b1; end // DUE
         endcase
     end
     if(syndrome_in[7:0]==8'b0000_0000 && syndrome_in[15:8]!=8'b0000_0000)begin // 8th chip errors
        codeword[15:8]^=syndrome_in[15:8]; // error correction
        decode_result=1'b0; //CE
     end
     if(syndrome_in[7:0]!=8'b0000_0000 && syndrome_in[15:8]==8'b0000_0000)begin // 9th chip errors
        codeword[7:0]^=syndrome_in[7:0]; // error correction
        decode_result=1'b0; //CE
     end
     if(syndrome_in[15:0]==16'b0000_0000_0000_0000) begin // No error
        decode_result=1'b0; // NE
     end
   end
  
  // NE: syndrome_in is all zero
  // CE: Error location is 0~9
  // otherwise: DUE
  assign decode_result_out = decode_result;
  assign data_out = codeword[79:16];

endmodule
