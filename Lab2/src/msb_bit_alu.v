`timescale 1ns / 1ps
// <110550143>

/* checkout FIGURE C.5.10 (Bottom) */
/* [Prerequisite] complete bit_alu.v */
module msb_bit_alu (
    input        a,          // 1 bit, a
    input        b,          // 1 bit, b
    input        less,       // 1 bit, Less
    input        a_invert,   // 1 bit, Ainvert
    input        b_invert,   // 1 bit, Binvert
    input        carry_in,   // 1 bit, CarryIn
    input  [1:0] operation,  // 2 bit, Operation
    output       result,     // 1 bit, Result (Must it be a reg?)
    output       set,        // 1 bit, Set
    output       overflow    // 1 bit, Overflow
);

    /* Try to implement the most significant bit ALU by yourself! */
    reg result;
    wire ai, bi;
    wire sum, carry_out;
    wire tmp;

    assign ai = (a_invert) ? ~a : a;
    assign bi = (b_invert) ? ~b : b;

    // sum and carry_out
    assign carry_out = (ai & bi) | tmp;
    assign tmp = (ai & carry_in) | (bi & carry_in);
    assign sum = ai ^ bi ^ carry_in;
    
   // assign less = ((operation == 2'b11) && (sum<0)) ? 1 : 0;

    // overflow and set
    assign overflow = ((operation == 2'b10 )) ? carry_in ^ carry_out : 0;
    assign set = temp;
    
    reg temp;
    always @(*) begin
        if(a==1 && b==0) temp<=1;
        else if (a==0 && b==1) temp<=0;
        else if (a==1) temp<=~carry_out;
        else if (a==0) temp<=carry_out;
    end
    
    
    // result
    always @(*) begin
        case (operation)
            2'b00: result <= ai & bi;  // AND
            2'b01: result <= ai | bi;  // OR
            2'b10: result <= ai ^ bi ^ carry_in;  // ADD
            2'b11: result <= less;  // SLT
            default: result <= 0;  // should not happened
        endcase
    end



endmodule
