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
    output [1:0] alu_op       // ALUOp passed to ALU Control unit
    //output       jump,
    //output       i_type // lui=1, ori=0
);

    reg temp_reg_dst;
    reg temp_alu_src;
    reg temp_mem_to_reg;
    reg temp_reg_write;
    reg temp_mem_read;
    reg temp_mem_write;
    reg temp_branch;
    reg [1:0] temp_alu_op;
    //reg temp_i_type;

    assign reg_dst = temp_reg_dst;
    assign alu_src = temp_alu_src;
    assign mem_to_reg = temp_mem_to_reg;
    assign reg_write = temp_reg_write;
    assign mem_read = temp_mem_read;
    assign mem_write = temp_mem_write;
    assign branch = temp_branch;
    assign alu_op = temp_alu_op;
    //assign i_type = temp_i_type;
    
    /* implement "combinational" logic satisfying requirements in FIGURE 4.18 */
    /* You can check the "Green Card" to get the oegpcode/funct for each instruction. */
    always @(*) begin
        case (opcode)
            6'b000000: begin // R-Type
                temp_reg_dst = 1'b1;
                temp_alu_src = 1'b0;
                temp_mem_to_reg = 1'b0;
                temp_reg_write = 1'b1;
                temp_mem_read = 1'b0;
                temp_mem_write = 1'b0;
                temp_branch = 1'b0;
                temp_alu_op = 2'b10;
            end
            6'b100011: begin //lw ((hex->23
                temp_reg_dst = 1'b0;
                temp_alu_src = 1'b1;
                temp_mem_to_reg = 1'b1;
                temp_reg_write = 1'b1;
                temp_mem_read = 1'b1;
                temp_mem_write = 1'b0;
                temp_branch = 1'b0;
                temp_alu_op = 2'b00;
            end
            6'b101011: begin //sw ((hex->2b
                //temp_reg_dst = 1'bx;
                temp_alu_src = 1'b1;
                //temp_mem_to_reg = 1'bx;
                temp_reg_write = 1'b0;
                temp_mem_read = 1'b0;
                temp_mem_write = 1'b1;
                temp_branch = 1'b0;
                temp_alu_op = 2'b00;
            end 
            6'b000100: begin //beq ((hex->4
                //temp_reg_dst = 1'bx;
                temp_alu_src = 1'b0;
                //temp_mem_to_reg = 1'bx;
                temp_reg_write = 1'b0;
                temp_mem_read = 1'b0;
                temp_mem_write = 1'b0;
                temp_branch = 1'b1;
                temp_alu_op = 2'b01;
            end
            6'b001000: begin //addi ((hex->8
                temp_reg_dst = 1'b0;
                temp_alu_src = 1'b1;
                temp_mem_to_reg = 1'b0;
                temp_reg_write = 1'b1;
                temp_mem_read = 1'b0;
                temp_mem_write = 1'b0;
                temp_branch = 1'b0;
                temp_alu_op = 2'b00; //add
            end
            default begin
                temp_reg_dst = 1'b0;
                temp_alu_src = 1'b0;
                temp_mem_to_reg = 1'b0;
                temp_reg_write = 1'b0;
                temp_mem_read = 1'b0;
                temp_mem_write = 1'b0;
                temp_branch = 1'b0;
                temp_alu_op = 2'b00;
            end
        endcase
    end
endmodule
