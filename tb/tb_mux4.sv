`default_nettype none

module tb_mux4(); 
    logic [31:0] in [0:3];
    logic [1:0] sel;
    logic [31:0] out;
    logic clk;

    mux4 DUT(
        .in0(in[0]), 
        .in1(in[1]), 
        .in2(in[2]),
        .in3(in[3]),
        .sel(sel), 
        .out(out) 
    );

    initial begin 
        clk = 0;
        forever begin
            #5;
            clk = ~clk;
        end
    end

    assert property (
        @(posedge clk) out == in[sel]
    ) else $error("MUX ERROR: sel=%0d expected=%h got=%h", sel, in[sel], out);

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb);

        in[0] = 32'h1111_1111;
        in[1] = 32'h2222_2222;
        in[2] = 32'h3333_3333;
        in[3] = 32'h4444_4444;

        @(negedge clk);
        sel = 2'd0;

        @(negedge clk);
        sel = 2'd1;

        @(negedge clk);
        sel = 2'd2;

        @(negedge clk);
        sel = 2'd3;

        @(negedge clk);
        in[0] = 32'hDEAD_BEEF;
        in[1] = 32'hCAFE_BABE;
        in[2] = 32'h1234_5678;
        in[3] = 32'h8765_4321;
        sel = 2'd0;

        @(negedge clk);
        sel = 2'd1;

        @(negedge clk);
        sel = 2'd2;

        @(negedge clk);
        sel = 2'd3;

        @(posedge clk);
        $display("All mux4 tests completed.");
        $finish;
    end


endmodule