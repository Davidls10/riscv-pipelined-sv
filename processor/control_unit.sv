module alu_decoder (output logic [3-1:0] alu_control,
                    input logic [2-1:0] alu_op,
                    input logic [3-1:0] funct3,
                    input logic funct7_5,
                    input logic op5);

    always_comb begin
        case (alu_op)
            2'b00: // lw, sw
                begin
                    alu_control = 3'b000; // add
                end
            2'b01: // beq
                begin
                    alu_control = 3'b001; // subtract
                end
            2'b10: // add
                case (funct3)
                    3'b000: // add for {op5, funct7_5} == 2'b00, 2'b01, 2'b10; subtract for {op5, funct7_5} == 2'b11
                        alu_control = ({op5, funct7_5} == 2'b00 || {op5, funct7_5} == 2'b01 || {op5, funct7_5} == 2'b10) ? 3'b000 : 3'b001;
                    3'b010:
                        alu_control = 3'b101; // set less than
                    3'b110:
                        alu_control = 3'b011; // or
                    3'b111:
                        alu_control = 3'b010; // and
                        
                    default: alu_control = 3'bx;
                endcase
                
            default: alu_control = 3'bx;
        endcase
    end
endmodule

module main_decoder (input logic [7-1:0] opcode,
                     output logic reg_write,
                     output logic [2-1:0] imm_src,
                     output logic alu_src,
                     output logic mem_write,
                     output logic [2-1:0] result_src,
                     output logic branch,
                     output logic [2-1:0] alu_op,
                     output logic jump
                    );

    always_comb begin
        case (opcode)
            7'b0000011: // lw
                begin
                    reg_write = 1'b1;
                    imm_src = 2'b00;
                    alu_src = 1'b1;
                    mem_write = 1'b0;
                    result_src = 2'b01;
                    branch = 1'b0;
                    alu_op = 2'b00;
                    jump = 1'b0;
                end
            7'b0100011: // sw
                begin
                    reg_write = 1'b0;
                    imm_src = 2'b01;
                    alu_src = 1'b1;
                    mem_write = 1'b1;
                    result_src = 2'bxx;
                    branch = 1'b0;
                    alu_op = 2'b00;
                    jump = 1'b0;
                end
            7'b0110011: // R-type instructions
                begin
                    reg_write = 1'b1;
                    imm_src = 2'bxx;
                    alu_src = 1'b0;
                    mem_write = 1'b0;
                    result_src = 2'b00;
                    branch = 1'b0;
                    alu_op = 2'b10;
                    jump = 1'b0;
                end
            7'b1100011: // beq
                begin
                    reg_write = 1'b0;
                    imm_src = 2'b10;
                    alu_src = 1'b0;
                    mem_write = 1'b0;
                    result_src = 2'bxx;
                    branch = 1'b1;
                    alu_op = 2'b01;
                    jump = 1'b0;
                end
            7'b0010011: // addi
                begin
                    reg_write = 1'b1;
                    imm_src = 2'b00;
                    alu_src = 1'b1;
                    mem_write = 1'b0;
                    result_src = 2'b00;
                    branch = 1'b0;
                    alu_op = 2'b10;
                    jump = 1'b0;
                end
            7'b1101111: // jal
                begin
                    reg_write = 1'b1;
                    imm_src = 2'b00;
                    alu_src = 1'b1;
                    mem_write = 1'b0;
                    result_src = 2'b10;
                    branch = 1'b0;
                    alu_op = 2'bxx;
                    jump = 1'b1;
                end

            default:
                begin
                    reg_write = 1'bx;
                    imm_src = 2'bxx;
                    alu_src = 1'bx;
                    mem_write = 1'bx;
                    result_src = 2'bxx;
                    branch = 1'bx;
                    alu_op = 2'bxx;
                    jump = 1'bx;   
                end
        endcase
    end

endmodule
