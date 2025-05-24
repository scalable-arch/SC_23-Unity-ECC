module ERROR_LOCATION(input [7:0] syndrome0,
                      input [7:0] syndrome1,
                      output [7:0] error_location_out);
  // Syndome0 : 8bit syndrome 0 input
  // syndrome1 : 8bit syndrome 1 input
  // error location out : syndrome1/syndrome0's absolute value=> 0~7 (CE cases)

   assign error_location_out = (syndrome1 > syndrome0) ? syndrome1-syndrome0 : syndrome0-syndrome1;

endmodule


