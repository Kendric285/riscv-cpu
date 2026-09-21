`default_nettype none

module mux4(
    input logic [31:0] in0,
    input logic [31:0] in1,
    input logic [31:0] in2,
    input logic [31:0] in3,
    input logic [1:0]  sel,
    output logic [31:0] out
);

    logic [31:0] in [0:3];

    assign in = '{in0, in1, in2, in3};
    assign out = in[sel];

endmodule