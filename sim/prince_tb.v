`ifdef TIMESCALE
	`timescale 1ns/10ps
`endif

module prince_tb();

parameter CLK_PERIOD = 100;
parameter TEXT_SIZE = 64;
parameter KEY_SIZE = 128;
parameter SBOX_NUMBER = 16;

reg [TEXT_SIZE-1:0] plaintext = {TEXT_SIZE{1'b0}}; 
wire [TEXT_SIZE-1:0] ciphertext; 
reg [KEY_SIZE-1:0] key = {KEY_SIZE{1'b0}}; 


prince_top #(
	.TEXT_SIZE(TEXT_SIZE),
	.KEY_SIZE(KEY_SIZE),
	.SBOX_NUMBER(SBOX_NUMBER)
) uut (
	.plaintext(plaintext),
	.key(key),
	.ciphertext(ciphertext)
);

initial begin

   //-- Stimulus process
  
      //-- hold reset state for 100 ns.
      #CLK_PERIOD;

      //-- Test vectors from the PRINCE paper
      //-- First test vector
      plaintext = {TEXT_SIZE{1'b0}};
      key = {KEY_SIZE{1'b0}};
      #1;
      $display("cipĥertext is %h and expected value is 818665aa0d02dfda", ciphertext);
      #9;

      //-- Second test vector
      plaintext = {TEXT_SIZE{1'b1}};
      key = {KEY_SIZE{1'b0}};
      #1;
      $display("cipĥertext is %h and expected value is 604ae6ca03c20ada", ciphertext);
      #9;

      //-- Third test vector
      plaintext = {TEXT_SIZE{1'b0}};
      key = {{KEY_SIZE/2{1'b1}}, {KEY_SIZE/2{1'b0}}};
      #1;
      $display("cipĥertext is %h and expected value is 9fb51935fc3df524", ciphertext);
      #9;

      //-- Fourth test vector
      plaintext = {TEXT_SIZE{1'b0}};
      key = {{KEY_SIZE/2{1'b0}}, {KEY_SIZE/2{1'b1}}};
      #1;
      $display("cipĥertext is %h and expected value is 78a54cbe737bb7ef", ciphertext);
      #9;

      //-- Fifth test vector
      plaintext = {{(TEXT_SIZE-64){1'b0}}, 64'h0123456789abcdef};
      key = {{(KEY_SIZE-64){1'b0}}, 64'hfedcba9876543210};
      #1;
      $display("cipĥertext is %h and expected value is ae25ad3ca8fa9ccf", ciphertext);

end

endmodule
