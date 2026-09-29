module tb_regfile();

    logic clk, reset_n;
    logic [4:0] A1, A2, A3;
    logic [31:0] W3, R1, R2;

    regfile DUT(.*);

    initial begin
        clk = 0;
        forever begin
            #5; 
            clk = ~clk;
        end
    end


    property p_x0_zero_r1;
        @(posedge clk) (A1 == 5'd0) |-> (R1 == 32'd0);
    endproperty
    assert property (p_x0_zero_r1);

    property p_x0_zero_r2;
        @(posedge clk) (A2 == 5'd0) |-> (R2 == 32'd0);
    endproperty

    assert property (p_x0_zero_r2);

    property p_write_readback_r1;
        @(posedge clk)
        disable iff (!reset_n)
        (A3 != 5'd0 && A1 == A3) |=> (R1 == $past(W3));
    endproperty

    assert property (p_write_readback_r1);

    property p_write_readback_r2;
        @(posedge clk)
        disable iff (!reset_n)
        (A3 != 5'd0 && A2 == A3) |=> (R2 == $past(W3));
    endproperty

    assert property (p_write_readback_r2);

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_regfile);

        A1 = 0;
        A2 = 0;
        A3 = 0;
        W3 = 0;
        reset_n = 1;

        @(negedge clk);
        reset_n = 0;

        @(posedge clk);
        reset_n = 1;

        @(negedge clk);
        A3 = 5'd1;
        W3 = 32'd10;
        A1 = 5'd1;

        @(negedge clk);
        A3 = 5'd2;
        W3 = 32'd20;
        A2 = 5'd2;

        @(negedge clk);
        A3 = 5'd0;
        W3 = 32'hFFFFFFFF;
        A1 = 5'd0;

        @(negedge clk);
        A3 = 5'd31;
        W3 = 32'hDEADBEEF;
        A1 = 5'd31;

        @(negedge clk);
        reset_n = 0;

        repeat(2) @(posedge clk);

        $display("Passed");
        $finish;
    end

endmodule