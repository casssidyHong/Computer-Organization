`timescale 1ns / 1ps
// <110550143>

module alu (
    input  [31:0] a,        // 32 bits, source 1 (A)
    input  [31:0] b,        // 32 bits, source 2 (B)
    input  [ 3:0] ALU_ctl,  // 4 bits, ALU control input
    output [31:0] result,   // 32 bits, result
    output        zero,     // 1 bit, set to 1 when the output is 0
    output        overflow  // 1 bit, overflow
);

    assign overflow = 0;
    reg [32-1:0] result1;
    reg overflow1 = 0;
    assign result = result1;
    assign overflow = overflow1;
    assign zero = (result == 0) ? 1 : 0;//zero is 1 if result is 0

    always@(*) begin
        //$display("alusrc1: %d alusrc2: %d ALU_operation_i:%b",aluSrc1, aluSrc2, ALU_operation_i);
      case(ALU_ctl)
            4'b0010: begin //add
                result1 = a + b;
                    if(a >= 0 && b >= 0 && result1[31] == 1)//p + p = n
                      overflow1 = 1;
                    else if(a < 0 && b < 0 && result1[31] == 0)//n + n = p
                      overflow1 = 1;
                end
            4'b0110:begin //sub
                result1 = a - b;
                if(a >= 0 && b < 0 && result1[31] == 1)//p - n = n
                    overflow1 = 1;
                else if(a < 0 && b >= 0 && result1[31] == 0)//n - p = p
                    overflow1 = 1;
            end
            4'b0000: result1 = a & b;//and
            4'b0001: result1 = a | b;//or
            4'b0111: begin
                result1 = a - b; //slt
                if(a >= 0 && b < 0 && result1[31] == 1)//p - n = n
                    result1 = 0;
                else if(a < 0 && b >= 0 && result1[31] == 0)//n - p = p
                    result1 = 1;
                else if(result1[31] == 1) result1 = 1;
                else result1 = 0;
            end
            default: result1 = 0;
          endcase
    end
    

endmodule
