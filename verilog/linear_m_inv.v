module linear_m_inv (
  input [63:0] data_in,
  output wire [63:0] data_out
);

wire [63:0] mprime_in;

assign mprime_in[63:60] = data_in[63:60];
assign mprime_in[59:56] = data_in[11:8];
assign mprime_in[55:52] = data_in[23:20];
assign mprime_in[51:48] = data_in[35:32];
assign mprime_in[47:44] = data_in[47:44];
assign mprime_in[43:40] = data_in[59:56];
assign mprime_in[39:36] = data_in[7:4];
assign mprime_in[35:32] = data_in[19:16];
assign mprime_in[31:28] = data_in[31:28];
assign mprime_in[27:24] = data_in[43:40];
assign mprime_in[23:20] = data_in[55:52];
assign mprime_in[19:16] = data_in[3:0];
assign mprime_in[15:12] = data_in[15:12];
assign mprime_in[11:8] = data_in[27:24];
assign mprime_in[7:4] = data_in[39:36];
assign mprime_in[3:0] = data_in[51:48];

linear_mprime u_linear_mprime (
  .data_in(mprime_in),
  .data_out(data_out)
);

endmodule
