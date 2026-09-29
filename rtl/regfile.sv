`default_nettype none


module regfile(
    input logic [4:0] A1, A2, A3, 
    input logic [31:0] W3,
    input logic clk, reset_n,
    output logic [31:0] R1, R2
);

    logic [31:0] mem [0:31];
    assign R1 = mem[A1];
    assign R2 = mem[A2]; 

    always_ff @(posedge clk) begin
        if(!reset_n) begin
            for(int i = 0; i < 32; i++) begin
                mem[i] <= 32'b0;
            end
        end
        else if(A3 != 5'b0) begin
            mem[A3] <= W3;
        end 
    end

endmodule