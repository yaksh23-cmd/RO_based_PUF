`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2025 11:53:21
// Design Name: 
// Module Name: arbiter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module arbiter (
    input wire out_1, out_2, clk, rst,
    output reg [1:0]resp,
    output wire finish
);
    reg marked_1, marked_2;
   // reg  tmp_res;
    wire win_1,win_2;
    
    assign win_1 = (out_1 & ~out_2 );
    assign win_2 = (out_2 & ~out_1 );
    assign finish = (marked_1 | marked_2);
    


    always @ (posedge clk) begin
        if ((marked_1 == 1'bx && marked_2 == 1'bx) || rst) begin
            marked_1 <= 0;
            marked_2 <= 0;
        end

        if (win_1) begin
            resp <= 2'b01;
            marked_1 <= 1;
        end

        else if (win_2) begin
            resp <= 2'b10;
            marked_2 <= 1;
        end
        
    end
    
    
endmodule