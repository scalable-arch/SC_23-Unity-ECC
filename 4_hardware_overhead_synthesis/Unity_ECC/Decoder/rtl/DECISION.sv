module DECISION(input decode_result_1_in,
               input decode_result_2_in,
               input [63:0] data_1_in,
               input [63:0] data_2_in,
               output decode_result_out,
               output [63:0] data_out
                      );
  // Syndome_in : 16bit syndrome input
  // Error_location_out : error (symbol) location output (0~9, DUE/NE: 1111)
  // Error_value_out : error value output (0000_0000 ~ 1111_1111)
  // decode_result_out : NE(00), CE(01), DUE(10)


  reg [1:0] decode_result;
  //wire [7:0] Error_location_gdiv;
  reg [7:0] Error_location_gfexp;
  reg [3:0] Error_location_reg;
  reg [7:0] Error_value;
  wire [7:0] Syndrome0,Syndrome1;

   // decode result table
   // 0 0 => both NE
   // 0 1 => CE DUE => CE (SSC)
   // 1 0 => DUE CE => CE (DEC)
   // 1 1 => DUE DUE => DUE

   //always_comb begin
      //$display("decode result 1 in : %b",decode_result_1_in);
      //$display("decode result 2 in : %b",decode_result_2_in);
      //$display("data 1 in          : %b",data_1_in);
      //$display("data 2 in          : %b",data_1_in);
   //end

   assign decode_result_out = (decode_result_1_in < decode_result_2_in) ? decode_result_1_in : decode_result_2_in; 
   assign data_out = (decode_result_1_in < decode_result_2_in) ? data_1_in : data_2_in;



endmodule
