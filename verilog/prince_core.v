module prince_core
	#( parameter TEXT_SIZE=64,
        parameter KEY_SIZE=128,
	parameter SBOX_NUMBER=16) (
	input [TEXT_SIZE-1:0] data_in,
	input [KEY_SIZE/2-1:0] key,
	output wire [TEXT_SIZE-1:0] data_out
	);

wire [TEXT_SIZE-1:0] rcs [11:0];
wire [TEXT_SIZE-1:0] ims [11:0];

wire [TEXT_SIZE-1:0] sb_out[5:1];
wire [TEXT_SIZE-1:0] m_out[5:1];

wire [TEXT_SIZE-1:0] sb_in[10:6];
wire [TEXT_SIZE-1:0] m_in[10:6];

wire [TEXT_SIZE-1:0] middle1, middle2;

// -- Round constants for each round
assign rcs[0] = 64'h0000000000000000;
assign rcs[1] = 64'h13198A2E03707344;
assign rcs[2] = 64'hA4093822299F31D0;
assign rcs[3] = 64'h082EFA98EC4E6C89;
assign rcs[4] = 64'h452821E638D01377;
assign rcs[5] = 64'hBE5466CF34E90C6C;
assign rcs[6] = 64'h7EF84F78FD955CB1;
assign rcs[7] = 64'h85840851F1AC43AA;
assign rcs[8] = 64'hC882D32F25323C54;
assign rcs[9] = 64'h64A51195E0E3610D;
assign rcs[10] = 64'hD3B5A399CA0C2399;
assign rcs[11] = 64'hC0AC29B7C97C50DD;

genvar i,j;

//-- instantiates sbox, sbox_inv, linear_m, 

//-- Round 0
assign ims[0] = data_in ^  key ^ rcs[0]; 

//-- Round 1 to 5
generate
  for (j = 0 ; j <= (SBOX_NUMBER-1) ; j = j + 1) begin
    sbox i_sbox (
      .data_in(ims[0][63 - 4*j:63 - 4*j - 3]),
      .data_out(sb_out[1][63 - 4*j:63- 4*j - 3])
     );
   end
endgenerate

generate
  for (j = 0 ; j <= (SBOX_NUMBER-1) ; j = j + 1) begin
    sbox i_sbox (
      .data_in(ims[1][63 - 4*j:63 - 4*j - 3]),
      .data_out(sb_out[2][63 - 4*j:63- 4*j - 3])
     );
   end
endgenerate

generate
  for (j = 0 ; j <= (SBOX_NUMBER-1) ; j = j + 1) begin
    sbox i_sbox (
      .data_in(ims[2][63 - 4*j:63 - 4*j - 3]),
      .data_out(sb_out[3][63 - 4*j:63- 4*j - 3])
     );
   end
endgenerate

generate
  for (j = 0 ; j <= (SBOX_NUMBER-1) ; j = j + 1) begin
    sbox i_sbox (
      .data_in(ims[3][63 - 4*j:63 - 4*j - 3]),
      .data_out(sb_out[4][63 - 4*j:63- 4*j - 3])
     );
   end
endgenerate

generate
  for (j = 0 ; j <= (SBOX_NUMBER-1) ; j = j + 1) begin
    sbox i_sbox (
      .data_in(ims[4][63 - 4*j:63 - 4*j - 3]),
      .data_out(sb_out[5][63 - 4*j:63- 4*j - 3])
     );
   end
endgenerate

generate
  for (i = 1 ; i <= 5 ; i = i + 1) begin

  linear_m i_linear_m (
	.data_in(sb_out[i]),
	.data_out(m_out[i])
	);

  assign ims[i] = m_out[i] ^  key ^ rcs[i]; 

  end
endgenerate


//-- Middle Layer

generate
  for (j = 0 ; j <= (SBOX_NUMBER-1) ; j = j + 1) begin
    sbox i_sbox (
      .data_in(ims[5][63 - 4*j:63 - 4*j - 3]),
      .data_out(middle1[63 - 4*j:63- 4*j - 3])
     );
   end
endgenerate

linear_mprime i_linear_mprime (
  .data_in(middle1),
  .data_out(middle2)
);

generate
  for (j = 0 ; j <= (SBOX_NUMBER-1) ; j = j + 1) begin
    sbox_inv i_sbox_inv (
      .data_in(middle2[63 - 4*j:63 - 4*j - 3]),
      .data_out(ims[6][63 - 4*j:63- 4*j - 3])
     );
   end
endgenerate

//-- Round 6 to 10

generate
  for (i = 6 ; i <= 10 ; i = i + 1) begin

  assign m_in[i] = ims[i] ^  key ^ rcs[i];

  linear_m_inv i_linear_m_inv (
        .data_in(m_in[i]),
        .data_out(sb_in[i])
        );

  end
endgenerate

generate
  for (j = 0 ; j <= (SBOX_NUMBER-1) ; j = j + 1) begin
    sbox_inv i_sbox_inv (
      .data_in(sb_in[6][63 - 4*j:63 - 4*j - 3]),
      .data_out(ims[7][63 - 4*j:63- 4*j - 3])
     );
   end
endgenerate

generate
  for (j = 0 ; j <= (SBOX_NUMBER-1) ; j = j + 1) begin
    sbox_inv i_sbox_inv (
      .data_in(sb_in[7][63 - 4*j:63 - 4*j - 3]),
      .data_out(ims[8][63 - 4*j:63- 4*j - 3])
     );
   end
endgenerate

generate
  for (j = 0 ; j <= (SBOX_NUMBER-1) ; j = j + 1) begin
    sbox_inv i_sbox_inv (
      .data_in(sb_in[8][63 - 4*j:63 - 4*j - 3]),
      .data_out(ims[9][63 - 4*j:63- 4*j - 3])
     );
   end
endgenerate

generate
  for (j = 0 ; j <= (SBOX_NUMBER-1) ; j = j + 1) begin
    sbox_inv i_sbox_inv (
      .data_in(sb_in[9][63 - 4*j:63 - 4*j - 3]),
      .data_out(ims[10][63 - 4*j:63- 4*j - 3])
     );
   end
endgenerate

generate
  for (j = 0 ; j <= (SBOX_NUMBER-1) ; j = j + 1) begin
    sbox_inv i_sbox_inv (
      .data_in(sb_in[10][63 - 4*j:63 - 4*j - 3]),
      .data_out(ims[11][63 - 4*j:63- 4*j - 3])
     );
   end
endgenerate

//-- Round 11
assign data_out = ims[11] ^ key ^ rcs[11]; 

endmodule
