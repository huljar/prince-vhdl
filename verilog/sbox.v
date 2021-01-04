//-- Substitution box of PRINCE

module sbox(
  input wire [3:0] data_in,
  output reg [3:0] data_out
);

  always @(data_in) begin
    case(data_in)
    4'h0 : begin
      data_out <= 4'hB;
    end
    4'h1 : begin
      data_out <= 4'hF;
    end
    4'h2 : begin
      data_out <= 4'h3;
    end
    4'h3 : begin
      data_out <= 4'h2;
    end
    4'h4 : begin
      data_out <= 4'hA;
    end
    4'h5 : begin
      data_out <= 4'hC;
    end
    4'h6 : begin
      data_out <= 4'h9;
    end
    4'h7 : begin
      data_out <= 4'h1;
    end
    4'h8 : begin
      data_out <= 4'h6;
    end
    4'h9 : begin
      data_out <= 4'h7;
    end
    4'hA : begin
      data_out <= 4'h8;
    end
    4'hB : begin
      data_out <= 4'h0;
    end
    4'hC : begin
      data_out <= 4'hE;
    end
    4'hD : begin
      data_out <= 4'h5;
    end
    4'hE : begin
      data_out <= 4'hD;
    end
    4'hF : begin
      data_out <= 4'h4;
    end
    default : begin
      data_out <= 4'hx;
    end
    endcase
  end

endmodule
