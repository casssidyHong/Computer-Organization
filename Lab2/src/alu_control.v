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

    reg operation;
    
    /* implement "combinational" logic satisfying requirements in FIGURE 4.12 */
    always @(*) begin
        case (alu_op)
            2'b00: operation = 4'b0010; //add, -> lw, sw
            2'b01: operation = 4'b0110; // sub -> beq
            2'b10: begin //R-type
                case (funct[3:0])
                    4'b0000: operation = 4'b0010; //add
                    4'b0010: operation = 4'b0110; //sub
                    4'b0100: operation = 4'b0000; //AND
                    4'b0101: operation = 4'b0001; //OR
                    4'b1010: operation = 4'b0111; //slt
                    default: operation = 4'b1111;
                endcase
           end
           default: operation = 4'b1111;
       endcase
   end
    

endmodule
