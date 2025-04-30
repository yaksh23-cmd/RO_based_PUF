`timescale 1ns / 1ps

module top_design (
    input clk,
    input rst,
    input uart_rx,
    output uart_tx
);

    // UART parameters
    parameter CLKS_PER_BIT = 868;  // For 115200 baud @ 100MHz

    // UART signals
    wire [7:0] rx_byte;
    wire rx_dv;
    wire tx_done;
    reg tx_dv;
    reg [7:0] tx_byte;

    // Challenge collection
    reg [10:0] challenge;
    reg en_puf;

    // PUF signals
    wire resp;
    wire finish;

    // UART Receiver (using improved version with reset)
    uart_rx1 #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) uart_rx_inst (
        .i_Clock(clk),
        .i_Rx_Serial(uart_rx),
        .i_Reset(rst),          // Added reset
        .o_Rx_DV(rx_dv),
        .o_Rx_Byte(rx_byte)
    );

    // UART Transmitter (using improved version with reset)
    
    
    uart_tx2 #(.CLKS_PER_BIT(CLKS_PER_BIT)) uart_tx21 (
            .clk(clk),
            .rst(rst),
            .tx_dv(tx_dv),
            .tx_byte(tx_byte),
            .tx(uart_tx),
            .tx_done(tx_done)
        );

    // State machine for input + trigger PUF
    reg [2:0] state = 0;
    reg [1:0] byte_count = 0;  // Now used to track bytes

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            byte_count <= 0;
            en_puf <= 0;
            tx_dv <= 0;
            tx_byte <= 0;       // Reset tx_byte
            challenge <= 0;     // Reset challenge
        end else begin
            case (state)
                0: begin  // Wait for first byte
                    en_puf <= 0;
                    if (rx_dv) begin
                        challenge[10:3] <= rx_byte;
                        byte_count <= 1;
                        state <= 1;
                    end
                end

                1: begin  // Wait for second byte
                    if (rx_dv) begin
                        challenge[2:0] <= rx_byte[2:0];
                        byte_count <= 2;
                        en_puf <= 1;      // Trigger PUF
                        state <= 2;
                    end
                end

                2: begin  // Wait for PUF finish
                    if (finish) begin
                        en_puf <= 0;      // Ensure PUF is disabled
                        tx_byte <= {7'b0, resp};
                        tx_dv <= 1;
                        state <= 3;
                    end
                end

                3: begin  // Wait for transmission done
                    if (tx_done) begin
                        tx_dv <= 0;
                        byte_count <= 0;
                        state <= 0;
                    end
                end

                default: state <= 0;
            endcase
        end
    end

    // Instantiate PUF
    puf_bit u_puf (
        .clk(clk),
        .rst(rst),
        .en(en_puf),
        .chall(challenge),
        .resp(resp),
        .finish(finish)
    );

endmodule