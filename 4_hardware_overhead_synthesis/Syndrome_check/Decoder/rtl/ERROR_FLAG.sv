module ERROR_FLAG(a, b);
  input [15:0] a;
  output b;

  /*
    a : syndrome0
    b : 0 (syndrome is all zero), otherwise '1' => error occurence flag
  */

  assign b = (a==16'b0) ? 1'b0 : 1'b1;
endmodule