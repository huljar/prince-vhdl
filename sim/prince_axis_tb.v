`ifdef TIMESCALE
        `timescale 1ns/10ps
`endif

module prince_axis_tb();

`include "prince_tb_features.v"

   // --Inputs
   reg ACLK = 0;
   reg ARESETN = 0;
   reg [DATA_SIZE-1:0] S_AXIS_TDATA = {DATA_SIZE{1'b0}};
   reg S_AXIS_TLAST = 0;
   reg S_AXIS_TVALID = 0;
   reg M_AXIS_TREADY = 0;

   // --Outputs
   wire S_AXIS_TREADY;
   wire M_AXIS_TVALID;
   wire [DATA_SIZE-1:0] M_AXIS_TDATA;
   wire M_AXIS_TLAST ;

   //-- Clock period definitions
   parameter CLK_PERIOD = 10;
   
   //-- Other signals
   reg [63:0] ciphertext;

//-- Instantiate the Unit Under Test (UUT)

	axi_stream_wrapper uut (
        //-- inputs
        .ACLK(ACLK),
        .ARESETN(ARESETN),
        .S_AXIS_TDATA(S_AXIS_TDATA),
        .S_AXIS_TLAST(S_AXIS_TLAST),
        .M_AXIS_TREADY(M_AXIS_TREADY),
        .S_AXIS_TVALID(S_AXIS_TVALID),
        //-- outputs
        .M_AXIS_TVALID(M_AXIS_TVALID),
        .M_AXIS_TLAST(M_AXIS_TLAST),
        .M_AXIS_TDATA(M_AXIS_TDATA),
        .S_AXIS_TREADY(S_AXIS_TREADY)
        );


initial begin
  $dumpfile ("prince_axis_tb.vcd");
  $dumpvars;
end

always @(*)
  ACLK <= #(CLK_PERIOD/2) ~ACLK;

initial begin
      $display("-I- prince simulation thru AXI stream prototol");
      ARESETN = 0;
	#(10 * CLK_PERIOD);

      // -- write plaintext
      ARESETN = 1;
      S_AXIS_TVALID = 1;
      S_AXIS_TDATA <= 32'h01234567;
      #(CLK_PERIOD); 
      #(CLK_PERIOD);
      S_AXIS_TDATA <= 32'h89ABCDEF;
      #(CLK_PERIOD);
      
      //-- write key (k0 first then k1)
      S_AXIS_TDATA = {DATA_SIZE{1'b0}};
      #(CLK_PERIOD*2);
      S_AXIS_TDATA = 32'hFEDCBA98;
      #(CLK_PERIOD);
      S_AXIS_TDATA = 32'h76543210;
      #(CLK_PERIOD);
      S_AXIS_TDATA = {DATA_SIZE{1'b0}};
      S_AXIS_TVALID = 0;
      #(CLK_PERIOD);
      
      //-- read ciphertext
      M_AXIS_TREADY = 1;
      #(CLK_PERIOD);
      ciphertext[63:32] = M_AXIS_TDATA;
      #(CLK_PERIOD);
      ciphertext[31:0] = M_AXIS_TDATA;
      #(CLK_PERIOD);
      M_AXIS_TREADY = 0;
      
      //-- print ciphertext
      $display("cipĥertext is %h and expected value is ae25ad3ca8fa9ccf", ciphertext);

      $finish;
end

endmodule
