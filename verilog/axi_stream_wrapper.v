module axi_stream_wrapper (
  input wire ACLK, //-- positive edge clock
  input wire ARESETN, //-- active-low asynchronous reset
  input wire [31:0] S_AXIS_TDATA,
  input wire S_AXIS_TLAST,
  input wire M_AXIS_TREADY,
  input wire S_AXIS_TVALID,
  output wire M_AXIS_TVALID,
  output reg [31:0] M_AXIS_TDATA,
  output wire M_AXIS_TLAST,
  output wire S_AXIS_TREADY
);

parameter FSM_SIZE = 2;
parameter COUNTER_SIZE = 2;
//-- states
parameter IDLE = 2'b00;
parameter READ_PLAINTEXT = 2'b01;
parameter READ_KEY = 2'b11;
parameter WRITE_CIPHERTEXT = 2'b10;

parameter PLAINTEXT_READS = 3'b010;
parameter KEY_READS = 3'b100;
parameter CIPHERTEXT_WRITES = 3'b010;


reg [FSM_SIZE-1:0] state; //-- state_machine
reg [COUNTER_SIZE-1:0] counter; 

reg [31:0] ip_key_buf [3:0];
reg [31:0] ip_plaintext_buf [1:0];
wire [31:0] ip_ciphertext_buf [1:0];

wire [127:0] ip_key;
wire [63:0] ip_plaintext;
wire [63:0] ip_ciphertext;

wire mode = 0; //--enc mode by default. to be placed in a cfg reg

prince_top #(
        .TEXT_SIZE(64),
        .KEY_SIZE(128),
        .SBOX_NUMBER(16)
) i_prince_top (
        .plaintext(ip_plaintext),
        .key(ip_key),
        .mode(mode),
        .ciphertext(ip_ciphertext)
        );

assign ip_plaintext = {ip_plaintext_buf[0], ip_plaintext_buf[1]};
assign ip_key = {ip_key_buf[0], ip_key_buf[1] , ip_key_buf[2] , ip_key_buf[3]};
assign ip_ciphertext_buf[0] = ip_ciphertext[63:32];
assign ip_ciphertext_buf[1] = ip_ciphertext[31:0];

assign S_AXIS_TREADY = (state == READ_PLAINTEXT || state == READ_KEY);
assign M_AXIS_TVALID = (state == WRITE_CIPHERTEXT);
assign M_AXIS_TLAST = (state == WRITE_CIPHERTEXT) && (counter == (CIPHERTEXT_WRITES-1));

  always @(negedge ARESETN or posedge ACLK)
    if(~ARESETN) begin
      state <= IDLE;
      counter <= 0;
    end
    else begin
      case(state)
      IDLE: begin
        M_AXIS_TDATA <= {32{1'b0}};
        if(S_AXIS_TVALID == 1) begin
          state <= READ_PLAINTEXT;
          counter <= 0;
        end
      end
      READ_PLAINTEXT: begin
        if(S_AXIS_TVALID == 1) begin
          ip_plaintext_buf[counter] <= S_AXIS_TDATA;
          if(counter == (PLAINTEXT_READS - 1)) begin
            state <= READ_KEY;
            counter <= 0;
          end
          else 
            counter <= counter + 1;
        end
      end
      READ_KEY: begin
        if(S_AXIS_TVALID == 1) begin
          ip_key_buf[counter] <= S_AXIS_TDATA;
          if(counter == (KEY_READS - 1)) begin
            state <= WRITE_CIPHERTEXT;
            counter <= 0;
          end
          else begin
            counter <= counter + 1;
          end
        end
      end
      WRITE_CIPHERTEXT: begin
        M_AXIS_TDATA <= ip_ciphertext_buf[counter];
        if(M_AXIS_TREADY == 1) begin
          if(counter == (CIPHERTEXT_WRITES - 1)) begin
            state <= IDLE;
            counter <= 0;
          end
          else
            counter <= counter + 1;
        end
      end
      endcase
    end

endmodule
