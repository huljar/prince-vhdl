//-- This entity applies the matrix from linear_mprime.
//-- In addition, a nibble-wise
//-- transposition is performed in the end.

module linear_m(
  input [63:0] data_in,
  output wire [63:0] data_out
);

wire [63:0] mprime_out;

linear_mprime i_linear_mprime (
  .data_in(data_in),
  .data_out(mprime_out)
);

  assign data_out[63:60] = mprime_out[63:60];
  assign data_out[59:56] = mprime_out[43:40];
  assign data_out[55:52] = mprime_out[23:20];
  assign data_out[51:48] = mprime_out[3:0];
  assign data_out[47:44] = mprime_out[47:44];
  assign data_out[43:40] = mprime_out[27:24];
  assign data_out[39:36] = mprime_out[7:4];
  assign data_out[35:32] = mprime_out[51:48];
  assign data_out[31:28] = mprime_out[31:28];
  assign data_out[27:24] = mprime_out[11:8];
  assign data_out[23:20] = mprime_out[55:52];
  assign data_out[19:16] = mprime_out[35:32];
  assign data_out[15:12] = mprime_out[15:12];
  assign data_out[11:8] = mprime_out[59:56];
  assign data_out[7:4] = mprime_out[39:36];
  assign data_out[3:0] = mprime_out[19:16];

endmodule
