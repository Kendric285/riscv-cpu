`default_nettype none

`define macro


// control flow ops are the offset added to the PC

typedef enum logic [6:0] {
    OP_R = 7'b0110011,
    OP_IMM = 7'b0010011,
    OP_LOAD = 7'b0000011,
    OP_STORE = 7'b0100011,
    OP_BRANCH = 7'b1100011, // implicit 0 added to imm output
    OP_LUI = 7'b0110111, 
    OP_JAL = 7'b1101111, // 
    OP_JALR = 7'b1100111 
} opcode_t;

module imm_gen(
    input logic [31:0] instr,
    output logic [31:0] imm
);

    opcode_t opcode;
    assign opcode = (opcode_t)'(instr[7:0]);
    logic [11:0] reconstructed;
    always_comb begin
        opcode = instr[7:0];
        reconstructed = 'd0;
        case(opcode)
            OP_IMM, OP_LOAD: 
                imm = (instr[31]) ? ({20'hF_FFFF}, instr[31:20]) : ({20'b0,instr[31:20]});
            OP_STORE:
                imm = (instr[31]) ? ({20'hF_FFFF,instr[32:20],instr[11:7]}) : ({20'b0,instr[31:25], instr[11:7]});
            OP_BRANCH: begin
                reconstructed = {instr[31],instr[7],instr[30:25],instr[11:8]};
                imm = (instr[31]) ? ({19'h5_FFFF, reconstructed, 'b0}) : ({19'b0, reconstructed, 'b0});
            end
            OP_LUI: 
                imm = {instr[31:12], 12'b0};
            OP_JAL:
                imm = {{11{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21], 1'b0};             
            OP_JALR:
                imm = {{20{instr[31]}}, instr[31:20]};
            default: imm = 32'b0;
        endcase
    end
endmodule