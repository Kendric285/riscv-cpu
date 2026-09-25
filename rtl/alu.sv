`default_nettype none

/*
Valid sel bits are 0-6 and they are assigned respectively to 
the operations below.
ADD, SUB, AND, OR, XOR, SLL, SRL.

A is the first operand and B is the second

*/

module alu(
    input logic [31:0] a,
    input logic [31:0] b, 
    input logic [2:0] sel,
    output logic [31:0] out
);
    always_comb begin
        case(sel)
            3'b000: out = a + b;
            3'b001: out = a - b;
            3'b010: out = a & b;
            3'b011: out = a | b;
            3'b100: out = a ^ b;
            3'b101: out = a << b[4:0];
            3'b110: out = a >> b[4:0];
            default: out = 32'd0;
        endcase
    end

endmodule