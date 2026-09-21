`default_nettype none

module tb_en_reg();

    logic clk;
    
    initial begin
        clk = 0;
        forever begin
            #5;
            clk = ~clk;
        end 
    end
        
    logic [31:0] d,q;
    logic reset_n, en; 
    en_reg DUT(.*);

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_en_reg);

        reset_n = 0; d = 'd0; en = 0;
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset_n = 1; d = 'd1; en = 1;
        @(negedge clk);
        d = 'd2;
        @(negedge clk);
        d = 'd3;
        repeat (4) @(posedge clk);
        $display("\nPassed");
        $finish;
    end
    // Reset
    assert property (
        @(posedge clk) !reset_n |=> (q == '0)
    ) else $error("Reset failed: q = %d, expected 0", q);


    // Enable
    assert property (
        @(posedge clk) (reset_n && en) |=> (q == $past(d))
    ) else $error("Enable failed: q = %d, expected previous d = %d", q, $past(d));


    // Hold
    assert property (
        @(posedge clk) (reset_n && !en) |=> (q == $past(q))
    ) else $error("Hold failed: q = %d, expected previous q = %d", q, $past(q));
    
endmodule