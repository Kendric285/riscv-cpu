`default_nettype none

// module alu(
//     input logic [31:0] a,
//     input logic [31:0] b, 
//     input logic [2:0] sel,
//     output logic [31:0] out
// );


module tb_alu();

    logic [31:0] a,b,out;
    logic [2:0] sel;

    alu DUT(.*);

    task automatic check(
        input logic [31:0] test_a, test_b,
        input logic [2:0] test_sel,
        input logic [31:0] expected
    );
        a = test_a;
        b = test_b; 
        sel = test_sel;
        #1;
        assert(out == expected)
        else $display("Expected: %d | Output: %d\n", out, expected);
    endtask

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_alu);

        // ADD
        check(32'd0,32'd0,3'b000,32'd0);
        check(32'd1,32'd1,3'b000,32'd2);
        check(32'hFFFFFFFF,32'd1,3'b000,32'h00000000);

        // SUB
        check(32'd5,32'd3,3'b001,32'd2);
        check(32'd0,32'd1,3'b001,32'hFFFFFFFF);

        // AND
        check(32'hF0F0F0F0,32'h0FF00FF0,3'b010,32'h00F000F0);

        // OR
        check(32'hF0000000,32'h000000FF,3'b011,32'hF00000FF);

        // XOR
        check(32'hAAAAAAAA,32'h55555555,3'b100,32'hFFFFFFFF);

        // SLL
        check(32'd1,32'd1,3'b101,32'd2);
        check(32'd1,32'd31,3'b101,32'h80000000);
        check(32'd1,32'd32,3'b101,32'd1);

        // SRL
        check(32'h80000000,32'd1,3'b110,32'h40000000);
        check(32'h80000000,32'd31,3'b110,32'd1);
        check(32'h80000000,32'd32,3'b110,32'h80000000);

        $display("Test Finished\n");
        $finish;
    end
endmodule