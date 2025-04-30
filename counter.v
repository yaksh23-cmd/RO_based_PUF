`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2025 11:50:38
// Design Name: 
// Module Name: counter
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




module counter(
    input wire in, clk, rst,
    output wire out
);
    reg [15:0] ctr;
    reg [15:0] threshold = 16'b11111111_11111111;
    reg finish;

    assign out = finish;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ctr <= 0;
            finish <= 0;
        end
        else begin
            if (in) begin
                ctr <= ctr + 1;
                if (ctr == threshold) begin
                    finish <= 1;
                end
            end
            else begin
                ctr <= 0;
                finish <= 0;
            end
        end
    end
endmodule