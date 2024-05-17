`timescale 1ns / 1ps
// <110550143>

/** [Reading] 4.4 p.318-321
 * "Designing the Main Control Unit"
 */
/** [Prerequisite] alu_control.v
 * This module is the Control unit in FIGURE 4.17
 * You can implement it by any style you want.
 */

/* checkout FIGURE 4.16/18 to understand each definition of control signals */
module control (
    input  [5:0] opcode,      // the opcode field of a instruction is [?:?]   31-26
    output       reg_dst,     // select register destination: rt(0), rd(1)
    output       alu_src,     // select 2nd operand of ALU: rt(0), sign-extended(1)
    output       mem_to_reg,  // select data write to register: ALU(0), memory(1)
    output       reg_write,   // enable write to register file
    output       mem_read,    // enable read form data memory
    output       mem_write,   // enable write to data memory
    output       branch,      // this is a branch instruction or not (work with alu.zero)
    output [1:0] alu_op,       // ALUOp passed to ALU Control unit
    output       jump,
    output       i_type // lui=1, ori=0
);

    reg reg_dst;
    reg alu_src;
    reg mem_to_reg;
    reg reg_write;
    reg mem_read;
    reg mem_write;
    reg branch;
    reg alu_op;
    reg jump;
    reg i_type;

    /* implement "combinational" logic satisfying requirements in FIGURE 4.18 */
    /* You can check the "Green Card" to get the oegpcode/funct for each instruction. */
    always @(*) begin
        case (opcode)
            2'b000000: begin // R-Type
                reg_dst = 1'b1;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b01;
                jump = 1'b0;
            end
            2'b100011: begin //lw
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
            2'b101011: begin //sw
                reg_dst = 1'bx;
                alu_src = 1'b1;
                mem_to_reg = 1'bx;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b1;
                branch = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end 
            2'b000100: begin //beq
                reg_dst = 1'bx;
                alu_src = 1'b0;
                mem_to_reg = 1'bx;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b1;
                alu_op = 2'b01;
                jump = 1'b0;
            end
            1'h2: begin //jump
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                jump = 1'b1;
            end
            1'hf: begin //lui 1111
                reg_dst = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                alu_op = 2'b11;
                jump = 1'b0;
                i_type = 1'b1;
            end
            1'hd: begin //ori  1101
                reg_dst = 1'bx;
                alu_src = 1'b1;
                mem_to_reg = 1'bx;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b1;
                branch = 1'b0;
                alu_op = 2'b11;
                jump = 1'b0;
                i_type = 1'b0;
            end
            default begin
                reg_dst = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
        endcase
    end
endmodule
