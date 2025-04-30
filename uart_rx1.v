`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2025 19:38:24
// Design Name: 
// Module Name: uart_rx1
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




module uart_rx1 #(
    parameter CLKS_PER_BIT = 868  // For 115200 baud @ 100MHz
)(
    input        i_Clock,
    input        i_Rx_Serial,
    input        i_Reset,         // Added reset signal
    output reg   o_Rx_DV,
    output reg [7:0] o_Rx_Byte
);

    localparam IDLE         = 3'b000;
    localparam START_BIT    = 3'b001;
    localparam DATA_BITS    = 3'b010;
    localparam STOP_BIT     = 3'b011;
    localparam CLEANUP      = 3'b100;

    reg [2:0] r_SM_Main     = 0;
    reg [9:0] r_Clock_Count = 0;  // Reduced to 10 bits, sufficient for 868
    reg [2:0] r_Bit_Index   = 0;
    reg [7:0] r_Rx_Byte     = 0;

    always @(posedge i_Clock or posedge i_Reset) begin
        if (i_Reset) begin
            r_SM_Main     <= IDLE;
            o_Rx_DV       <= 0;
            o_Rx_Byte     <= 0;
            r_Clock_Count <= 0;
            r_Bit_Index   <= 0;
            r_Rx_Byte     <= 0;
        end else begin
            case (r_SM_Main)
                IDLE: begin
                    o_Rx_DV       <= 0;
                    r_Clock_Count <= 0;
                    r_Bit_Index   <= 0;
                    if (i_Rx_Serial == 0)
                        r_SM_Main <= START_BIT;
                end

                START_BIT: begin
                    if (r_Clock_Count == (CLKS_PER_BIT - 1)/2) begin
                        r_Clock_Count <= 0;
                        r_SM_Main     <= (i_Rx_Serial == 0) ? DATA_BITS : IDLE;
                    end else begin
                        r_Clock_Count <= r_Clock_Count + 1;
                    end
                end

                DATA_BITS: begin
                    if (r_Clock_Count < CLKS_PER_BIT - 1) begin
                        r_Clock_Count <= r_Clock_Count + 1;
                    end else begin
                        r_Clock_Count <= 0;
                        r_Rx_Byte[r_Bit_Index] <= i_Rx_Serial;
                        r_Bit_Index <= r_Bit_Index + 1;
                        r_SM_Main   <= (r_Bit_Index < 7) ? DATA_BITS : STOP_BIT;
                    end
                end

                STOP_BIT: begin
                    if (r_Clock_Count < CLKS_PER_BIT - 1) begin
                        r_Clock_Count <= r_Clock_Count + 1;
                    end else if (i_Rx_Serial == 1) begin  // Verify stop bit
                        r_Clock_Count <= 0;
                        o_Rx_DV       <= 1;
                        o_Rx_Byte     <= r_Rx_Byte;       // Update output directly
                        r_SM_Main     <= CLEANUP;
                    end else begin
                        r_Clock_Count <= 0;
                        r_SM_Main     <= IDLE;            // Framing error
                    end
                end

                CLEANUP: begin
                    o_Rx_DV   <= 0;
                    r_SM_Main <= IDLE;
                end

                default: r_SM_Main <= IDLE;
            endcase
        end
    end

endmodule
