`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2025 11:55:35
// Design Name: 
// Module Name: puf_bit
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


module puf_bit(
    input wire[10:0] chall,
    input wire clk, rst, en,
    output wire [1:0]resp, 
    output wire finish
   // output wire mux_out_1, mux_out_2
);

    localparam n_ro = 32;
    localparam n_half = n_ro / 2;

    wire[n_ro-1:0] ro_out;

    wire mux_out_1, mux_out_2;
    wire ctr_out_1, ctr_out_2;

    RO ro_array_1[n_half-1:0] (en,chall[10:8],ro_out[n_half-1:0]);
    RO ro_array_2[n_half-1:0] (en,chall[10:8] ,ro_out[n_ro-1:n_half]);

    mux_16 mux_1(ro_out[n_half-1:0], chall[3:0], mux_out_1);
    mux_16 mux_2(ro_out[n_ro-1:n_half], chall[7:4], mux_out_2);

    counter cnt_1(mux_out_1, clk, rst, ctr_out_1);
    counter cnt_2(mux_out_2, clk, rst, ctr_out_2);

    arbiter race_arb(ctr_out_1, ctr_out_2, clk, rst, resp, finish);

endmodule
