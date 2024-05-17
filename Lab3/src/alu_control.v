`timescale 1ns / 1ps
// <110550143>

/** [Reading] 4.4 p.316-318
 * "The ALU Control"
 */
/**
 * This module is the ALU control in FIGURE 4.17
 * You can implement it by any style you want.==
 * There's a more hardware efficient design in Appendix D.
 */

/* checkout FIGURE 4.12/13 */
module alu_control (
    input  [1:0] alu_op,    // ALUOp
    input  [5:0] funct,     // Funct field
    output [3:0] operation  // Operation=+
);

    reg [3:0] temp_operation;
    assign operation = temp_operation;
    
    /* implement "combinational" logic satisfying requirements in FIGURE 4.12 */
    always @(*) begin
        case (alu_op)
            2'b00: temp_operation = 4'b0010; //add, -> lw, sw
            2'b01: temp_operation = 4'b0110; // sub -> beq
            2'b10: begin //R-type
                case (funct[3:0])
                    4'b0000: temp_operation = 4'b0010; //add
                    4'b0010: temp_operation = 4'b0110; //sub
                    4'b0100: temp_operation = 4'b0000; //AND
                    4'b0101: temp_operation = 4'b0001; //OR
                    4'b1010: temp_operation = 4'b0111; //slt
                    default: temp_operation = 4'b0000;
                endcase
           end
           //2'b11: temp_operation = 4'b0010; //addi
           default: temp_operation = 4'b0000;
       endcase
   end
    

endmodule
