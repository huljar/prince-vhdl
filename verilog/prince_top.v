module prince_top
#( parameter TEXT_SIZE=64,
	parameter KEY_SIZE=128,
	parameter SBOX_NUMBER=16) (
  input [TEXT_SIZE-1:0] plaintext, //-- 64 bit plaintext block
  input [KEY_SIZE-1:0] key, //-- 128 bit key
  input mode, //-- crypto mode 0=enc, 1=dec
  output wire [TEXT_SIZE-1:0] ciphertext //-- 64 bit encrypted block
);

//-- Intermediate signals for splitting the key into the whitening keys k0
//-- and k0_end, and the key k1 which is used in prince_core

reg [KEY_SIZE/2-1:0] k0_start;
reg [KEY_SIZE/2-1:0] k0_end;
reg [KEY_SIZE/2-1:0] k1;

wire [KEY_SIZE/2-1:0] alpha = {{(KEY_SIZE/2-64){1'b0}}, 64'hC0AC29B7C97C50DD};

//-- Data I/O for prince_core

wire [TEXT_SIZE-1:0] core_in, core_out;

//-- Key extension/whitening keys

always @(*)
	case(mode)
		1'b0: begin //-- encryption
                      k0_start = key[127:64];
                      k0_end = {key[64],key[127:66],(key[65] ^ key[127])};
                      k1 = key[63:0];
		end
		1'b1: begin //-- decryption
                      k0_start = {key[64],key[127:66],(key[65] ^ key[127])};
                      k0_end = key[127:64];
                      k1 = key[63:0] ^ alpha;
		end
		default: begin //-- encryption by default
                      k0_start = key[127:64];
                      k0_end = {key[64],key[127:66],(key[65] ^ key[127])};
                      k1 = key[63:0];
		end
	endcase


//-- prince_core instance
  
assign core_in = plaintext ^ k0_start;
assign ciphertext = core_out ^ k0_end;

prince_core #(
	.TEXT_SIZE(TEXT_SIZE),
	.KEY_SIZE(KEY_SIZE),
	.SBOX_NUMBER(SBOX_NUMBER)
) i_prince_core (
    .data_in(core_in),
    .key(k1),
    .data_out(core_out)
    );

endmodule
