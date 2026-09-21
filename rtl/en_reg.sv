`default_nettype none

module en_reg(
    input logic reset_n, en, clk,
    input logic [31:0] d,
    output logic [31:0] q
);
    always_ff @(posedge clk)
        if(!reset_n)
            q <= 'd0;
        else if(en)
            q <= d;
    
endmodule